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

    /// Used to perform fade-in operations.
    var fadeInTimer: Timer?

    /// Used to perform fade-out operations.
    var fadeOutTimer: Timer?

    init(playlistManager: PlaylistManager)
    {
        self.playlistManager         = playlistManager
        self.mediaPlayer.repeatMode  = .none
        self.mediaPlayer.shuffleMode = .off

        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange ), name: .MPMusicPlayerControllerPlaybackStateDidChange,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemDidChange), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    }

    /**
     Start playback after initial application launch. Called externally, when the view layer
     believes it is "safe" / sensible to do so. Can be called off main thread.
    */
    func startInitialPlayback()
    {
        DispatchQueue.main.async
        {
            self.startPlayingFromCurrentPlaylist()
        }
    }

    func changePlaylist(playlistID: String)
    {
        self.targetPlaylist = self.playlistManager.getPlaylistForID(playlistID: playlistID)

        print("changePlaylist: Changing to \(targetPlaylist!.id!)")
        print("changePlaylist: Store IDs \(targetPlaylist!.storeIDs)")

        transitionToNextSongWithFadeOutIfRequired()
    }

    func skipTrack()
    {
    }

    func pause()
    {
        self.mediaPlayer.pause()
    }

    func resume()
    {
        self.mediaPlayer.play()
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
        let newState = self.mediaPlayer.playbackState

        switch newState
        {
            case .paused:
                print("playbackStateDidChange: Stopped")

                stopWatchdogTimer()
                stopPositionTimer()

                self.delegates.forEach { (delegate) in
                    delegate.playbackPaused(playbackManager: self)
                }

            case .playing:
                print("playbackStateDidChange: Playing")

                stopWatchdogTimer()
                startPositionTimer()

                self.delegates.forEach { (delegate) in
                    delegate.playbackResumed(playbackManager: self)
                }

            default:
                print("playbackStateDidChange: Uninteresting event")
        }
    }

    @objc func nowPlayingItemDidChange()
    {
        print("nowPlayingItemDidChange: Called")

        var (playingPlaylist, playingTrack, playingIndex) = self.playlistManager.nowPlaying()

        if let newPlaybackStoreID = mediaPlayer.nowPlayingItem?.playbackStoreID,
           let newPlayingIndex    = self.playlistManager.getTrackIndexFor(
             playlist: playingPlaylist,
             storeID:  newPlaybackStoreID
           )
        {
            if newPlayingIndex != playingIndex
            {
                print("nowPlayingItemDidChange: Store ID \(newPlaybackStoreID) yielding new playlist index \(newPlayingIndex)")

                self.playlistManager.setCurrentPlaybackIndexFor(playlist: playingPlaylist, index: newPlayingIndex)
                (playingPlaylist, playingTrack, playingIndex) = self.playlistManager.nowPlaying()
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

            transitionToNextSongWithFadeOutIfRequired()
        }
    }

    // MARK: - PRIVATE: TIMERS

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

    // MARK: - PRIVATE: MISCELLANEOUS

    func startPlayingFromCurrentPlaylist()
    {
        let (playlist, track, index) = self.playlistManager.nowPlaying()

        print("startPlayingFromCurrentPlaylist: Store ID \(track.storeID) on playlist \(playlist.id!) at index \(index)")

        self.delegates.forEach { (delegate) in
            delegate.playbackStarted(
                playbackManager: self,
                inPlaylist:      playlist,
                withTrack:       track
            )
        }

        let descriptor = self.playlistManager.getQueueDescriptorFor(playlist: playlist)

        self.mediaPlayer.beginGeneratingPlaybackNotifications()
        self.mediaPlayer.setQueue(with: descriptor)
        self.mediaPlayer.prepareToPlay()

        self.startSongWithFadeInIfRequired()
//        self.mediaPlayer.prepareToPlay(
//            completionHandler:
//            { error in
//                if error == nil
//                {
//                    DispatchQueue.main.async
//                    {
//                        self.startSongWithFadeInIfRequired()
//                    }
//                }
//                else
//                {
//                    print("startPlayingFromCurrentPlaylist: ERROR: \(error!)")
//
//                    self.stopWatchdogTimer()
//                    self.targetPlaylist = playlist
//
//                    DispatchQueue.main.async
//                    {
//                        self.transitionToNextSongWithFadeOutIfRequired(forceImmediate: true)
//                    }
//                }
//            }
//        )
    }

    private func transitionToNextSongWithFadeOutIfRequired(forceImmediate: Bool = false)
    {
        print("transitionToNextSongWithFadeOutIfRequired: Called, forceImmediate = \(forceImmediate)")

        if self.mediaPlayer.playbackState == .playing && forceImmediate == false {
            // TODO: Fade out first somehow
        }

        // Work out the next index in this playlist now that the current item
        // has been played. If changing playlist, just switch that over and let
        // playback start from whatever the most recent index was there. If the
        // playlist is unchanged, use the index given by the playlist manager.
        //
        let playingPlaylist = self.playlistManager.getPlayingPlaylist()
        let nextTrackIndex  = self.playlistManager.currentItemHasBeenPlayedIn(
            playlistID: self.playlistManager.getPlayingPlaylist().id!
        )

        if playingPlaylist.id != targetPlaylist!.id
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

    private func startSongWithFadeInIfRequired()
    {
        print("startSongWithFadeInIfRequired: Called")

        // TODO - Set volume to zero, set a flag saying "fading in"
        startSongNow()
        // TODO - Once playback position changes start to happen, kick off fade-in.
    }

    // TODO - add start offset for playback
    //
    private func startSongNow()
    {
        print("startSongNow: Called")

        startWatchdogTimer()
        self.mediaPlayer.play()
    }

    private func getCurrentTrackFromMusicPlayer() -> Track?
    {
        if let currentlyPlayingStoreID = self.mediaPlayer.nowPlayingItem?.playbackStoreID
        {
            return self.playlistManager.getTrackByStoreID(
                playlist: self.playlistManager.getPlayingPlaylist(),
                storeID: currentlyPlayingStoreID
            )
        }
        else
        {
            return nil
        }
    }
}
