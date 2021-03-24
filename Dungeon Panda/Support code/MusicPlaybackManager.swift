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
    func playbackProgressChanged(playbackManager: MusicPlaybackManager, inPlaylist: Playlist, withTrack: Track, position: TimeInterval)
    func playbackPaused(playbackManager: MusicPlaybackManager)
    func playbackResumed(playbackManager: MusicPlaybackManager)
    func playbackStopped(playbackManager: MusicPlaybackManager)
}

class MusicPlaybackManager {

    public var delegates: [MusicPlaybackManagerDelegate] = []

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let mediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer

    var playlistManager: PlaylistManager

    // Set to whatever we've actually successfully started
    //
    var currentPlaylistID: String
    var currentPlaylistIndex: Int

    // Set to whatever we want to start doing, once we commence something
    // like a next-track / fade-out operation. If the user keeps changing
    // their mind, these might change a few times before finally becoming
    // set as Current.
    //
    var targetPlaylistID: String?
    var targetPlaylistIndex: Int?

    // Keep up with playback position changes.
    //
    var timer: Timer?

    init(playlistManager: PlaylistManager)
    {
        self.playlistManager = playlistManager

        // TODO: info from CoreData & if none, sets up a new one. Then gets
        // TODO: the most recently played thing if any and starts it. Else
        // TODO: no point guessing on prepare-to-play
        
        // Init of core data would require generating a random sequence of
        // playlist items -

        self.currentPlaylistID = "background-good"
        self.currentPlaylistIndex = 0

        NotificationCenter.default.addObserver(self, selector: #selector(playbackStateDidChange), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingItemDidChange), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)

        self.mediaPlayer.repeatMode = .none
        self.mediaPlayer.shuffleMode = .off
    }

    func changePlaylist(playlistID: String) {
//        if let targetPlaylist = self.playlistManager.getPlaylistWith(playlistID: playlistID) {
//            self.targetPlaylistID = playlistID
//            self.targetPlaylistIndex = getNextIndexForPlaylist(playlistID: playlistID)
//
//            print("CHANGING TO: \(targetPlaylist.name)")
//            print("WITH TRACKS: \(targetPlaylist.tracks.map {$0.storeID})")
//
//            transitionToNextSongWithFadeOutIfRequired()
//        }
    }
    
    func skipTrack() {
    }
    
    func pause() {
        self.mediaPlayer.pause()
    }
    
    func resume() {
        self.mediaPlayer.play()
    }

    // MARK: - Handle playback events

    @objc func playbackProgressChanged(timer: Timer) {
//        if self.mediaPlayer.playbackState == .playing,
//           let currentPlayist = getCurrentPlaylist(),
//           let currentTrack = currentPlayist.getTrackAt(trackIndex: self.currentPlaylistIndex) {
//            let position = mediaPlayer.currentPlaybackTime
//            self.delegates.forEach { (delegate) in
//                delegate.playbackProgressChanged(
//                    playbackManager: self,
//                    inPlaylist: currentPlayist,
//                    withTrack: currentTrack,
//                    position: position
//                )
//            }
//        }
    }
    @objc func playbackStateDidChange() {
        switch mediaPlayer.playbackState {
        case .stopped, .interrupted, .paused:
            self.timer?.invalidate()
            self.timer = nil
            self.delegates.forEach { (delegate) in
                delegate.playbackPaused(playbackManager: self)
            }
        case .playing:
            let newTimer = Timer(timeInterval: 1, target: self, selector: #selector(playbackProgressChanged), userInfo: nil, repeats: true)
            RunLoop.current.add(newTimer, forMode: RunLoop.Mode.common)
            self.timer = newTimer
            self.delegates.forEach { (delegate) in
                delegate.playbackResumed(playbackManager: self)
            }
        default:
            print("Unsupported Event")
        }
    }

    @objc func nowPlayingItemDidChange() {
//        if let currentPlaylist = getCurrentPlaylist(),
//           let currentTrackByOurIndex = currentPlaylist.getTrackAt(trackIndex: self.currentPlaylistIndex),
//           let currentTrackByMusicPlayer = getCurrentTrackFromMusicPlayer()
//        {
//            if currentTrackByOurIndex.storeID != currentTrackByMusicPlayer.storeID,
//               let updatedPlaylistIndex = currentPlaylist.getTrackIndexFor(storeID: currentTrackByMusicPlayer.storeID)
//            {
//                self.currentPlaylistIndex = updatedPlaylistIndex
//
//                delegates.forEach { (delegate) in
//                    delegate.playbackStarted(
//                        playbackManager: self,
//                        inPlaylist: currentPlaylist,
//                        withTrack: currentTrackByMusicPlayer
//                    )
//                }
//            }
//        }
    }

    // Given a playlist ID, which might be current or an intended next target,
    // return the in-playlist zero-based song index of the next item to play,
    // using pre-initialised random shuffle with never-repeat semantics.
    //
    private func getNextIndexForPlaylist(playlistID: String) -> Int {
        return 0

/*

So I need to generate a list of random order indices into the static
and is THIS which we use to build the song IDs but that means all the
lookups will be wrong.

Instead we could have the static playlist manager self-shuffle on 1st
launch, but how would it know when to reshuffle? Maybe it only does
it once
         
         
         The core data model say "playlist foo index 0"
         If this is missing for a playlist, shuffle and add it
         Reshuffle algorithm:
           




*/
    }
    
//    private func enqueueSong(songId: String) {
//    }
//
//    private func startSongWithFadeInIfRequired() {
//        self.mediaPlayer.play()
//    }
//
//    private func transitionToNextSongWithFadeOutIfRequired() {
//        if mediaPlayer.playbackState == .playing {
//            // TODO: Fade out first somehow
//        }
//
//        self.currentPlaylistID = self.targetPlaylistID!
//        self.currentPlaylistIndex = self.targetPlaylistIndex!
//        self.targetPlaylistID = nil
//        self.targetPlaylistIndex = nil
//
//        let currentPlaylist = self.playlistManager.getPlaylistWith(playlistID: self.currentPlaylistID)!
//
//        self.mediaPlayer.beginGeneratingPlaybackNotifications()
//        self.mediaPlayer.setQueue(with: currentPlaylist.tracks.map {$0.storeID})
//        self.mediaPlayer.prepareToPlay()
//
//        self.startSongWithFadeInIfRequired()
//    }
//
//    private func getCurrentPlaylist() -> Playlist? {
//        return playlistManager.getPlaylistWith(playlistID: self.currentPlaylistID)
//    }
//
//    private func getCurrentTrackFromMusicPlayer() -> Track? {
//        if let currentlyPlayingStoreID = mediaPlayer.nowPlayingItem?.playbackStoreID,
//           let currentPlayist = getCurrentPlaylist() {
//            return currentPlayist.getTrackBy(storeID: currentlyPlayingStoreID)
//        }
//        else {
//            return nil
//        }
//    }
}
