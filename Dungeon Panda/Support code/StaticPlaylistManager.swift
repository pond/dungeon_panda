//
//  StaticPlaylistManager.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 19/03/21.
//

import Foundation

class StaticPlaylistManager {
    var playlists: [String:Playlist] = [:]

    init() {
        var tracks: [Track]

        // Good: Background
        //
        tracks = [Track]()
        tracks.append(Track(storeID: "896588775", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(storeID: "896588704", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(storeID: "i.NdlWQUPOgkpK", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        playlists["good-background"] = Playlist(name: "Good - Backround", tracks: tracks)

        // Good: Tavern
        //
        tracks = [Track]()
        tracks.append(Track(storeID: "896588781", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(storeID: "885304419", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(storeID: "883013089", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        playlists["good-tavern"] = Playlist(name: "Good - Tavern", tracks: tracks)

        // Good: Quirky
        //
        tracks = [Track]()
        tracks.append(Track(storeID: "669578598", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(storeID: "885304414", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(storeID: "1263826302", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        playlists["good-quirky"] = Playlist(name: "Good - Quirky", tracks: tracks)

        // Good: Victory
        //
        tracks = [Track]()
        tracks.append(Track(storeID: "i.Ndl70SPOgkpK", startSeconds: 0, endSeconds: 0, fadeIn: false, fadeOut: true))
        tracks.append(Track(storeID: "669578601", startSeconds: 0, endSeconds: 0, fadeIn: false, fadeOut: true))
        tracks.append(Track(storeID: "883013108", startSeconds: 0, endSeconds: 0, fadeIn: false, fadeOut: true))
        playlists["good-victory"] = Playlist(name: "Good - Victory", tracks: tracks)
    }
    
    func getPlaylistWith(playlistID: String) -> Playlist? {
        return playlists[playlistID]
    }
    
    func getTrackFor(playlistID: String, playlistIndex: Int) -> Track? {
        let playlist = getPlaylistWith(playlistID: playlistID)
        return playlist?.getTrackAt(trackIndex: playlistIndex)
    }
}
