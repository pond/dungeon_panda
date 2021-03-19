//
//  Playlist.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 18/03/21.
//

import Foundation

struct Playlist {
    var name: String
    var tracks: [Track]
    
    init(name: String, tracks: [Track]) {
        self.name = name
        self.tracks = tracks
    }
}
