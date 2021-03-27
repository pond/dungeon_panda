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

    /// Offset from start of track to begin playback, in seconds.
    var startOffset: TimeInterval

    /// Offset from end of track (positive backwards, towards track start) in seconds.
    var endOffset: TimeInterval

    /// If `true`, track should be faded in, else started normally.
    var fadeIn: Bool

    /// If `true`, should be faded out at its endpoint, else allowed to stop abruptly.
    var fadeOut: Bool

    init(storeID: String, displayName: String, startOffset: TimeInterval, endOffset: TimeInterval, fadeIn: Bool, fadeOut: Bool)
    {
        self.storeID = storeID
        self.displayName = displayName
        self.startOffset = startOffset
        self.endOffset = endOffset
        self.fadeIn = fadeIn
        self.fadeOut = fadeOut
    }
}
