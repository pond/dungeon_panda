//
//  MusicPlaybackManager.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 21/03/21.
//

import Foundation
import UIKit
import CoreData
import MediaPlayer
import OSLog

protocol MusicPlaybackManagerDelegate
{
    /// Playback has been started - or rather, _requested_ but until `playbackResumed` is called,
    /// music may not actually be playing.
    func playbackStarted(
        playbackManager: MusicPlaybackManager,
             inPlaylist: Playlist,
              withTrack: Track
    )

    /// Called whenever playback progress updates are useful, e.g. every 1 second during normal
    /// playback.
    func playbackProgressChanged(
        playbackManager: MusicPlaybackManager,
             inPlaylist: Playlist,
              withTrack: Track,
               position: TimeInterval,
               duration: TimeInterval
    )

    /// Playback has been paused (or an equivalent of pausing has occurred).
    func playbackPaused(
        playbackManager: MusicPlaybackManager
    )

    /// Playback has been resumed after pausing, or has commenced after a start request.
    func playbackResumed(
        playbackManager: MusicPlaybackManager
    )

    /// The artwork for the currently playing item has been determined (FSVO "determined", given lots
    /// of bugs in the MediaPlayer API when it comes to providing non-`nil`, but still missing artwork).
    func playbackArtworkWasDetermined(
        artwork: MPMediaItemArtwork
    )

    /// The current media item is expected to change very soon, invalidating any artwork that may be
    /// being displayed in relation to it.
    func playbackArtworkWillBeInvalid()
}

class MusicPlaybackManager : NSObject
{
    public var delegates: [MusicPlaybackManagerDelegate] = []

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    let logger = Logger()

    /// Various timers, accessed by internally defined private timer name.
    var timers:[String:Timer] = [:]

    /// Standard fade-in duration, in seconds.
    let fadeInDuration  = 2.0

    /// Standard fade-out duration, in seconds. If the track is going to end sooner
    /// than expected, a fade-out may be run more quickly, or even skipped entirely.
    let fadeOutDuration = 3.0

    /// Delay before a next track is started in seconds, allowing for remote (e.g. Bluetooth)
    /// speaker lag, after a fade out completes.
    let afterFadeOutLagAllowance = 0.1

    /// Watchdog timer - once the music player is asked to start playback, if no "Playback
    /// started" events are seen in this many seconds, we give up and move to the next
    /// track manually... Sadly, Apple's MediaPlayer API is *extraordinarily* unreliable and
    /// we can't even rely on its own bugs with the "failed to prepare to play" error - it does
    /// not even generate that reliably, sometimes failing without any error at all.
    ///
    /// Note that iOS only runs timers for around 5 seconds when the application is inactive
    /// so this timer is the maximum we allow while in the foreground, else see
    /// `watchdogTimerInactiveWaitTime`.
    ///
    let watchdogTimerWaitTime = 10.0

    /// See `watchdogTimerWaitTime` for details; this time is used when the application
    /// is not active.
    ///
    let watchdogTimerInactiveWaitTime = 4.0

    /// A hidden volume slider given to us by the main view when it loads. This is
    /// an horrific hack arising from the bewildering lack of any way to simply set
    /// the playback volume for a MusicKit player.
    var hiddenSystemVolumeSlider: UISlider?

    /// Reference volume set by the user. Fading and track volumes are all scaled
    /// relative to this.
    var referenceSystemVolume: Double?

    /// The PlaylistManager used for all playlist operations; set via `init`.
    var playlistManager: PlaylistManager

    /// Time when playback was most recently started for a new track.
    var mostRecentPlaybackStartTimeInSeconds: TimeInterval?

    /// Set to whatever we want to start doing, once we commence something
    /// like a next-track / fade-out operation. If the user keeps changing
    /// their mind, these might change a few times before finally becoming
    /// set as Current.
    var targetPlaylist: Playlist?

    /// A recent self-initiated volume change has happened. Ignore spurious system events
    /// about this change; they are not user-initiated, probably! Set with a timer just before
    /// each change is made, then cleared by that timer a short time after.
    ///
    var ignoreVolumeNotificationsForAWhileBecauseIChangedIt = true
    
    /// Marks that a track fade-in operation is underway and volume change events should
    /// be ignored, since we're probably the source of them.
    var fadeInIsUnderway: Bool = false

    /// Marks that a track fade-in operation is underway and volume change events should
    /// be ignored, since we're probably the source of them.
    var fadeOutIsUnderway: Bool = false

    /// Marks that a change of track is underway. Whether or not fading is happening as part of that is
    /// not considered - it may or may not be.
    var trackChangeIsUnderway: Bool = false

    /// Marks that fade-in should run once actual playback starts on the next track.
    var fadeInOnNextPlaybackStartedEvent: Bool = false

    /// Solve multiple repeated "state did change" notifications when the state did not actually change.
    /// "Not playing" means paused, stopped, interrupted or seeking.
    var currentlyPlaying = false

    /// Solve multiple repeated "state did change" notifications when the state did not actually change.
    /// Seeking happens applies to movements forwards or backwards.
    var currentlySeeking = false

    init(playlistManager: PlaylistManager)
    {
        self.playlistManager         = playlistManager
        self.mediaPlayer.repeatMode  = .none
        self.mediaPlayer.shuffleMode = .off

        super.init()

        NotificationCenter.default.addObserver(
                self,
            selector: #selector(playbackStateDidChange),
                name: .MPMusicPlayerControllerPlaybackStateDidChange,
              object: nil
        )

        // Currently not needed:
        //
        // NotificationCenter.default.addObserver(
        //         self,
        //     selector: #selector(nowPlayingItemDidChange),
        //         name: .MPMusicPlayerControllerNowPlayingItemDidChange,
        //       object: nil
        // )

        self.mediaPlayer.beginGeneratingPlaybackNotifications()
    }

    // MARK: - PUBLIC: Playback control

    /**
     Start playback after initial application launch. Called externally, when the view layer
     believes it is "safe" / sensible to do so. Can be called from any thread.
     */
    func startPlaybackAtAppLaunch()
    {
        // As with all random wait loops, this is a hack. If we start too
        // soon, system volume is not readable from the UI volume control
        // even when we work off view-did-appear in the view layer.
        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            if let slider = self.hiddenSystemVolumeSlider
            {
                self.referenceSystemVolume = Double(slider.value)
            }

            if self.referenceSystemVolume == nil || self.referenceSystemVolume == 0
            {
                self.referenceSystemVolume = 0.5 // (Shrug)
            }

            // The playlist manager will have a 'now playing' playlist and
            // track from when the app last ran via CoreData, or will just
            // choose its own default starting point for first-ever-run.
            //
            let (currentPlaylist, currentTrack, _) = self.playlistManager.nowPlaying()

            self.startPlayback(playlist: currentPlaylist, track: currentTrack)
        }
    }

    /**
     Start playback from the given playlist; if this is the current playlist then the next
     track in that playlist is started, else an appropriate track is chosen from the new
     target playlist.

     - Parameter playlistID: Playlist *ID* to use.
    */
    func switchToPlaylist(playlistID: String)
    {
        self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: playlistID)

        logger.info("startPlayingNextInPlaylist: Playing from \(self.targetPlaylist!.id!)")
        logger.info("startPlayingNextInPlaylist: Store IDs \(self.targetPlaylist!.storeIDs)")

        self.transitionToNextTrack()
    }

    /**
     Called by the view layer when the user finishes dragging the position slider somewhere.

     - Parameter float: New UISlider position, from zero to duration, relative to track start/end offsets.
    */
    func positionSliderWasManuallyMoved(value: Float)
    {
        logger.debug("positionSliderWasManuallyMoved: Called")

        timerCancelAll(except: "position_updates")

        let playingTrack     = self.playlistManager.getPlayingTrack()
        var relativePosition = TimeInterval(value) + playingTrack.startOffset

        // This hack is necessary because of the inability in the API to
        // detect end-of-track other than "paused and at position zero". If a
        // user legitimatelly paused then dragged the slider full-left, we do
        // not want to generate the illusion of natural end-of-track.
        //
        if relativePosition < 0.1
        {
            relativePosition = 0.1
        }

        self.mediaPlayer.currentPlaybackTime = relativePosition

        if self.referenceSystemVolume != nil
        {
            setVolume(volume: self.referenceSystemVolume)
        }
    }

    func skipTrack()
    {
        transitionToNextTrack()
    }

    func pause()
    {
        self.mediaPlayer.pause()
    }

    func resume()
    {
        self.mediaPlayer.play()
    }

    // MARK: - PUBLIC: VOLUME

    /// See private method 'ensureVolumeObserverIsPresent' - called via KVO.
    ///
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    )
    {
        if keyPath == "outputVolume" {
            logger.debug("observeValue: output volume change detection fired (mechanism 1)")

            let audioSession = AVAudioSession.sharedInstance()

            logger.debug("observeValue: Volume now \(String(describing: audioSession.outputVolume)))")

            DispatchQueue.main.async
            {
                self.systemVolumeDidChange(volume: Double(audioSession.outputVolume))
            }
        }
    }

    /**
     Called by the view layer to tell us where the hidden volume slider is.

     - Parameter _: UISlider to use for volume changes (optional).
     */
    func setHiddenSystemVolumeSlider(_ slider: UISlider?)
    {
        self.hiddenSystemVolumeSlider = slider
    }

    /**
     Called by the view layer to tell us that the system volume was changed. The volume given is
     stored locally, but reverse-scaled by current playlist etc. to account for the user adjusting the
     volume within a context of a tracklist and track with volume percentages that may be less than
     100%, and current system volume set accordingly.

     - Parameter volume: Current system volume (from 0, silent, to 1, maximum).
     */
    func systemVolumeDidChange(volume: Double)
    {
        if self.ignoreVolumeNotificationsForAWhileBecauseIChangedIt == true
        {
            logger.debug("systemVolumeDidChange: Called - IGNORING - within the 'I did it' window")
            return // NOTE EARLY EXIT
        }
        
        if self.fadeInIsUnderway == false && self.fadeOutIsUnderway == false && self.trackChangeIsUnderway == false
        {
            logger.debug("systemVolumeDidChange: Called - looks like a user-initiated change; processing")

            let reverseScaledVolume = volume / currentVolumeScaleFactor()
            self.referenceSystemVolume = reverseScaledVolume

            logger.debug("User changed system volume to \(volume), scaled to \(reverseScaledVolume)")
        }
        else
        {
            logger.debug("systemVolumeDidChange: Called - looks like a self-initiated change; ignoring")
        }
    }

    /**
     Called internally. Sets the volume, if a volume slider is known
     (see `setHiddenSystemVolumeSlider`).

     - Parameter volume: Optional volume; if omitted, on changes are made.
     */
    func setVolume(volume: Double?)
    {
        if volume != nil
        {
            self.ignoreVolumeNotificationsForAWhileBecauseIChangedIt = true
            self.timerIgnoreVolumeChangeNotificationsStart()

            let scaledVolume = volume! * self.currentVolumeScaleFactor()

            if Thread.isMainThread
            {
                self.hiddenSystemVolumeSlider?.value = Float(scaledVolume)
            }
            else
            {
                DispatchQueue.main.sync
                {
                    self.hiddenSystemVolumeSlider?.value = Float(scaledVolume)
                }
            }
        }
    }

    /**
     Return the current volume scale factor as Double less than or equal to 1, accounting for current
     tracklist and track relative volume percentages.
    */
    func currentVolumeScaleFactor() -> Double
    {
        let userDefaults = UserDefaults.standard
        let obeyVolume   = userDefaults.bool(forKey: "obey_track_volume")

        if obeyVolume == true {
            let (playlist, track, _) = self.playlistManager.nowPlaying()
            let tracklist            = self.playlistManager.getTracklistForPlaylist(playlist)
            let scale                = (Double(tracklist.volumePercent) / 100.0) * (Double(track.volumePercent) / 100.0)

            logger.debug("currentVolumeScaleFactor: Track gain found; returning \(scale)")
            return scale
        }
        else {
            logger.debug("currentVolumeScaleFactor: Ignoring track gain; returning 1.0")
            return Double(1.0)
        }
    }

    // MARK: - PRIVATE: Playback control

    /**
     Stop any current playback and play the given track, which must be from the given playlist.

     - Parameters:
         - playlist: Playlist containing the Track in `track`
         - completionHandler: Track to play.
    */
    private func startPlayback(playlist: Playlist, track: Track)
    {
        logger.notice("startPlayback: Called")

        timerCancelAll()

        self.trackChangeIsUnderway = false

        self.delegates.forEach { (delegate) in
            delegate.playbackArtworkWillBeInvalid()
        }

        if track.fadeIn
        {
            logger.info("startPlayback: Fade in is required")

            self.fadeInIsUnderway = true
            self.setVolume(volume: 0.0)
            self.fadeInOnNextPlaybackStartedEvent = true
        }
        else
        {
            logger.info("startPlayback: Fade in is NOT required")

            self.fadeInIsUnderway = false
            self.setVolume(volume: self.referenceSystemVolume)
            self.fadeInOnNextPlaybackStartedEvent = false
        }

        self.mediaPlayer.stop()

        // Tell delegates that we're starting a new track. Playback might not
        // *actually* start for a while, but delegates need to know early. The
        // delegate method indicates the conceptual playback initiation.
        //
        DispatchQueue.main.async
        {
            self.delegates.forEach { (delegate) in
                delegate.playbackStarted(
                    playbackManager: self,
                    inPlaylist:      playlist,
                    withTrack:       track
                )
            }
        }

        self.currentlyPlaying = false
        self.currentlySeeking = false
        self.mostRecentPlaybackStartTimeInSeconds = Date().timeIntervalSince1970

        self.timerPositionUpdatesStart()

        // https://stackoverflow.com/a/66472117
        //
        DispatchQueue(label: "uk.org.pond.DungeonPanda.playqueue").async
        {
            // ...and to mix in SFX - "var player: AVAudioPlayer?" somewhere,
            // then...
            //
            // let audioSession = AVAudioSession.sharedInstance()
            // try! audioSession.setCategory(
            //     .playback,
            //     mode: .default,
            //     options: AVAudioSession.CategoryOptions.mixWithOthers
            // )
            //
            // try! audioSession.setActive(true)
            //
            // let resourcePath = Bundle.main.resourcePath
            // let itemName     = "rain.mp3"
            // let path         = resourcePath! + "/" + itemName
            //
            // self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            // self.player?.prepareToPlay()
            // self.player?.rate = 1.0
            // self.player?.volume = 0.3
            // self.player?.numberOfLoops = -1 // Loop continuously
            // self.player?.play()

            let descriptor = self.playlistManager.getQueueDescriptorFor(track: track)

            self.mediaPlayer.setQueue(with: descriptor)
            self.mediaPlayer.play()
        }
    }

    /**
     Return the remaining duration for a currently playing track. If the media player isn't playing something
     or hasn't figured out how long it is yet (usual Apple Music API caveats apply), returns `nil`.
    */
    private func getRemainingDuration() -> Double?
    {
        let playingTrack        = self.playlistManager.getPlayingTrack()
        let currentItemDuration = self.mediaPlayer.nowPlayingItem?.playbackDuration
        let currentItemPosition = self.mediaPlayer.currentPlaybackTime
        let trackEndOffset      = playingTrack.endOffset ?? currentItemDuration

        // The "< 5" is really to try and catch yet more bugs in the Apple Music
        // API where it fails to report the duration on some tracks for a while,
        // where "a while" is "who knows how long, it's a buggy mess". The value
        // returned might be zero or just low - no way to know, since this is
        // all buggy undefined behaviour - so just take any small value to mean
        // that Apple Music messed up again => we don't know the duration.
        //
        let remainingItemDuration = currentItemDuration == nil || trackEndOffset == nil || currentItemDuration! < 5 ?
                                    nil :
                                    trackEndOffset! - currentItemPosition

        return remainingItemDuration
    }

    /**
     Called if a track ends naturally, by playing to the end. Typically invoked from the position update
     timer. If called early enough to allow for a fade-out before true scheduled end time, then fade outs
     happen else it's immediate; the position update timer allows for this when considering whether or
     not to call appropriately early or more or less exactly on end-of-track time.

     This is very like `transitionToNextTrack` and indeed calls through to it, but it considers the
     auto-switch-playlist-after setting first and establishes a target playlist if present. Then it just calls
     through to `transitionToNextTrack` anyway. That's why this method should only be called
     when the track is ending normally.
    */
    private func endTrackAndStartNext()
    {
        let playingPlaylist     = self.playlistManager.getPlayingPlaylist()
        let underlyingTracklist = self.playlistManager.getTracklistForPlaylist(playingPlaylist)

        if underlyingTracklist.autoSwitchAfter != nil
        {
            self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: underlyingTracklist.autoSwitchAfter!)
        }

        self.transitionToNextTrack()
    }

    /**
     Start a transition to the next track immediately, with optional skipping of fade-out parameters. If
     the current track should fade out, fade out is not being ignored and if there's time, fade out will be
     actioned, else if there's not enough time before end-of-track and/or fade out is inapplicable, it
     skips immediately.

     - Parameters:
     - forceImmediate: Ignore any fade out options and change immediately. Default is `false`.
    */
    private func transitionToNextTrack(forceImmediate: Bool = false)
    {
        logger.notice("transitionToNextTrack: Called, forceImmediate = \(forceImmediate)")

        self.trackChangeIsUnderway = true

        timerCancelAll(except: "position_updates")

        var effectiveFadeOutDuration = 0.0

        if (forceImmediate == false && self.mediaPlayer.playbackState == .playing)
        {
            let safetyMargin          = 0.5
            let remainingItemDuration = getRemainingDuration()

            if remainingItemDuration != nil
            {
                effectiveFadeOutDuration = remainingItemDuration! - self.afterFadeOutLagAllowance - safetyMargin

                if effectiveFadeOutDuration > self.fadeOutDuration
                {
                    effectiveFadeOutDuration = self.fadeOutDuration
                }
            }
        }

        if effectiveFadeOutDuration > 0.0
        {
            timerFadeOutStart(duration: effectiveFadeOutDuration)
        }
        else
        {
            transitionToNextSongNow()
        }
    }

    /**
     Immediately moves to the next song in this, or a new target playlist according to the
     `targetPlaylist` optional instance variable. No fade-out is performed.
    */
    private func transitionToNextSongNow()
    {
        logger.notice("transitionToNextSongNow: Called")

        // Work out the next index in this playlist now that the current item
        // has been played. That's stored by the playlist manager and we do it
        // even if changing playlist, since when changing *to* a playlist we
        // expect it to be set up to play the "next valid song" so if returning
        // back to the current playlist in future, we don't want to repeat
        // whatever is playing right now.
        //
        // Accordingly, if changing playlist, just switch that over and let
        // playback start from whatever the most recent index was there since
        // (as per the above) this should be a valid, not-repeated song; else
        // just use the "next track" index from the playlist manager.
        //
        let playingPlaylist = self.playlistManager.getPlayingPlaylist()

        self.playlistManager.currentItemHasBeenPlayedWithin(playlistID: playingPlaylist.id!)

        if self.targetPlaylist != nil && playingPlaylist.id != self.targetPlaylist!.id
        {
            logger.debug("transitionToNextSongNow: Switching to new playlist \(String(describing: self.targetPlaylist!.id))")

            self.playlistManager.setPlayingPlayist(playlist: self.targetPlaylist!)
        }

        self.targetPlaylist = nil

        let (currentPlaylist, currentTrack, _) = self.playlistManager.nowPlaying()
        startPlayback(playlist: currentPlaylist, track: currentTrack)
    }

    // MARK: - PRIVATE: Playback state change handlers

    @objc private func playbackStateDidChange()
    {
        let newState   = self.mediaPlayer.playbackState
        let stateNames = [
           "stopped",
           "playing",
           "paused",
           "interrupted",
           "seekingForward",
           "seekingBackward",
        ]

        // Done because String(describing: ...) or "\(...)" for newState does
        // NOT give the enum value's name; it always just prints the type name
        // instead ("MPMusicPlaybackState"), which is extremely unhelpful.
        //
        let stateName = stateNames[newState.rawValue]

        logger.notice("playbackStateDidChange: Called, state \(newState.rawValue) - \(stateName), playhead \(String(describing: self.mediaPlayer.currentPlaybackTime)), duration \(String(describing: self.mediaPlayer.nowPlayingItem?.playbackDuration))")

        switch newState
        {
            case .paused, .stopped, .interrupted:
                if self.currentlyPlaying == true || self.currentlySeeking == true
                {
                    logger.notice("playbackStateDidChange: Pause: Internal state is 'playing or seeking'")

                    self.currentlyPlaying = false
                    self.currentlySeeking = false

                    // Does this look like e.g. a user-paused event or a self
                    // pause due to end of queue reached (i.e. end of track)?
                    // 1.0s subtraction just leeway for rampant inaccuracies
                    // noted in the media player in real world use :-/
                    //
                    // Note that this is checked separately from end-of-track
                    // detection, because that relies upon the only consistent
                    // state the media player eventually achieves *after some
                    // time* following ending the track. All attempts to check
                    // the state in this event listener have failed because it
                    // amounts to a race condition problem; but by polling for
                    // a specific set of states inside the update timer, we
                    // will eventually 'see' that condition no matter how long
                    // it takes.
                    //
                    // Some tracks don't reset to true-zero when this event is
                    // generated as "pause" rather than "stopped", due to the
                    // stream ending playback. Tom C suggests frame alignment
                    // errors. Whatever the reason, a small amount of wiggle
                    // room is needed at the start, too.
                    //
                    if (
                        self.mediaPlayer.nowPlayingItem == nil ||
                        (
                            self.mediaPlayer.currentPlaybackTime <= self.mediaPlayer.nowPlayingItem!.playbackDuration - 1.5 &&
                            self.mediaPlayer.currentPlaybackTime >= 1.5
                        )
                    )
                    {
                        logger.notice("playbackStateDidChange: Pause: This looks like a user-initiated pause event; taking action")

                        DispatchQueue.main.async
                        {
                            self.effectivePlaybackStateDidHaltPlayback()
                        }
                    }
                    else
                    {
                        logger.notice("playbackStateDidChange: Pause: Stray event or end-of-track; taking no action here, thereby preserving internal playing-or-seeking state for now")
                    }
                }
                else
                {
                    logger.notice("playbackStateDidChange: Pause: This may be a stray event; taking no action since internal state is not 'playing or seeking' anyway")
                }

            case .seekingForward, .seekingBackward:
                if self.currentlySeeking == false
                {
                    logger.notice("playbackStateDidChange: Seeking: Internal event was not 'seeking', so changing internal state now")

                    self.currentlyPlaying = false
                    self.currentlySeeking = true

                    DispatchQueue.main.async
                    {
                        self.effectivePlaybackStateDidStartSeeking()
                    }
                }
                else
                {
                    logger.notice("playbackStateDidChange: Seeking: Taking no action since internal state is already 'seeking' anyway")
                }

            case .playing:
                //
                // Most of the heavy lifting is now done in the position update
                // timer, because the API's events are just far too buggy to try
                // and rely upon here.
                //
                logger.notice("playbackStateDidChange: Playback: Making sure update timer is running")
                self.timerPositionUpdatesStart()
                //
                // if self.currentlyPlaying == false
                // {
                //      self.currentlyPlaying = true
                //      self.currentlySeeking = false
                //
                //      DispatchQueue.main.async
                //      {
                //          self.effectivePlaybackStateDidStartPlaying()
                //      }
                // }

            default:
                logger.notice("playbackStateDidChange: Unknown event, ignoring")
        }
    }

    /// (Re-)add observer(s) that attempt to follow changes in volume initiated by
    /// the user, or by this application sometimes.
    ///
    ///Use *either* this, or notification hackery in ViewController; never have both enabled at the same
    ///time, else multiple conflicting change notifications can arise.
    ///
    func ensureVolumeObserverIsPresent()
    {
        UIApplication.shared.beginReceivingRemoteControlEvents()

        // Mechanism 1 (limitations with < 0.1 or > 0.9 changes)...
        //
        // https://developer.apple.com/documentation/avfaudio/avaudiosession/1616533-outputvolume
        //
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setActive(true)
            try audioSession.setCategory(.playback, options: .mixWithOthers)
        }
        catch {
            logger.error("ViewController.viewDidLoad: Could not active AVAudioSession")
        }

        if audioSession.observationInfo != nil
        {
            audioSession.removeObserver(
                self,
                forKeyPath: "outputVolume",
                context:    nil
            )
        }

        audioSession.addObserver(
            self,
            forKeyPath: "outputVolume",
            options:    NSKeyValueObservingOptions.new,
            context:    nil
        )
    }

    /**
     Call when an event indicates a change to a playback-has-started or if you believe
     the state has been re-entered for another condition detected externally (e.g. track
     skip-to-next initiated by user in e.g. Control Centre).

     Assumes it is always called on the main thread.
    */
    private func effectivePlaybackStateDidStartPlaying()
    {
        logger.notice("effectivePlaybackStateDidStartPlaying: Called")

        // Track alterations in system volume by the user so that fade in/out
        // etc. can all work relative to this user-chosen baseline.
        //
        // (If 'true', see ViewController / NotificationCenter calls).
        //
        if self.appDelegate.useSystemVolumeNotificationsInsteadOfKvo == false
        {
            ensureVolumeObserverIsPresent()
        }

        // Figure out fade-in or start-now
        //
        if self.fadeInOnNextPlaybackStartedEvent
        {
            logger.debug("Scheduling fade-in timer now")

            self.fadeInOnNextPlaybackStartedEvent = false
            timerFadeInStart(duration: self.fadeInDuration)
        }
        else
        {
            self.setVolume(volume: self.referenceSystemVolume)
        }

        let artwork = self.mediaPlayer.nowPlayingItem?.artwork

        self.delegates.forEach{ (delegate) in
            delegate.playbackResumed(playbackManager: self)

            if artwork != nil
            {
                delegate.playbackArtworkWasDetermined(artwork: artwork!)
            }
        }
    }

    /**
     Call when an event indicates a change to a not-playing state such as stopped or
     interrupted, or if you believe the state has been re-entered for another condition
     detected externally.
    */
    private func effectivePlaybackStateDidHaltPlayback()
    {
        logger.notice("effectivePlaybackStateDidHaltPlayback: Called")

        if self.trackChangeIsUnderway == false
        {
            timerCancelAll()

            if self.referenceSystemVolume != nil
            {
                setVolume(volume: self.referenceSystemVolume)
            }

            self.delegates.forEach { (delegate) in
                delegate.playbackPaused(playbackManager: self)
            }
        }
    }

    /**
     Call when an event indicates a change to a playback seek event (when normal
     playback progression speed is not being followed), or if you believe the state
     has been re-entered for another condition detected externally.
    */
    private func effectivePlaybackStateDidStartSeeking()
    {
        logger.notice("effectivePlaybackStateDidStartSeeking: Called")

        timerCancelAll(except: "position_updates")

        if self.referenceSystemVolume != nil
        {
            setVolume(volume: self.referenceSystemVolume)
        }
    }

    // MARK: - PRIVATE: Timers - Support

    /**
     Add a timer by name. Pass a block, which must return the Timer. Any and all other setup that you
     do, especially state management, must only be inside this block - not before or after it.

     Knows about certain special timers and assists with state maintenance for them:
     * `fade_in` - sets relevant state flag
     * `fade_out` - sets relevant state flag

     - Parameters:
        - name: Name of timer; caller-defined.
        - additionHandler: Block returning the new Timer.
    */
    private func timerAdd(_ name: String, additionHandler: @escaping() -> Timer)
    {
        logger.debug("timerAdd: Adding \(name) - cancelling any other instance first...")

        timerCancel(name)

        logger.debug("timerAdd: ...any other instance of \(name) cancelled; adding anew...")

        if name == "fade_in"  { self.fadeInIsUnderway  = true }
        if name == "fade_out" { self.fadeOutIsUnderway = true }

        self.timers[name] = additionHandler()

        logger.debug("timerAdd: ...added")
    }

    /**
     Cancel a timer by name.

     Knows about certain special timers and assists with state maintenance for them:
     * `fade_in` - clears relevant state flag
     * `fade_out` - clears relevant state flag

     - Parameter name: Name of timer; caller-defined.
    */
    private func timerCancel(_ name: String)
    {
        logger.debug("timerCancel: Cancelling \(name)...")

        if name == "fade_in"  { self.fadeInIsUnderway  = false }
        if name == "fade_out" { self.fadeOutIsUnderway = false }

        if let timer = self.timers.removeValue(forKey: name)
        {
            logger.debug("timerCancel: Found active timer; invalidating")
            timer.invalidate()
        }

        logger.debug("timerCancel: ...cancelled (or there was nothing to do)")
    }

    /**
     Cancels all timers, by iterating over any that are active and calling `timerCancel` for each.

     - Parameter except: Optional name of a timer; this one won't be cancelled, if it is active.
    */
    private func timerCancelAll(except: String? = nil)
    {
        logger.debug("timerCancelAll: Called with 'except' set to '\(String(describing: except))'...")

        for name in self.timers.keys
        {
            if except == nil || name != except
            {
                timerCancel(name)
            }
        }

        logger.debug("timerCancelAll: ...finished")
    }

    // MARK: - PRIVATE: Timers - fade-in
    
    private func timerFadeInStart(duration: Double)
    {
        timerAdd("fade_in") {
            return self.fade(
                fromVolume: 0.0,
                  toVolume: self.referenceSystemVolume ?? 0.5,
                  duration: duration,
                  velocity: 1.0
            )
            {
                self.timerFadeInCompleted()
            }
        }
    }

    private func timerFadeInCancel()
    {
        timerCancel("fade_in")
    }

    @objc private func timerFadeInCompleted()
    {
        timerCancel("fade_in")
    }

    // MARK: - PRIVATE: Timers - position update

    private func timerPositionUpdatesStart()
    {
        timerAdd("position_updates") {
            return Timer.scheduledTimer(
                timeInterval: 1,
                      target: self,
                    selector: #selector(self.timerPositionUpdatesFired),
                    userInfo: nil,
                     repeats: true
            )
        }
    }

    private func timerPositionUpdatesCancel()
    {
        timerCancel("position_updates")
    }

    @objc private func timerPositionUpdatesFired()
    {
        logger.debug("timerPositionUpdatesFired: Called - most recent start time \(String(describing: self.mostRecentPlaybackStartTimeInSeconds)), playhead \(String(describing: self.mediaPlayer.currentPlaybackTime)), duration \(String(describing: self.mediaPlayer.nowPlayingItem?.playbackDuration))")

        let (currentPlaylist, currentTrack, _) = self.playlistManager.nowPlaying();
        let appropriateWatchdogTime: Double;

        switch UIApplication.shared.applicationState {
            case .active:
                appropriateWatchdogTime = self.watchdogTimerWaitTime
                break
            default: // "Background" is expected; also use for unexpected "Inactive" or unknown
                appropriateWatchdogTime = self.watchdogTimerInactiveWaitTime
                break
        }

        if self.mediaPlayer.playbackState == .playing
        {
            logger.debug("timerPositionUpdatesFired: Media player state is 'playing'")

            let remainingItemDuration = self.getRemainingDuration()

            logger.debug("timerPositionUpdatesFired: Remaining duration is \(String(describing: remainingItemDuration))")

            if remainingItemDuration != nil
            {
                if self.currentlyPlaying == false
                {
                    logger.debug("timerPositionUpdatesFired: Actioning 'effective did-start-playing'")

                    self.currentlyPlaying = true
                    self.currentlySeeking = false

                    self.mostRecentPlaybackStartTimeInSeconds = nil
                    self.effectivePlaybackStateDidStartPlaying()
                }

                self.delegates.forEach { (delegate) in
                    delegate.playbackProgressChanged(
                        playbackManager: self,
                             inPlaylist: currentPlaylist,
                              withTrack: currentTrack,
                               position: self.mediaPlayer.currentPlaybackTime,
                               duration: self.mediaPlayer.nowPlayingItem!.playbackDuration
                    )
                }

                let safetyMargin = 0.5

                if currentTrack.fadeOut
                {
                    if self.fadeOutIsUnderway == false
                    {
                        let fadeOutStartWindow = self.fadeOutDuration + self.afterFadeOutLagAllowance + safetyMargin

                        if remainingItemDuration! <= fadeOutStartWindow
                        {
                            logger.debug("timerPositionUpdatesFired: Track ended with fade-out ready; starting next soon")

                            self.endTrackAndStartNext()
                        }
                    }
                }
            }
        }

        // If position updates are enabled but the playback state is considered
        // paused (yes, paused not stopped - it's the Apple Music API, it's a
        // complete mess), there *is* a current media item (I mean obviously
        // there shouldn't be, but see above) and the play position is set to
        // the start offset of whatever its queued playlist contained (because
        // it's at the end of the track; yeah, see above).
        //
        // We also try to self-guard against early-playback-start false
        // positives due to the random mess events that the API can generate by
        // checking 'mostRecentPlaybackStartTimeInSeconds', which should be
        // 'nil' unless starting up playback with the watchdog enabled (see
        // 'else if' below).
        //
        else if (
            self.mostRecentPlaybackStartTimeInSeconds == nil &&
            self.mediaPlayer.currentPlaybackTime <= currentTrack.startOffset &&
            self.mediaPlayer.playbackState == .paused
        )
        {
            logger.debug("timerPositionUpdatesFired: Track ended completely; starting next")

            self.endTrackAndStartNext()
        }

        // Playback start has been attempted, but we're waiting for it to
        // happen - we're implementing a watchdog here, within this one timer
        // to keep things simple (fewer timers to cancel and manage).
        //
        else if (
            self.mostRecentPlaybackStartTimeInSeconds != nil &&
            Date().timeIntervalSince1970 - self.mostRecentPlaybackStartTimeInSeconds! >= appropriateWatchdogTime
        )
        {
            logger.warning("timerPositionUpdatesFired: WARNING - Watchdog fired; skipping to next track")

            self.mostRecentPlaybackStartTimeInSeconds = nil
            self.targetPlaylist                       = self.playlistManager.getPlayingPlaylist()

            transitionToNextTrack(forceImmediate: true)
        }
        else
        {
            logger.debug("timerPositionUpdatesFired: Not playing, watchdog not fired")
        }
    }

    // MARK: - PRIVATE: Timers - fade out

    /**
     When fade out finishes, a brief delay timer is used before the next track starts so that remote speakers
     have a chance to catch up. Otherwise, sometimes the fade out seems to be cut short.
    */
    private func timerFadeOutStart(duration: Double)
    {
        logger.debug("timerFadeOutStart: Called")

        timerAdd("fade_out")
        {
            return self.fade(
                fromVolume: self.referenceSystemVolume ?? 0.5,
                  toVolume: 0.0,
                  duration: duration,
                  velocity: 1.0
            )
            {
                self.timerFadeOutCompleted()
            }
        }
    }

    private func timerFadeOutCancel()
    {
        timerCancel("fade_out")
    }

    @objc private func timerFadeOutCompleted()
    {
        logger.debug("timerFadeOutFinished: Called")

        self.trackChangeIsUnderway = true
        self.mediaPlayer.pause()

        timerCancel("fade_out")
        timerPostFadeOutDelayStart()
    }

    private func timerPostFadeOutDelayStart()
    {
        logger.debug("timerPostFadeOutDelayStart: Called")

        timerAdd("post_fade_out_delay")
        {
            return Timer.scheduledTimer(
                timeInterval: self.afterFadeOutLagAllowance,
                      target: self,
                    selector: #selector(self.timerPostFadeOutDelayFired),
                    userInfo: nil,
                     repeats: true
            )
        }
    }

    private func timerPostFadeOutDelayCancel()
    {
        timerCancel("post_fade_out_delay")
    }

    @objc private func timerPostFadeOutDelayFired()
    {
        logger.debug("timerPostFadeOutDelayFired: Called")

        timerCancel("post_fade_out_delay")

        transitionToNextSongNow()
    }
    
    // MARK: - Timers - volume change notifications

    private func timerIgnoreVolumeChangeNotificationsStart()
    {
        timerAdd("ignore_volume_change_notifications") {
            return Timer.scheduledTimer(
                timeInterval: 1,
                      target: self,
                    selector: #selector(self.timerIgnoreVolumeChangeNotificationsCompleted),
                    userInfo: nil,
                     repeats: false
            )
        }
    }
    
    private func timerIgnoreVolumeChangeNotificationsCancel()
    {
        timerCancel("ignore_volume_change_notifications")
    }

    @objc private func timerIgnoreVolumeChangeNotificationsCompleted()
    {
        self.ignoreVolumeNotificationsForAWhileBecauseIChangedIt = false
    }

    // MARK: - PRIVATE: FADING IN AND OUT

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    private func fade(
               fromVolume: Double,
                 toVolume: Double,
                 duration: Double,
                 velocity: Double = 2.0,
        completionHandler: @escaping() -> Void
    )
    -> Timer
    {
        let fromVolume = makeSureValueIsBetween0and1(value: fromVolume)
        let toVolume   = makeSureValueIsBetween0and1(value: toVolume)
        let fadeIn     = fromVolume < toVolume

        logger.debug("fade (\(fadeIn ? "in" : "out")): Starting");

        let volumeAlterationsPerSecond = 15.0
        var currentStep                = 0

        return Timer.scheduledTimer(
            withTimeInterval: 1.0 / volumeAlterationsPerSecond,
                    repeats: true
        )
        { timer in

            let currentTimeFrom0To1 = self.timeFrom0To1(
                               currentStep: currentStep,
                       fadeDurationSeconds: duration,
                volumeAlterationsPerSecond: volumeAlterationsPerSecond
            )

            var volumeMultiplier: Double
            var newVolume:        Double = 0

            if fadeIn
            {
                volumeMultiplier = self.fadeInVolumeMultiplier(
                    timeFrom0To1: currentTimeFrom0To1,
                        velocity: velocity
                )

                newVolume = fromVolume + (toVolume - fromVolume) * volumeMultiplier
                if newVolume > toVolume { newVolume = toVolume } // Allow for rounding
            }
            else
            {
                volumeMultiplier = self.fadeOutVolumeMultiplier(
                    timeFrom0To1: currentTimeFrom0To1,
                        velocity: velocity
                )

                newVolume = toVolume - (toVolume - fromVolume) * volumeMultiplier
                if newVolume < toVolume { newVolume = toVolume } // Allow for rounding
            }

            // logger.debug("fade (\(fadeIn ? "in" : "out")): Step \(currentStep) sets volume \(newVolume) for target \(toVolume)")

            self.setVolume(volume: newVolume)
            currentStep += 1

            if newVolume == toVolume
            {
                timer.invalidate()
                completionHandler()
            }
        }
    }

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    private func makeSureValueIsBetween0and1(
        value: Double
    )
    -> Double
    {
        if value < 0 { return 0 }
        if value > 1 { return 1 }
        return value
    }

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    private func timeFrom0To1(
                       currentStep: Int,
               fadeDurationSeconds: Double,
        volumeAlterationsPerSecond: Double
    )
    -> Double
    {

        let totalSteps = fadeDurationSeconds * volumeAlterationsPerSecond
        var result = Double(currentStep) / totalSteps

        result = makeSureValueIsBetween0and1(value: result)

        return result
    }

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    /// Graph: `https://www.desmos.com/calculator/wnstesdf0h`.
    ///
    private func fadeInVolumeMultiplier(
        timeFrom0To1: Double,
            velocity: Double
    )
    -> Double
    {
        let time = makeSureValueIsBetween0and1(value: timeFrom0To1)
        return pow(M_E, velocity * (time - 1)) * time
    }

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    /// Graph: `https://www.desmos.com/calculator/wnstesdf0h`.
    ///
    private func fadeOutVolumeMultiplier(
        timeFrom0To1: Double,
            velocity: Double
    )
    -> Double
    {
        let time = makeSureValueIsBetween0and1(value: timeFrom0To1)
        return pow(M_E, -velocity * time) * (1 - time)
    }
}
