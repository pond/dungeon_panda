//
//  PlaylistManager.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 22/03/21.
//

import Foundation
import CoreData
import UIKit

class PlaylistManager {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    //        ==== The playlist manager at init fetches all tracklists and for each:
    //        - Determines if it has a shuffle order for it yet (TODO: HOW?), and if not, builds one
    //        - Reads Core Data to get the current index into that shuffle order
    init () {
    }
    
    //    - Gets that from Core Data or inits a new object at 0
    func getCurrentPlaybackIndexFor(playlistID: String) -> Int {
        return 0
    }

    //    - Semaphore lock
    //    - Gets from Core Data
    //    - Increments
    //    - If it goes beyond end of playlist, reshuffle and reset to zero
    //    - Saves
    //    - Unlock
    func currentItemHasBeenPlayedIn(playlistID: String) {
    }

private

    func shuffle(playlistID: String) {
    }
    
    //    - Takes the first half of the existing playlist and shuffles it
    //    - Takes the last half of the existing playlist and shuffles it
    //    - Joins the two together
    //    Yes this means a user is locked into the same first-set and second-set of tracks, but
    //    definitively prevents a perceived repetition shortly after hearing prior tracks.
    func bisectAndReshuffle(playlistID: String) {
    }
}
