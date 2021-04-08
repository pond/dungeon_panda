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
    /// Apple Music store ID for the track.
    var storeID: String

    /// Human-facing display name.
    var displayName: String

    /// Alternate human-facing display name (if set, view alternates between this and `displayName`)
    var altDisplayName: String?

    /// Offset from start of track to begin playback, in seconds.
    var startOffset: TimeInterval

    /// Offset _from start_ of track for end of playback, in seconds.
    var endOffset: TimeInterval?

    /// If `true`, track should be faded in, else started normally.
    var fadeIn: Bool

    /// If `true`, should be faded out at its endpoint, else allowed to stop abruptly.
    var fadeOut: Bool

    init(
        storeID:        String,
        displayName:    String,
        altDisplayName: String?       = nil,
        startOffset:    TimeInterval  = 0,
        endOffset:      TimeInterval? = nil,
        fadeIn:         Bool          = false,
        fadeOut:        Bool          = false
    )
    {
        self.storeID        = storeID
        self.displayName    = displayName
        self.altDisplayName = altDisplayName
        self.startOffset    = startOffset
        self.endOffset      = endOffset
        self.fadeIn         = fadeIn
        self.fadeOut        = fadeOut
    }
}
