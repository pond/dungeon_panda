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
struct Tracklist {
    var id: String
    var displayName: String
    var tracks: [String:Track] = [:]

    init(id: String, displayName: String, tracks: [Track]) {
        self.id = id
        self.displayName = displayName
        
        for track in tracks {
            self.tracks[track.storeID] = track
        }
    }
    
    func getTrackBy(storeID: String) -> Track? {
        tracks[storeID]
    }
    
    func getTrackIndexFor(storeID: String) -> Int? {
        return self.tracks.firstIndex(where: { $0.id == storeID })
    }
}
