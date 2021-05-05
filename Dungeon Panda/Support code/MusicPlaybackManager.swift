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
}

class MusicPlaybackManager
{
    public var delegates: [MusicPlaybackManagerDelegate] = []

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer

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
    /// track manually... Sadly, Apple's MediaPlayer API is *extraordinarily* unreliable!
    let watchdogTimerWaitTime = 10.0

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

        NotificationCenter.default.addObserver(
                self,
            selector: #selector(playbackStateDidChange),
                name: .MPMusicPlayerControllerPlaybackStateDidChange,
              object: nil
        )

//        NotificationCenter.default.addObserver(
//                self,
//            selector: #selector(nowPlayingItemDidChange),
//                name: .MPMusicPlayerControllerNowPlayingItemDidChange,
//              object: nil
//        )

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

        NSLog("startPlayingNextInPlaylist: Playing from \(targetPlaylist!.id!)")
        NSLog("startPlayingNextInPlaylist: Store IDs \(targetPlaylist!.storeIDs)")

        transitionToNextTrack()
    }

    /**
     Called by the view layer when the user finishes dragging the position slider somewhere.

     - Parameter float: New UISlider position, from zero to duration, relative to track start/end offsets.
    */
    func positionSliderWasManuallyMoved(value: Float)
    {
        let playingTrack     = self.playlistManager.getPlayingTrack()
        let relativePosition = TimeInterval(value) + playingTrack.startOffset

        self.mediaPlayer.currentPlaybackTime = relativePosition

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

    // MARK: - PUBLIC: VOLUME

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
        if self.fadeInIsUnderway == false && self.fadeOutIsUnderway == false && self.trackChangeIsUnderway == false
        {
            let reverseScaledVolume = volume / currentVolumeScaleFactor()
            self.referenceSystemVolume = reverseScaledVolume

            NSLog("User changed system volume to \(volume), scaled to \(reverseScaledVolume)")
        }
    }

    /**
     Called internally. Sets the volume, if a volume slider is known
     (see `setHiddenSystemVolumeSlider`).

     - Parameter volume: Optional volume; if omitted, on changes are made.
     */
    func setVolume(volume: Double?)
    {
        DispatchQueue.main.async
        {
            if volume != nil
            {
                let scaledVolume = volume! * self.currentVolumeScaleFactor()
                self.hiddenSystemVolumeSlider?.value = Float(scaledVolume)
            }
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

    // MARK: - PRIVATE: Playback control

    /**
     Stop any current playback and play the given track, which must be from the given playlist.

     - Parameters:
         - playlist: Playlist containing the Track in `track`
         - completionHandler: Track to play.
    */
    private func startPlayback(playlist: Playlist, track: Track)
    {
        NSLog("startPlayback: Called")

        timerCancelAll()
        timerWatchdogStart()

        self.trackChangeIsUnderway = false

        if track.fadeIn
        {
            NSLog("startPlayback: Fade in is required")

            self.fadeInIsUnderway = true
            self.setVolume(volume: 0.0)
            self.fadeInOnNextPlaybackStartedEvent = true
        }
        else
        {
            NSLog("startPlayback: Fade in is NOT required")

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

        // https://stackoverflow.com/a/66472117
        //
        DispatchQueue(label: "uk.org.pond.DungeonPanda.playqueue").async
        {
            let descriptor = self.playlistManager.getQueueDescriptorFor(track: track)

            self.mediaPlayer.setQueue(with: descriptor)
            self.mediaPlayer.play()
        }
        // desperatelyTryToConvinceMusicPlayerToActuallyWork(track: track)
    }

    // This doesn't work, but one day maybe it'll be a big enough sledgehammer
    // *or* Apple might write code that isn't a total crock of **** (this stuff
    // has been broken for years, so I don't think their engineers have even
    // close to the competence required to ever reliably play audio. It's a
    // really difficult thing apparently... So. Many. Hours. Wasted. On. This.)
    //
    private func desperatelyTryToConvinceMusicPlayerToActuallyWork(track: Track)
    {
        // https://stackoverflow.com/a/66472117
        //
        DispatchQueue(label: "uk.org.pond.DungeonPanda.playqueue").async
        {
            let descriptor = self.playlistManager.getQueueDescriptorFor(track: track)

            self.mediaPlayer.stop()
            self.mediaPlayer.setQueue(with: descriptor)

            self.mediaPlayer.prepareToPlay(
                completionHandler:
                { error in
                    if error == nil
                    {
                        DispatchQueue.main.async
                        {
                            self.mediaPlayer.pause()
                            self.mediaPlayer.play()
                        }
                    }
                    else
                    {
                        NSLog("startPlayingFromCurrentPlaylist: ERROR: \(error!)")

                        self.timerWatchdogCancel()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                        {
                            self.desperatelyTryToConvinceMusicPlayerToActuallyWork(track: track)
                        }
                    }
                }
            )

            self.mediaPlayer.play()
        }
    }

    private func getPlayingTrackAndRemainingDuration() -> (Track, Double)
    {
        let playingTrack          = self.playlistManager.getPlayingTrack()
        let currentItemDuration   = self.mediaPlayer.nowPlayingItem?.playbackDuration ?? TimeInterval(60.0) // "nil" -> just play 60 seconds?!
        let currentItemPosition   = self.mediaPlayer.currentPlaybackTime
        let trackEndOffset        = playingTrack.endOffset ?? currentItemDuration
        let remainingItemDuration = trackEndOffset - currentItemPosition

        return (playingTrack, remainingItemDuration)
    }

    private func transitionToNextTrack(forceImmediate: Bool = false)
    {
        NSLog("transitionToNextTrack: Called, forceImmediate = \(forceImmediate)")

        self.trackChangeIsUnderway = true

        timerCancelAll(except: "position_updates")

        if (forceImmediate == false && self.mediaPlayer.playbackState == .playing)
        {
            let (_, remainingItemDuration) = getPlayingTrackAndRemainingDuration()

            let safetyMargin             = 0.5
            var effectiveFadeOutDuration = remainingItemDuration - self.afterFadeOutLagAllowance - safetyMargin

            if effectiveFadeOutDuration > fadeOutDuration { effectiveFadeOutDuration = fadeOutDuration }
            if effectiveFadeOutDuration > 0
            {
                timerFadeOutStart(duration: effectiveFadeOutDuration)
            }
            else
            {
                transitionToNextSongNow()
            }
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
        let nextTrackIndex  = self.playlistManager.currentItemHasBeenPlayedWithin(
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

        NSLog("playbackStateDidChange: Called, state \(newState.rawValue) - \(stateName)")

        switch newState
        {
            case .paused, .stopped, .interrupted:
                if self.currentlyPlaying == true || self.currentlySeeking == true
                {
                    self.currentlyPlaying = false
                    self.currentlySeeking = false

                    // Does this look like e.g. a user-paused event or a self
                    // pause due to end of queue reached (i.e. end of track)?
                    // 1.0s subtraction just leeway for rampant inaccuracies
                    // noted in the media player in real world use :-/
                    //
                    if (
                        self.mediaPlayer.nowPlayingItem == nil ||
                        (
                            self.mediaPlayer.currentPlaybackTime <= self.mediaPlayer.nowPlayingItem!.playbackDuration - 1.0 &&
                            self.mediaPlayer.currentPlaybackTime != 0
                        )
                    )
                    {
                        DispatchQueue.main.async
                        {
                            self.effectivePlaybackStateDidHaltPlayback()
                        }
                    }
                }

            case .seekingForward, .seekingBackward:
                if self.currentlySeeking == false
                {
                    self.currentlyPlaying = false
                    self.currentlySeeking = true

                    DispatchQueue.main.async
                    {
                        self.effectivePlaybackStateDidStartSeeking()
                    }
                }

            case .playing:
                if self.currentlyPlaying == false
                {
                    self.currentlyPlaying = true
                    self.currentlySeeking = false

                    DispatchQueue.main.async
                    {
                        self.effectivePlaybackStateDidStartPlaying()
                    }
                }

            default:
                NSLog("playbackStateDidChange: Unknown event, ignoring")
        }
    }

    /**
     Call when an event indicates a change to a playback-has-started or if you believe
     the state has been re-entered for another condition detected externally (e.g. track
     skip-to-next initiated by user in e.g. Control Centre).

     Assumes it is always called on the main thread.
    */
    private func effectivePlaybackStateDidStartPlaying()
    {
        NSLog("effectivePlaybackStateDidStartPlaying: Called")

        timerCancelAll()
        timerPositionUpdatesStart()

        let artwork = self.mediaPlayer.nowPlayingItem?.artwork

        self.delegates.forEach{ (delegate) in
            delegate.playbackResumed(playbackManager: self)

            if artwork != nil
            {
                delegate.playbackArtworkWasDetermined(artwork: artwork!)
            }
        }

        // Figure out fade-in or start-now

        if self.fadeInOnNextPlaybackStartedEvent
        {
            NSLog("Scheduling fade-in timer now")

            self.fadeInOnNextPlaybackStartedEvent = false
            timerFadeInStart(duration: self.fadeInDuration)
        }
        else
        {
            self.setVolume(volume: self.referenceSystemVolume)
        }

        timerTrackEndStart()
    }

    /**
     Call when an event indicates a change to a not-playing state such as stopped or
     interrupted, or if you believe the state has been re-entered for another condition
     detected externally.
    */
    private func effectivePlaybackStateDidHaltPlayback()
    {
        NSLog("effectivePlaybackStateDidHaltPlayback: Called")

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
        NSLog("effectivePlaybackStateDidStartSeeking: Called")

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
        timerCancel(name)

        if name == "fade_in"  { self.fadeInIsUnderway  = true }
        if name == "fade_out" { self.fadeOutIsUnderway = true }

        self.timers[name] = additionHandler()
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
        if name == "fade_in"  { self.fadeInIsUnderway  = false }
        if name == "fade_out" { self.fadeOutIsUnderway = false }

        if let timer = self.timers.removeValue(forKey: name)
        {
            timer.invalidate()
        }
    }

    /**
     Cancels all timers, by iterating over any that are active and calling `timerCancel` for each.

     - Parameter except: Optional name of a timer; this one won't be cancelled, if it is active.
    */
    private func timerCancelAll(except: String? = nil)
    {
        for name in self.timers.keys
        {
            if except == nil || name != except
            {
                timerCancel(name)
            }
        }
    }

    // MARK: - PRIVATE: Timers - watchdog

    private func timerWatchdogStart()
    {
        timerAdd("watchdog_start") {
            return Timer.scheduledTimer(
                timeInterval: self.watchdogTimerWaitTime,
                      target: self,
                    selector: #selector(self.timerWatchdogFired),
                    userInfo: nil,
                     repeats: false
            )
        }
    }

    private func timerWatchdogCancel()
    {
        timerCancel("watchdog_start")
    }

    @objc private func timerWatchdogFired()
    {
        timerCancel("watchdog_start")

        NSLog("timerWatchdogFired: WARNING - Watchdog fired")

        if self.mediaPlayer.playbackState != .playing
        {
            NSLog("timerWatchdogFired: WARNING - Media player says 'not playing' so skipping to next track")

            self.targetPlaylist = self.playlistManager.getPlayingPlaylist()
            transitionToNextTrack(forceImmediate: true)
        }
    }

    // MARK: - PRIVATE: Timers - fade-in

    private func timerFadeInStart(duration: Double)
    {
        self.fadeInIsUnderway = true

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

    // MARK: - PRIVATE: TImers - position update

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
        if self.mediaPlayer.playbackState == .playing
        {
            let (playingPlaylist, playingTrack, _) = self.playlistManager.nowPlaying()

            self.currentPlaylistPlaybackOffsetInSeconds = self.mediaPlayer.currentPlaybackTime
            self.delegates.forEach { (delegate) in
                delegate.playbackProgressChanged(
                    playbackManager: self,
                         inPlaylist: playingPlaylist,
                          withTrack: playingTrack,
                           position: self.currentPlaylistPlaybackOffsetInSeconds!,
                           duration: self.mediaPlayer.nowPlayingItem!.playbackDuration
                )
            }
        }
    }

    // MARK: - PRIVATE: Timers - track end

    /**
     The track-end timer looks at the currently playing music and sets a trigger timer that fires just after the
     track will have ended assuming normal playback position from the time when this method is called or,
     if the track requires fade-out, at the appropriate fade-out initiation time likewise assuming normal
     playback progression.

     **Must only be called when music is playing**.
    */
    private func timerTrackEndStart()
    {
        guard self.mediaPlayer.playbackState == .playing else { return }

        timerAdd("track_end") {

            let (playingTrack, remainingItemDuration) = self.getPlayingTrackAndRemainingDuration()
            var timeInterval: Double

            if playingTrack.fadeOut
            {
                let safetyMargin = 0.75
                timeInterval = remainingItemDuration - self.fadeOutDuration - safetyMargin
            }
            else
            {
                let safetyMargin = 1.0
                timeInterval = remainingItemDuration + safetyMargin
            }

            NSLog("Scheduling end-of-track timer to run in \(timeInterval) seconds (to fade out? -> \(playingTrack.fadeOut))")

            return Timer.scheduledTimer(
                timeInterval: timeInterval,
                      target: self,
                    selector: #selector(self.timerTrackEndFired),
                    userInfo: nil,
                     repeats: false
            )
        }
    }

    private func timerTrackEndCancel()
    {
        timerCancel("track_end")
    }

    @objc private func timerTrackEndFired()
    {
        timerCancelAll()

        self.mediaPlayer.stop()

        let playingPlaylist     = self.playlistManager.getPlayingPlaylist()
        let underlyingTracklist = self.playlistManager.getTracklistForPlaylist(playingPlaylist)

        if underlyingTracklist.autoSwitchAfter != nil
        {
            self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: underlyingTracklist.autoSwitchAfter!)
        }

        self.transitionToNextTrack()
    }

    // MARK: - PRIVATE: Timers - fade out

    /**
     When fade out finishes, a brief delay timer is used before the next track starts so that remote speakers
     have a chance to catch up. Otherwise, sometimes the fade out seems to be cut short.
    */
    private func timerFadeOutStart(duration: Double)
    {
        NSLog("timerFadeOutStart: Called")

        timerAdd("fade_out")
        {
            self.fadeOutIsUnderway = true

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
        NSLog("timerFadeOutFinished: Called")

        self.trackChangeIsUnderway = true

        timerCancel("fade_out")
        timerPostFadeOutDelayStart()
    }

    private func timerPostFadeOutDelayStart()
    {
        NSLog("timerPostFadeOutDelayStart: Called")

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
        NSLog("timerPostFadeOutDelayFired: Called")

        timerCancel("post_fade_out_delay")

        transitionToNextSongNow()
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

        NSLog("fade (\(fadeIn ? "in" : "out")): Starting");

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

            // NSLog("fade (\(fadeIn ? "in" : "out")): Step \(currentStep) sets volume \(newVolume) for target \(toVolume)")

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
