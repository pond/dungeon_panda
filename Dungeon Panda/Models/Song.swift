//
//  Song.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 14/03/21.
//

import Foundation

/**
 Holds some properties about a song read from Apple Music over API.
 See also https://www.appcoda.com/musickit-music-api/.
*/
struct Song
{
    var id: String
    var name: String
    var artistName: String?
    var artworkURL: String?
 
    init(id: String, name: String, artistName: String?, artworkURL: String?)
    {
        self.id = id
        self.name = name
        self.artistName = artistName
        self.artworkURL = artworkURL
    }
}
