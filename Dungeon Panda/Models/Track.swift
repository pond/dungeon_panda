//
//  Track.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 18/03/21.
//

import Foundation

struct Track {
    var id: String
    var startSeconds: UInt16
    var endSeconds: UInt16
    var fadeIn: Bool
    var fadeOut: Bool

    init(id: String, startSeconds: UInt16, endSeconds: UInt16, fadeIn: Bool, fadeOut: Bool) {
        self.id = id
        self.startSeconds = startSeconds
        self.endSeconds = endSeconds
        self.fadeIn = fadeIn
        self.fadeOut = fadeOut
    }
}

