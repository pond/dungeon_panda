//
//  Tracklist.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 22/03/21.
//

import Foundation

/**
 Statically initialised list of Track objects, each representing something to be played back
 as part of whatever "theme" this list will represent. See StaticTracklistManager for more.

 Tracklist and Playlist objects share common IDs - if the IDs match, they are related. The
 IDs can and almost always are used interchangeably.
*/
class Tracklist
{
    var id:              String
    var displayName:     String
    var version:         Int32
    var volumePercent:   Int32
    var autoSwitchAfter: String?
    var tracks:          [String:Track] = [:]

    /**
     Create a new instance.

     - Parameters:
        - id: Tracklist ID (interchangeable with playlist IDs)
        - displayName: Human-facing name of the Tracklist
        - version: Version number (integer, starting at 1)
        - volumePercent: Master volume for all tracks, relative to reference system volume.
        - autoSwitchAfter: Optional playlist name, switched to after any Track in this Tracklist plays to completion.
        - tracks: Array of Track objects (may be empty)

     The `tracks` array can be updated with the `add` method later.
    */
    init(
                     id: String,
            displayName: String,
                version: Int32,
          volumePercent: Int32,
        autoSwitchAfter: String?,
                 tracks: [Track]
    )
    {
        self.id              = id
        self.displayName     = displayName
        self.version         = version
        self.volumePercent   = volumePercent
        self.autoSwitchAfter = autoSwitchAfter

        for track in tracks
        {
            self.add(track)
        }
    }

    /**
     Add a new Track to this Tracklist.

     - Parameter track: Track to add.
    */
    func add(_ track: Track)
    {
        assert(self.tracks[track.storeID] == nil, "Track with Store ID \(track.storeID) has already been added to Tracklist \(self.id)")
        self.tracks[track.storeID] = track
    }

    /**
     Get all store IDs of the tracks in this Tracklist.

     - Returns: Array of Strings - Apple Music Store IDs. Always returned in the same order.
    */
    func getStoreIDArray() -> [String]
    {
        return Array(tracks.keys.sorted())
    }

    /**
     Retrieve a track by its Store ID.

     - Parameter storeID: Store ID to look up.
     - Returns: Found Track, or if the Store ID is not in this Tracklist, a random Track to avoid crashes.
     */
    func getTrackBy(storeID: String) -> Track
    {
        if let track = tracks[storeID]
        {
            return track
        }
        else
        {
            return tracks.values.randomElement()!
        }
    }
}
