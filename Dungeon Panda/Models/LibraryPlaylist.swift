//
//  LibraryPlaylist.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import Foundation

// https://developer.apple.com/documentation/applemusicapi/libraryplaylist/attributes
//
struct LibraryPlaylist {
    var id: String
    var name: String
    var artworkURL: String?
 
    init(id: String, name: String, artworkURL: String?) {
        self.id = id
        self.name = name
        self.artworkURL = artworkURL
    }
}
