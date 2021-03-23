//
//  Playlist.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 18/03/21.
//

import Foundation

/**
 A representation of an array of Store IDs obtained from a tracklist, shuffled into an initial
 static random order, with an index indicating play position progression through that list.
 CoreData storage is used to back up play positions and shuffle results.
 
 Tracklist and Playlist objects share common IDs - if the IDs match, they are related. The
 IDs can and almost always are used interchangeably.
 */

class NotReallyAPlaylist
{
    var name: String
    var tracks: [Track]
    
    init(name: String, tracks: [Track])
    {
        self.name = name
        self.tracks = tracks
    }
    
    func getTrackAt(trackIndex: Int) -> Track?
    {
        return trackIndex >= 0 && trackIndex < self.tracks.count
                ? self.tracks[trackIndex]
                : nil
    }
    
    func getTrackBy(storeID: String) -> Track?
    {
        let filteredTracks = self.tracks.filter()
        { (track) -> Bool in
            track.storeID == storeID
        }

        return filteredTracks.first
    }
    
    func getTrackIndexFor(storeID: String) -> Int?
    {
        return self.tracks.firstIndex(where: { $0.storeID == storeID })
    }
}
