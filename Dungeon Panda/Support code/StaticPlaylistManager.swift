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
        tracks.append(Track(id: "896588775", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(id: "896588704", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(id: "i.NdlWQUPOgkpK", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        playlists["good-background"] = Playlist(name: "Good - Backround", tracks: tracks)

        // Good: Tavern
        //
        tracks = [Track]()
        tracks.append(Track(id: "896588781", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(id: "885304419", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(id: "883013089", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        playlists["good-tavern"] = Playlist(name: "Good - Tavern", tracks: tracks)

        // Good: Quirky
        //
        tracks = [Track]()
        tracks.append(Track(id: "669578598", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(id: "885304414", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        tracks.append(Track(id: "1263826302", startSeconds: 0, endSeconds: 0, fadeIn: true, fadeOut: true))
        playlists["good-quirky"] = Playlist(name: "Good - Quirky", tracks: tracks)

        // Good: Victory
        //
        tracks = [Track]()
        tracks.append(Track(id: "i.Ndl70SPOgkpK", startSeconds: 0, endSeconds: 0, fadeIn: false, fadeOut: true))
        tracks.append(Track(id: "669578601", startSeconds: 0, endSeconds: 0, fadeIn: false, fadeOut: true))
        tracks.append(Track(id: "883013108", startSeconds: 0, endSeconds: 0, fadeIn: false, fadeOut: true))
        playlists["good-victory"] = Playlist(name: "Good - Victory", tracks: tracks)
    }
}
