//
//  PlaylistManager.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 22/03/21.
//

import Foundation
import CoreData
import UIKit

/**
 A PlaylistManager keeps track of shuffled playback orders within 
*/
class PlaylistManager {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let staticTracklistManager: StaticTracklistManager
    let persistentContainer: NSPersistentCloudKitContainer

    var playlists = [Playlist]()
    var playlistsByID: [String:Playlist] = [:]
    var currentPositionsInPlaylists = [CurrentPositionInPlaylist]()
    var currentPositionsInPlaylistsByID: [String:CurrentPositionInPlaylist] = [:]

    var currentPlaylist: CurrentPlaylist?

    /**
     When created, a PlaylistManager fetches all static tracklists and for each:
     
     * Determines if it has a shuffle order defined for it yet and, if not, builds one
     * Determines the current index last recorded in that shuffle order
     
     iCloud-backed CoreData is used to retrieve and save the above data.
     
     - Parameter staticTracklistManager: StaticTracklistManager instance to be used as a source of all tracklist information
     - Parameter persistentContainer: NSPersistentCloudKitContainer to be used for CoreData operations
    */
    init(staticTracklistManager: StaticTracklistManager,
         persistentContainer: NSPersistentCloudKitContainer)
    {
        self.staticTracklistManager = staticTracklistManager
        self.persistentContainer = persistentContainer

        let context = self.persistentContainer.viewContext

        // Fetch all playlist records in Core Data locally now.
        //
        do
        {
            let records = try context.fetch(Playlist.fetchRequest())
            if let records = records as? [Playlist]
            {
                playlists = records
            }
        }
        catch
        {
            print("WARNING: Unable to fetch playlists from Core Data; creating new")
        }

        // Fetch all play positions within the playlists.
        //
        do
        {
            let records = try context.fetch(CurrentPositionInPlaylist.fetchRequest())
            if let records = records as? [CurrentPositionInPlaylist]
            {
                currentPositionsInPlaylists = records
            }
        }
        catch
        {
            print("WARNING: Unable to fetch positions from Core Data; creating new")
        }
        
        // Make local lookup easy by creating a Dictionary mapping playlist IDs
        // to the various objects above.
        //
        for playlist in playlists
        {
            playlistsByID[playlist.id!] = playlist
        }
        
        for position in currentPositionsInPlaylists
        {
            currentPositionsInPlaylistsByID[position.playlistID!] = position
        }

        // For all Tracklists, see if we have a Playlist defined and create one
        // if not. Remember, Tracklist and Playlist IDs are interchangeable.
        //
        for tracklist in staticTracklistManager.getTracklists()
        {
            if playlistsByID[tracklist.id] == nil
            {
                let newPlaylist = Playlist(context: context)
                newPlaylist.id = tracklist.id
                newPlaylist.displayName = tracklist.displayName
                newPlaylist.storeIDs = shuffleStoreIDsWithin(tracklist: tracklist)

                playlists.append(newPlaylist)
                playlistsByID[tracklist.id] = newPlaylist
            }
            
            if currentPositionsInPlaylistsByID[tracklist.id] == nil
            {
                let newPosition = CurrentPositionInPlaylist(context: context)
                newPosition.playlistID = tracklist.id
                newPosition.currentIndex = 0

                currentPositionsInPlaylists.append(newPosition)
                currentPositionsInPlaylistsByID[tracklist.id] = newPosition
            }
        }

        // Fetch the current playlist.
        //
        do
        {
            let records = try context.fetch(CurrentPlaylist.fetchRequest())
            if let records = records as? [CurrentPlaylist]
            {
                currentPlaylist = records.first
            }
        }
        catch
        {
            print("WARNING: Unable to current playlist from Core Data; creating new")
        }
        
        // Initialise a new current playlist object if need be.
        //
        if currentPlaylist == nil
        {
            let newCurrentPlaylist = CurrentPlaylist(context: context)
            newCurrentPlaylist.playlistID = playlists.first!.id
        }

        // Finally, save any changes made above.
        //
        appDelegate.saveContext()
    }
    
    //    - Gets that from Core Data or inits a new object at 0
    func getCurrentPlaybackIndexFor(playlistID: String) -> Int
    {
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

    /**
     Takes all Store IDs of Tracks in a given Tracklist and shuffles them into a random order, returning an
     Array of the shuffled Store ID Strings.
     
     - Parameter tracklist: Tracklist to examine.
     - Returns: Shuffled order Array of Store IDs.
    */
    func shuffleStoreIDsWithin(tracklist: Tracklist) -> [String]
    {
        var storeIDs = tracklist.getStoreIDArray()

        storeIDs.shuffle()
        storeIDs.shuffle()
        storeIDs.shuffle()
        
        return storeIDs
    }
    
    //    - Takes the first half of the existing playlist and shuffles it
    //    - Takes the last half of the existing playlist and shuffles it
    //    - Joins the two together
    //    Yes this means a user is locked into the same first-set and second-set of tracks, but
    //    definitively prevents a perceived repetition shortly after hearing prior tracks.
    func bisectAndReshuffle(playlistID: String) {
    }
}
