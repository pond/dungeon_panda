//
//  Track.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 18/03/21.
//

import Foundation

/**
 Statically initialised information about a Tracklist item, giving an identifier used for music playback
 and providing parameters indicating how it should be played back/
*/
struct Track
{
    var storeID: String
    var displayName: String
    var startSeconds: Int
    var endSeconds: Int
    var fadeIn: Bool
    var fadeOut: Bool

    init(storeID: String, displayName: String, startSeconds: Int, endSeconds: Int, fadeIn: Bool, fadeOut: Bool)
    {
        self.storeID = storeID
        self.displayName = displayName
        self.startSeconds = startSeconds
        self.endSeconds = endSeconds
        self.fadeIn = fadeIn
        self.fadeOut = fadeOut
    }
}
