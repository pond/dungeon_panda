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

protocol MusicPlaybackManagerDelegate {
    func playbackStarted(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track)
    func playbackProgressChanged(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track, position: TimeInterval, duration: TimeInterval)
    func playbackPaused(playbackManager: MusicPlaybackManager)
    func playbackResumed(playbackManager: MusicPlaybackManager)
}

class MusicPlaybackManager {

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

    func changePlaylist(playlistID: String)
    {
        self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: playlistID)

        NSLog("changePlaylist: Changing to \(targetPlaylist!.id!)")
        NSLog("changePlaylist: Store IDs \(targetPlaylist!.storeIDs)")

        transitionToNextSongWithFadeOutIfRequired()
    }

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
        transitionToNextSongWithFadeOutIfRequired()
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
     Called by the view layer to tell us that the system volume was changed.

     - Parameter volume: Current system volume (from 0, silent, to 1, maximum).
     */
    func systemVolumeDidChange(volume: Double)
    {
        if transitionOperationUnderway == false
        {
            print("User changed system volume to \(volume)")
            self.referenceSystemVolume = volume
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
            self.hiddenSystemVolumeSlider?.value = Float(volume!)
        }
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
                    currentlyPlaying = false
                    currentlySeeking = false
                    effectivePlaybackStateDidHaltPlayback()
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

                transitionToNextSongWithFadeOutIfRequired()
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

            transitionToNextSongWithFadeOutIfRequired(forceImmediate: true)
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
            self.fadeInOnNextPlaybackStartedEvent = false
            self.transitionOperationUnderway      = false
        }

        let playingTrack = self.playlistManager.getPlayingTrack()

        // Set a timer to fade out just before the track moves on?
        //
        if playingTrack.fadeOut
        {
            let currentItemDuration   = self.mediaPlayer.nowPlayingItem?.playbackDuration
            let currentItemPosition   = self.mediaPlayer.currentPlaybackTime
            let trackEndOffset        = self.playlistManager.getPlayingTrack().endOffset
            let effectiveItemDuration = trackEndOffset != nil && trackEndOffset != 0 ? trackEndOffset : currentItemDuration
            let fadeOutDuration       = 2.0

            if effectiveItemDuration != 0 && effectiveItemDuration != nil
            {
                let timeUntilFadeStarts = effectiveItemDuration! - currentItemPosition - fadeOutDuration - 1.0 // 2 seconds for safety

                stopFadeOutInitiationTimer()

                print("(Re)scheduling fade-out timer to run in \(timeUntilFadeStarts) seconds")

                self.fadeOutInitiationTimer = Timer.scheduledTimer(
                    withTimeInterval: timeUntilFadeStarts,
                    repeats: false
                )
                { timer in
                    self.stopFadeOutInitiationTimer()
                    self.transitionToNextSongWithFadeOutIfRequired()
                }
            }
        }

        self.delegates.forEach { (delegate) in
            delegate.playbackResumed(playbackManager: self)
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

        let descriptor = self.playlistManager.getQueueDescriptorFor(playlist: playlist)

        self.mediaPlayer.setQueue(with: descriptor)
//        self.mediaPlayer.prepareToPlay()
//
//        self.startSongWithFadeInIfRequired(fromTrack: track)

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
                        self.transitionToNextSongWithFadeOutIfRequired(forceImmediate: true)
                    }
                }
            }
        )
    }

    private func transitionToNextSongWithFadeOutIfRequired(forceImmediate: Bool = false)
    {
        print("transitionToNextSongWithFadeOutIfRequired: Called, forceImmediate = \(forceImmediate)")

        self.transitionOperationUnderway = true

        stopFadeOutInitiationTimer()

        let mediaIsPlaying        = self.mediaPlayer.playbackState == .playing
        let currentItemDuration   = mediaIsPlaying ? self.mediaPlayer.nowPlayingItem?.playbackDuration : nil
        let currentItemPosition   = mediaIsPlaying ? self.mediaPlayer.currentPlaybackTime              : nil
        let trackEndOffset        = self.playlistManager.getPlayingTrack().endOffset
        let effectiveItemDuration = trackEndOffset != nil && trackEndOffset != 0 ? trackEndOffset : currentItemDuration
        let fadeOutDuration       = 2.0
        let fadeOutIsWorthwhile   = effectiveItemDuration != nil &&
                                    currentItemPosition   != nil &&
                                    effectiveItemDuration! - currentItemPosition! >= fadeOutDuration + 0.5 // 0.5s wiggle room

        if forceImmediate == false && mediaIsPlaying == true && fadeOutIsWorthwhile == true
        {
            fadeOut(
                duration: fadeOutDuration,
                completionHandler:
                {
                    // After this, the handler exits and the fade-out routine
                    // will clear its timer. There might be transitions that
                    // happen next which cause us to think system volume was
                    // set to zero, but we'll fix that in the code below.
                    //
                    self.mediaPlayer.pause()

                    // Without this hack, there is sometimes a brief loud spike
                    // in music because when we tell the player to pause, it
                    // doesn't do it immediately (obviously, because just doing
                    // something synchronously in the same thread when asked to
                    // is far too easy, isn't it... Rolls eyes).
                    //
                    // Since we reset to reference volume outside this thread
                    // context, the fade timer will be gone and we know that the
                    // change will be treated as a user-set event, making sure
                    // that 'self.referenceSystemVolume' ends up back at the
                    // prior level cached in variable 'resetSystemVolume' above.
                    //
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25)
                    {
                        self.setVolume(volume: self.referenceSystemVolume)
                        self.transitionToNextSongNow()
                    }
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
        self.mediaPlayer.play()
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
