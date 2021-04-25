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

protocol MusicPlaybackManagerDelegate
{
    func playbackStarted(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track)
    func playbackProgressChanged(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track, position: TimeInterval, duration: TimeInterval)
    func playbackPaused(playbackManager: MusicPlaybackManager)
    func playbackResumed(playbackManager: MusicPlaybackManager)
    func playbackArtworkWasDetermined(artwork: MPMediaItemArtwork)
}

class MusicPlaybackManager
{
    public var delegates: [MusicPlaybackManagerDelegate] = []

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer

    /// A hidden volume slider given to us by the main view when it loads. This is
    /// an horrific hack arising from the bewildering lack of any way to simply set
    /// the playback volume for a MusicKit player.
    var hiddenSystemVolumeSlider: UISlider?

    /// Reference volume set by the user. Fading and track volumes are all scaled
    /// relative to this.
    var referenceSystemVolume: Double?

    /// The PlaylistManager used for all playlist operations; set via `init`.
    var playlistManager: PlaylistManager

    /// Play time from start of current track, if known.
    var currentPlaylistPlaybackOffsetInSeconds: TimeInterval?

    /// Set to whatever we want to start doing, once we commence something
    /// like a next-track / fade-out operation. If the user keeps changing
    /// their mind, these might change a few times before finally becoming
    /// set as Current.
    var targetPlaylist: Playlist?

    /// Keep up with playback position.
    var positionTimer: Timer?

    /// Watchdog used to try and restart on "failed to prepare to play" errors.
    var watchdogTimer: Timer?

    /// Used to perform fade-in and fade-out operations.
    var fadeTimer: Timer?

    /// Used to initiate a fade-out operation, if not done explicitly by e.g. track skip.
    var fadeOutInitiationTimer: Timer?

    /// Timer that fires at or just after a track finishes, since there are no events in the API for this.
    var trackEndsAtTimer: Timer?

    /// Marks that a track transition operation is underway and volume change events should
    /// be ignored, since we're probably the source of them.
    var transitionOperationUnderway: Bool = false

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

        NotificationCenter.default.addObserver(
                self,
            selector: #selector(playbackStateDidChange),
                name: .MPMusicPlayerControllerPlaybackStateDidChange,
              object: nil
        )

        NotificationCenter.default.addObserver(
                self,
            selector: #selector(nowPlayingItemDidChange),
                name: .MPMusicPlayerControllerNowPlayingItemDidChange,
              object: nil
        )

        self.mediaPlayer.beginGeneratingPlaybackNotifications()
    }

    /**
     Start playback after initial application launch. Called externally, when the view layer
     believes it is "safe" / sensible to do so. Can be called off main thread.
     */
    func startInitialPlayback()
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

            self.startPlayingFromCurrentPlaylist()
        }
    }

    /**
     Given a playlist ID, find CoreData records for the "current" playing track therein and transition from
     whever is playing now, to the _next_ track in that playlist.

     - Parameter playlistID: ID of playlist to use for playback.
    */
    func startPlayingNextInPlaylist(playlistID: String)
    {
        self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: playlistID)

        NSLog("startPlayingNextInPlaylist: Playing from \(targetPlaylist!.id!)")
        NSLog("startPlayingNextInPlaylist: Store IDs \(targetPlaylist!.storeIDs)")

        transitionToNextTrack()
    }







    private func transitionToNextTrack(forceImmediate: Bool = false)
    {
        print("transitionToNextSongWithFadeOutIfRequired: Called, forceImmediate = \(forceImmediate)")

        self.transitionOperationUnderway = true

        stopTrackEndsAtTimer()
        stopFadeOutInitiationTimer()

        let mediaIsPlaying        = self.mediaPlayer.playbackState == .playing
        let currentItemDuration   = mediaIsPlaying ? self.mediaPlayer.nowPlayingItem?.playbackDuration : nil
        let currentItemPosition   = mediaIsPlaying ? self.mediaPlayer.currentPlaybackTime              : nil
        let trackEndOffset        = self.playlistManager.getPlayingTrack().endOffset
        let effectiveItemDuration = trackEndOffset != nil && trackEndOffset != 0 ? trackEndOffset : currentItemDuration
        let fadeOutDuration       = 2.0
        let wirelessSpeakerGrace  = 1.0 // Lag time for speakers to obey volume changes
        let fadeOutIsWorthwhile   = effectiveItemDuration != nil &&
            currentItemPosition   != nil &&
            effectiveItemDuration! - currentItemPosition! >= fadeOutDuration + wirelessSpeakerGrace + 0.5 // 0.5s wiggle room

        if forceImmediate == false && mediaIsPlaying == true && fadeOutIsWorthwhile == true
        {
            fadeOut(
                duration: fadeOutDuration,
                completionHandler:
                {
                    // TODO: implement wirelessSpeakerGrace.

                    self.transitionToNextSongNow()
                }
            )
        }
        else
        {
            transitionToNextSongNow()
        }
    }

    private func transitionToNextSongNow()
    {
        // Work out the next index in this playlist now that the current item
        // has been played. If changing playlist, just switch that over and let
        // playback start from whatever the most recent index was there. If the
        // playlist is unchanged, use the index given by the playlist manager.
        //
        let playingPlaylist = self.playlistManager.getPlayingPlaylist()
        let nextTrackIndex  = self.playlistManager.currentItemHasBeenPlayedIn(
            playlistID: self.playlistManager.getPlayingPlaylist().id!
        )

        if self.targetPlaylist != nil && playingPlaylist.id != self.targetPlaylist!.id
        {
            self.playlistManager.setPlayingPlayist(playlist: self.targetPlaylist!)
        }
        else
        {
            self.playlistManager.setCurrentPlaybackIndexFor(playlist: playingPlaylist, index: nextTrackIndex)
        }

        self.targetPlaylist = nil

        startPlayingFromCurrentPlaylist()
    }




















    func startPlayback(track: Track)
    {
        /*
         * Make sure media player is paused.
         * Set queue to the single playlist store ID.
         * Set a watchdog for "playback started".
         * Prepare to play / general hackery to avoid the known issues as with current code.
         * TRANSITION STARTED
         * NEXT PLAYBACK EVENT IS TRACK START
         * If fading in, set volume to zero
         * Play
         */
    }

    func onNormalPlaybackStateEntered()
    {
        /*
         * Cancel watchdog timer
         * Start position update timer
         * If fading out, set a timer for fadeout start.
         - when this fires
         TRANSITION STARTED
         It does all of its fadeout, then on completion sets another timer to wait 1 or 2 seconds
         for external devices (e.g. Bluetooth speakers) comms lag on volume change requests
         - when this last one fires, calls a chokepoint "track ended" method.

         * If not fading out, set a timer for a second or two after track expects to end
         - when this fires
         TRANSITION STARTED
         calls a chokepoint "track ended" method.

         * If NEXT PLAYBACK EVENT IS TRACK START
         - CLEAR "NEXT PLAYBACK EVENT IS TRACK START"
         - If fading in, set timer for this
         - when this completes, TRANSITION ENDED

         - Else TRANSITION ENDED immediately
         */
    }

    func onAnyOtherPlaybackStateEntered(isSeeking: Bool)
    {
        if isSeeking == false
        {
            // * Cancel position update timer
        }

        /*
         * Cancel fadeout timer
         * Cancel track-end timer
         * Set reference volume immediately
         */
    }
//
//    func trackWatchdogTimerFired()
//    {
//    }
//
//    func trackEndedTimerFired()
//    {
//        /*
//         * Cancel position update timer
//         * Player all stop
//         * Figures out what to play next
//         * Calls "starting any track" method as above
//         */
//    }
//
//
//    // Check it starts to actually play
//    func startWatchdogTimer()
//    {
//    }
//
//    func cancelWatchdogTimer()
//    {
//    }
//
//    // Immediately start fading in, in iterative steps.
//    func startFadeInTimer()
//    {
//    }
//
//    func cancelFadeInTimer()
//    {
//    }
//
//    // Calculate length of time to wait before end-of-track WILL HAVE happened
//    // (past tense - track already finished).
//    func startTrackEndTimer(forTrack: Track)
//    {
//    }
//
//    func cancelTrackEndTimer()
//    {
//    }
//
//    // Similar to track-end timer, but calculates back to fade out by the end
//    // of track offset (minus a second or so for safety) and schedules a fade
//    // out for that point. This is NOT the fade-out itself; it's the thing
//    // which initiates the fade-out.
//    func startBeginFadeOutTimer(forTrack: Track)
//    {
//    }
//
//    func cancelBeginFadeOutTimer()
//    {
//    }
//
//    // Immediately start fading out, in iterative steps.
//    func startFadeOutTimer()
//    {
//    }
//
//    func cancelFadeOutTimer()
//    {
//    }



    /**
     Called by the view layer when the user finishes dragging the position slider somewhere.

     - Parameter float: New UISlider position, from 0 to 1
    */
    func positionSliderWasManuallyMoved(value: Float)
    {
        let playingTrack = self.playlistManager.getPlayingTrack()
        let duration     = self.mediaPlayer.nowPlayingItem?.playbackDuration

        guard duration != nil else { return }

        effectivePlaybackStateDidStartSeeking()

        var relativeDuration: TimeInterval

        if playingTrack.endOffset == nil
        {
            relativeDuration = duration! - playingTrack.startOffset
        }
        else
        {
            relativeDuration = (playingTrack.endOffset! - playingTrack.startOffset)
        }

        self.mediaPlayer.currentPlaybackTime = relativeDuration * Double(value)

        effectivePlaybackStateDidStartPlaying()
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

    // MARK: - VOLUME

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
        if transitionOperationUnderway == false
        {
            let reverseScaledVolume = volume / currentVolumeScaleFactor()
            self.referenceSystemVolume = reverseScaledVolume

            print("User changed system volume to \(volume), scaled to \(reverseScaledVolume)")
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
            let scaledVolume = volume! * currentVolumeScaleFactor()
            self.hiddenSystemVolumeSlider?.value = Float(scaledVolume)
        }
    }

    /**
     Return the current volume scale factor as Double less than or equal to 1, accounting for current
     tracklist and track relative volume percentages.
    */
    func currentVolumeScaleFactor() -> Double
    {
        let (playlist, track, _) = self.playlistManager.nowPlaying()
        let tracklist = self.playlistManager.getTracklistForPlaylist(playlist)

        return (Double(tracklist.volumePercent) / 100.0) * (Double(track.volumePercent) / 100.0)
    }

    // MARK: - PLAYBACK EVENTS

    @objc func playbackProgressChanged(timer: Timer)
    {
        if self.mediaPlayer.playbackState == .playing
        {
            let playingPlaylist = self.playlistManager.getPlayingPlaylist()
            let playingTrack    = self.playlistManager.getPlayingTrack()

            self.currentPlaylistPlaybackOffsetInSeconds = self.mediaPlayer.currentPlaybackTime
            self.delegates.forEach { (delegate) in
                delegate.playbackProgressChanged(
                    playbackManager: self,
                    inPlaylist:      playingPlaylist,
                    withTrack:       playingTrack,
                    position:        self.currentPlaylistPlaybackOffsetInSeconds!,
                    duration:        self.mediaPlayer.nowPlayingItem!.playbackDuration
                )
            }
        }
    }

    @objc func playbackStateDidChange()
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

        print("playbackStateDidChange: Called, state \(newState.rawValue) - \(stateName)")

        switch newState
        {
            case .paused, .stopped, .interrupted:
                if currentlyPlaying == true || currentlySeeking == true
                {
                    // Does this look like e.g. a user-paused event or a self
                    // pause due to end of queue reached (i.e. end of track)?
                    // 0.5s subtraction just leeway for rampant inaccuracies
                    // noted in the media player in real world use :-/
                    //
                    if (
                        self.mediaPlayer.nowPlayingItem == nil ||
                        (
                            self.mediaPlayer.currentPlaybackTime <= self.mediaPlayer.nowPlayingItem!.playbackDuration - 0.5 &&
                            self.mediaPlayer.currentPlaybackTime != 0
                        )
                    )
                    {
                        currentlyPlaying = false
                        currentlySeeking = false
                        effectivePlaybackStateDidHaltPlayback()
                    }
                }

            case .seekingForward, .seekingBackward:
                if currentlySeeking == false
                {
                    currentlyPlaying = false
                    currentlySeeking = true
                    effectivePlaybackStateDidStartSeeking()
                }

            case .playing:
                if currentlyPlaying == false
                {
                    currentlyPlaying = true
                    currentlySeeking = false
                    effectivePlaybackStateDidStartPlaying()
                }

            default:
                print("playbackStateDidChange: Unknown event, ignoring")
        }
    }

    @objc func nowPlayingItemDidChange()
    {
        if self.mediaPlayer.playbackState != .playing
        {
            return
        }

        var (playingPlaylist, playingTrack, playingIndex) = self.playlistManager.nowPlaying()

        if let newPlaybackStoreID = mediaPlayer.nowPlayingItem?.playbackStoreID,
           let newPlayingIndex    = self.playlistManager.getTrackIndexFor(
             playlist: playingPlaylist,
             storeID:  newPlaybackStoreID
           )
        {
            // Without looping turned on, item-did-change fires with the player
            // in a paused state when the last playlist item has been reached.
            // The UI will briefly show the 1st item in the playlist on loop,
            // but we treat this as playlist exhaustion and reshuffle.
            //
            if self.mediaPlayer.playbackState == .paused
            {
                print("nowPlayingItemDidChange: Playlist ended; shuffling")

                transitionToNextTrack()
            }
            else
            {
                if newPlayingIndex != playingIndex
                {
                    print("nowPlayingItemDidChange: Store ID \(newPlaybackStoreID) yielding new playlist index \(newPlayingIndex)")

                    self.playlistManager.setCurrentPlaybackIndexFor(playlist: playingPlaylist, index: newPlayingIndex)
                    (playingPlaylist, playingTrack, playingIndex) = self.playlistManager.nowPlaying()

                    effectivePlaybackStateDidStartPlaying()
                }

                print("nowPlayingItemDidChange: At Playlist index \(playingIndex) with Track \(playingTrack)")

                self.delegates.forEach { (delegate) in
                    delegate.playbackStarted(
                        playbackManager: self,
                        inPlaylist:      playingPlaylist,
                        withTrack:       playingTrack
                    )
                }
            }
        }
        else
        {
            print("nowPlayingItemDidChange: ERROR - Could not get current track or updated playlist index")
        }
    }

    @objc func playbackWatchdogFired()
    {
        print("playbackWatchdogFired: WARNING - Watchdog fired")

        if self.mediaPlayer.playbackState != .playing
        {
            print("playbackWatchdogFired: WARNING - Media player says 'not playing' so skipping to next track")

            self.targetPlaylist = self.playlistManager.getPlayingPlaylist()

            transitionToNextTrack(forceImmediate: true)
        }
    }

    // MARK: - PRIVATE: GENERAL TIMERS

    /// Start the repeat playback position timer. Restarts it if already running.
    private func startPositionTimer()
    {
        stopPositionTimer()

        self.positionTimer = Timer(
            timeInterval: 1,
                  target: self,
                selector: #selector(playbackProgressChanged),
                userInfo: nil,
                 repeats: true
        )

        RunLoop.current.add(self.positionTimer!, forMode: RunLoop.Mode.common)
    }

    /// Stop the repeat playback position timer. Does nothing if it is not running.
    private func stopPositionTimer()
    {
        if self.positionTimer != nil
        {
            self.positionTimer!.invalidate()
            self.positionTimer = nil
        }
    }

    /// Start the one-off watchdog timer. Restarts it if already running.
    private func startWatchdogTimer()
    {
        stopWatchdogTimer()

        self.watchdogTimer = Timer(
            timeInterval: 10,
            target: self,
            selector: #selector(playbackWatchdogFired),
            userInfo: nil,
            repeats: false
        )

        RunLoop.current.add(self.watchdogTimer!, forMode: RunLoop.Mode.common)
    }

    /// Stop the one-off watchdog timer. Does nothing if it is not running.
    private func stopWatchdogTimer()
    {
        if self.watchdogTimer != nil
        {
            self.watchdogTimer!.invalidate()
            self.watchdogTimer = nil
        }
    }

    // MARK: - PRIVATE: PLAYBACK STATE MANAGEMENT

    /**
     Call when an event indicates a change to a not-playing state such as stopped or
     interrupted, or if you believe the state has been re-entered for another condition
     detected externally.
    */
    private func effectivePlaybackStateDidHaltPlayback()
    {
        print("effectivePlaybackStateDidHaltPlayback: Called")

        stopWatchdogTimer()
        stopTrackEndsAtTimer()
        stopFadeOutInitiationTimer()
        stopFadeTimer()
        stopPositionTimer()

        if self.referenceSystemVolume != nil
        {
            setVolume(volume: self.referenceSystemVolume)
        }

        self.delegates.forEach { (delegate) in
            delegate.playbackPaused(playbackManager: self)
        }
    }

    /**
     Call when an event indicates a change to a playback seek event (when normal
     playback progression speed is not being followed), or if you believe the state
     has been re-entered for another condition detected externally.
    */
    private func effectivePlaybackStateDidStartSeeking()
    {
        print("effectivePlaybackStateDidStartSeeking: Called")

        stopWatchdogTimer()
        stopTrackEndsAtTimer()
        stopFadeOutInitiationTimer()
        stopFadeTimer()

        if self.referenceSystemVolume != nil
        {
            setVolume(volume: self.referenceSystemVolume)
        }
    }

    /**
     Call when an event indicates a change to a playback-has-started or if you believe
     the state has been re-entered for another condition detected externally (e.g. track
     skip-to-next initiated by user in e.g. Control Centre).
    */
    private func effectivePlaybackStateDidStartPlaying()
    {
        print("effectivePlaybackStateDidStartPlaying: Called")

        stopWatchdogTimer()
        stopTrackEndsAtTimer()
        stopFadeOutInitiationTimer()

        startPositionTimer()

        if self.fadeInOnNextPlaybackStartedEvent
        {
            self.fadeInOnNextPlaybackStartedEvent = false

            fadeIn(
                completionHandler:
                {
                    self.transitionOperationUnderway = false
                }
            )
        }
        else
        {
            self.setVolume(volume: self.referenceSystemVolume)

            self.fadeInOnNextPlaybackStartedEvent = false
            self.transitionOperationUnderway      = false
        }

        let (playingPlaylist, playingTrack, _) = self.playlistManager.nowPlaying()
        let underlyingTracklist                = self.playlistManager.getTracklistForPlaylist(playingPlaylist)

        let currentItemDuration   = self.mediaPlayer.nowPlayingItem?.playbackDuration ?? TimeInterval(60.0) // "nil" -> serious error; call the track 60 seconds?! Nothing much else to do!
        let currentItemPosition   = self.mediaPlayer.currentPlaybackTime
        let trackEndOffset        = self.playlistManager.getPlayingTrack().endOffset ?? currentItemDuration
        let remainingItemDuration = trackEndOffset - currentItemPosition

        stopTrackEndsAtTimer()
        stopFadeOutInitiationTimer()

        // Set a timer to fade out just before the track moves on, or set a
        // track-ends monitor timer to perform similar actions without fading.
        //
        if playingTrack.fadeOut
        {
            let fadeOutDuration     = 2.00
            let safetyMargin        = 0.75
            let timeUntilFadeStarts = remainingItemDuration - fadeOutDuration - safetyMargin

            print("Scheduling fade-out timer to run in \(timeUntilFadeStarts) seconds")

            self.fadeOutInitiationTimer = Timer.scheduledTimer(
                withTimeInterval: timeUntilFadeStarts,
                repeats: false
            )
            { timer in
                self.stopFadeOutInitiationTimer()

                if underlyingTracklist.autoSwitchAfter != nil
                {
                    self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: underlyingTracklist.autoSwitchAfter!)
                }

                self.transitionToNextTrack()
            }
        }
        else
        {
            let safetyMargin       = 1.0
            let timeUntilTrackEnds = remainingItemDuration + safetyMargin

            print("Scheduling end-of-track timer to run in \(timeUntilTrackEnds) seconds")

            self.trackEndsAtTimer = Timer.scheduledTimer(
                withTimeInterval: timeUntilTrackEnds,
                         repeats: false
            )
            { timer in
                self.stopTrackEndsAtTimer()

                if underlyingTracklist.autoSwitchAfter != nil
                {
                    self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: underlyingTracklist.autoSwitchAfter!)
                }

                self.transitionToNextTrack()
            }
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

    // MARK: - PRIVATE: MISCELLANEOUS

    func startPlayingFromCurrentPlaylist()
    {
        let (playlist, track, index) = self.playlistManager.nowPlaying()

        self.transitionOperationUnderway = true

        print("startPlayingFromCurrentPlaylist: Store ID \(track.storeID) on playlist \(playlist.id!) at index \(index)")

        self.delegates.forEach { (delegate) in
            delegate.playbackStarted(
                playbackManager: self,
                inPlaylist:      playlist,
                withTrack:       track
            )
        }

//        let descriptor = self.playlistManager.getQueueDescriptorFor(playlist: playlist)
        let descriptor = self.playlistManager.getQueueDescriptorFor(track: track)

        self.mediaPlayer.setQueue(with: descriptor)
//        self.mediaPlayer.prepareToPlay()
//
//        self.startSongWithFadeInIfRequired(fromTrack: track)

        // https://stackoverflow.com/a/66472117
        //
        DispatchQueue(label: "uk.org.pond.DungeonPanda.playqueue").async
        {
            self.mediaPlayer.prepareToPlay(
                completionHandler:
                { error in
                    if error == nil
                    {
                        DispatchQueue.main.async
                        {
                            self.startSongWithFadeInIfRequired(fromTrack: track)
                        }
                    }
                    else
                    {
                        print("startPlayingFromCurrentPlaylist: ERROR: \(error!)")

                        self.stopWatchdogTimer()
                        self.targetPlaylist = playlist

                        DispatchQueue.main.async
                        {
                            self.transitionToNextTrack(forceImmediate: true)
                        }
                    }
                }
            )
        }
    }

    private func startSongWithFadeInIfRequired(fromTrack: Track)
    {
        print("startSongWithFadeInIfRequired: Called")

        self.transitionOperationUnderway = true

        if fromTrack.fadeIn
        {
            print("startSongWithFadeInIfRequired: Fade in is required")

            self.setVolume(volume: 0.0)
            self.fadeInOnNextPlaybackStartedEvent = true

            startSongNow()
        }
        else
        {
            self.fadeInOnNextPlaybackStartedEvent = false
            startSongNow()
        }
    }

    // TODO - add start offset for playback
    //
    private func startSongNow()
    {
        print("startSongNow: Called")

        startWatchdogTimer()

        // https://stackoverflow.com/a/66472117
        //
        DispatchQueue(label: "uk.org.pond.DungeonPanda.playqueue").async
        {
            self.mediaPlayer.play()
        }
    }

    // MARK: - PRIVATE: FADING

    /**
     Fade in, calling a handler when completed. Note that volume is *NOT* set to zero prior. If callers
     think system volume needs to be thus set, do that manually; ensure that the
     `transitionOperationUnderway` is set to `true` prior.

     - Parameters:
     - duration: Duration in seconds for timer to run for full fade in; default is 2.0 seconds.
     - completionHandler: Completion handler, invoked once volume has reached reference full.
     */
    private func fadeIn(duration: Double = 2.0, completionHandler: @escaping() -> Void)
    {
        fade(
                   fromVolume: 0.0,
                     toVolume: self.referenceSystemVolume ?? 0.5,
                     duration: duration,
                     velocity: 1.0,
            completionHandler: completionHandler
        )
    }

    /**
     Fade out, calling a handler when completed.

     - Parameters:
        - duration: Duration in seconds for timer to run for full fade out; default is 2.0 seconds.
        - completionHandler: Completion handler, invoked once volume has reached zero.
    */
    private func fadeOut(duration: Double = 2.0, completionHandler: @escaping() -> Void)
    {
        fade(
                   fromVolume: self.referenceSystemVolume ?? 0.5,
                     toVolume: 0.0,
                     duration: duration,
                     velocity: 0.2,
            completionHandler: completionHandler
        )
    }

    /// Stop the fade timer. Does nothing if it is not running.
    private func stopFadeTimer()
    {
        if self.fadeTimer != nil
        {
            self.fadeTimer!.invalidate()
            self.fadeTimer = nil
        }
    }

    /// Stop the time-to-start-fading-out timer. Does nothing if it is not running.
    private func stopFadeOutInitiationTimer()
    {
        if self.fadeOutInitiationTimer != nil
        {
            self.fadeOutInitiationTimer!.invalidate()
            self.fadeOutInitiationTimer = nil
        }
    }

    private func stopTrackEndsAtTimer()
    {
        if self.trackEndsAtTimer != nil
        {
            self.trackEndsAtTimer!.invalidate()
            self.trackEndsAtTimer = nil
        }
    }

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
    {
        let fromVolume = makeSureValueIsBetween0and1(value: fromVolume)
        let toVolume   = makeSureValueIsBetween0and1(value: toVolume)
        let fadeIn     = fromVolume < toVolume

        print("fade (\(fadeIn ? "in" : "out")): Starting");

        stopTrackEndsAtTimer()
        stopFadeOutInitiationTimer()
        stopFadeTimer()

        let volumeAlterationsPerSecond = 15.0
        var currentStep                = 0

        self.fadeTimer = Timer.scheduledTimer(
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

            // print("fade (\(fadeIn ? "in" : "out")): Step \(currentStep) sets volume \(newVolume) for target \(toVolume)")

            self.setVolume(volume: newVolume)
            currentStep += 1

            if newVolume == toVolume
            {
                self.fadeTimer!.invalidate()
                self.fadeTimer = nil

                completionHandler()
            }
        }
    }

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    private func makeSureValueIsBetween0and1(value: Double) -> Double {
        if value < 0 { return 0 }
        if value > 1 { return 1 }
        return value
    }

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    private func timeFrom0To1(currentStep: Int, fadeDurationSeconds: Double,
                            volumeAlterationsPerSecond: Double) -> Double {

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
    private func fadeInVolumeMultiplier(timeFrom0To1: Double, velocity: Double) -> Double {
        let time = makeSureValueIsBetween0and1(value: timeFrom0To1)
        return pow(M_E, velocity * (time - 1)) * time
    }

    /// Adapted with thanks from `https://github.com/evgenyneu/Cephalopod/blob/master/Cephalopod/Cephalopod.swift`
    /// (MIT `https://github.com/evgenyneu/Cephalopod/blob/master/LICENSE`).
    ///
    /// Graph: `https://www.desmos.com/calculator/wnstesdf0h`.
    ///
    private func fadeOutVolumeMultiplier(timeFrom0To1: Double, velocity: Double) -> Double {
        let time = makeSureValueIsBetween0and1(value: timeFrom0To1)
        return pow(M_E, -velocity * time) * (1 - time)
    }
}
