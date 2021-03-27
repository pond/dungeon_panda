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

    /// The Playlist from which we have successfully started playing.
    var currentPlaylist: Playlist

    /// Index into the Playlist from which we have successfully started playing.
    var currentPlaylistPosition: Int

    /// Play time from start of current track, if known.
    var currentPlaylistPlaybackOffsetInSeconds: TimeInterval?

    /// Set to whatever we want to start doing, once we commence something
    /// like a next-track / fade-out operation. If the user keeps changing
    /// their mind, these might change a few times before finally becoming
    /// set as Current.
    var targetPlaylist: Playlist?

    /// Index tracking intended position in `targetPlaylist`.
    var targetPlaylistPosition: Int?

    /// Keep up with playback position.
    var positionTimer: Timer?

    /// Used to perform fade-in operations.
    var fadeInTimer: Timer?

    /// Used to perform fade-out operations.
    var fadeOutTimer: Timer?

    /// Watchdog used to try and restart on "failed to prepare to play" errors.
    var watchdogTimer: Timer?

    init(playlistManager: PlaylistManager)
    {
        self.playlistManager         = playlistManager
        self.currentPlaylist         = playlistManager.getPlaylistForID(playlistID: playlistManager.currentPlaylist!.playlistID!)
        self.currentPlaylistPosition = playlistManager.getCurrentPlaybackPositionFor(playlistID: currentPlaylist.id!)

        self.mediaPlayer.repeatMode  = .none
        self.mediaPlayer.shuffleMode = .off

        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange ), name: .MPMusicPlayerControllerPlaybackStateDidChange,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemDidChange), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)

        startPlayingFromCurrentPlaylist()
    }

    func changePlaylist(playlistID: String)
    {
        self.targetPlaylist         = self.playlistManager.getPlaylistForID(playlistID: playlistID)
        self.targetPlaylistPosition = self.playlistManager.getCurrentPlaybackPositionFor(playlistID: playlistID)

        print("CHANGING TO: \(targetPlaylist!.displayName!)")
        print("WITH TRACKS: \(targetPlaylist!.storeIDs)")

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
        if self.mediaPlayer.playbackState == .playing,
           let currentTrack = self.playlistManager.getTrackByCurrentPosition(playlist: self.currentPlaylist, index: self.currentPlaylistPosition)
        {
            self.currentPlaylistPlaybackOffsetInSeconds = self.mediaPlayer.currentPlaybackTime
            self.delegates.forEach
            { (delegate) in
                delegate.playbackProgressChanged(
                    playbackManager: self,
                    inPlaylist: currentPlaylist,
                    withTrack: currentTrack,
                    // TODO: Account for track's start and end offsets for duration
                    position: self.currentPlaylistPlaybackOffsetInSeconds!,
                    duration: self.mediaPlayer.nowPlayingItem!.playbackDuration
                )
            }
        }
    }

    @objc func playbackStateDidChange()
    {
        let newState = self.mediaPlayer.playbackState

        print("playbackStateDidChange")
        print("playbackStateDidChange: State is now \(String(describing: newState))")

        switch newState
        {
            case .stopped, .interrupted, .paused:
                self.positionTimer?.invalidate()
                self.positionTimer = nil
                self.delegates.forEach
                { (delegate) in
                    delegate.playbackPaused(playbackManager: self)
                }

            case .playing:
                self.watchdogTimer?.invalidate()
                self.watchdogTimer = nil
                self.positionTimer = Timer(
                    timeInterval: 1,
                    target: self,
                    selector: #selector(playbackProgressChanged),
                    userInfo: nil,
                    repeats: true
                )

                RunLoop.current.add(self.positionTimer!, forMode: RunLoop.Mode.common)

                self.delegates.forEach
                { (delegate) in
                    delegate.playbackResumed(playbackManager: self)
                }

            default:
                print("Unsupported Event")
        }
    }

    @objc func nowPlayingItemDidChange()
    {
        print("nowPlayingItemDidChange")

        if let currentTrackByMusicPlayer = getCurrentTrackFromMusicPlayer(),
           let updatedPlaylistIndex = self.playlistManager.getTrackIndexFor(playlist: self.currentPlaylist, storeID: currentTrackByMusicPlayer.storeID)
        {
            print("nowPlayingItemDidChange: store ID \(currentTrackByMusicPlayer.storeID) yielding position \(updatedPlaylistIndex)")

            self.currentPlaylistPosition = updatedPlaylistIndex
            self.delegates.forEach
            { (delegate) in
                delegate.playbackStarted(
                    playbackManager: self,
                    inPlaylist: currentPlaylist,
                    withTrack: currentTrackByMusicPlayer
                )
            }
        }
    }

    @objc func playbackWatchdogFired(timer: Timer)
    {
        print("playbackWatchdogFired")

        if self.mediaPlayer.playbackState != .playing
        {
            print("WARNING: playbackWatchdogFired: Media player says 'not playing' - skipping to next track")
            transitionToNextSongWithFadeOutIfRequired()
        }
    }

    // MARK: - PRIVATE

    private func startPlayingFromCurrentPlaylist()
    {
        print("startPlayingFromCurrentPlaylist")

        if let track = self.playlistManager.getTrackByCurrentPosition(
            playlist: self.currentPlaylist,
            index:    self.currentPlaylistPosition
        )
        {
            print("startPlayingFromCurrentPlaylist: Store ID \(track.storeID) on playlist \(String(describing: self.currentPlaylist.id)) at position \(self.currentPlaylistPosition)")

            self.mediaPlayer.beginGeneratingPlaybackNotifications()
            self.mediaPlayer.setQueue(with: [track.storeID])
            self.mediaPlayer.prepareToPlay()

            startSongWithFadeInIfRequired()
        }
    }

    private func transitionToNextSongWithFadeOutIfRequired(forceImmediate: Bool = false)
    {
        if self.mediaPlayer.playbackState == .playing && forceImmediate == false {
            // TODO: Fade out first somehow
        }

        _ = self.playlistManager.currentItemHasBeenPlayedIn(playlistID: self.currentPlaylist.id!)

        self.currentPlaylist         = self.targetPlaylist!
        self.currentPlaylistPosition = self.playlistManager.getCurrentPlaybackPositionFor(playlistID: self.currentPlaylist.id!)
        self.targetPlaylist          = nil
        self.targetPlaylistPosition  = nil

        startPlayingFromCurrentPlaylist()
    }

    private func startSongWithFadeInIfRequired()
    {
        // Set volume to zero, set a flag saying "fading in"
        startSongNow()
        // ONce playback position changes start to happen, kick off fade-in.
    }

    // TODO - add start offset for playback
    //
    private func startSongNow()
    {
        self.watchdogTimer = Timer(
            timeInterval: 10,
            target: self,
            selector: #selector(playbackWatchdogFired),
            userInfo: nil,
            repeats: false
        )

        RunLoop.current.add(self.watchdogTimer!, forMode: RunLoop.Mode.common)

        self.mediaPlayer.prepareToPlay()
        self.mediaPlayer.play()
    }

    private func getCurrentTrackFromMusicPlayer() -> Track?
    {
        if let currentlyPlayingStoreID = self.mediaPlayer.nowPlayingItem?.playbackStoreID
        {
            return self.playlistManager.getTrackByStoreID(playlist: self.currentPlaylist, storeID: currentlyPlayingStoreID)
        }
        else
        {
            return nil
        }
    }
}
