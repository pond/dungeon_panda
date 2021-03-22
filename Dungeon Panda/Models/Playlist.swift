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
    
    func getTrackAt(trackIndex: Int) -> Track? {
        return trackIndex >= 0 && trackIndex < self.tracks.count
                ? self.tracks[trackIndex]
                : nil
    }
    
    func getTrackBy(storeID: String) -> Track? {
        let filteredTracks = self.tracks.filter() { (track) -> Bool in
            track.storeID == storeID
        }

        return filteredTracks.first
    }
    
    func getTrackIndexFor(storeID: String) -> Int? {
        return self.tracks.firstIndex(where: { $0.storeID == storeID })
    }
}
