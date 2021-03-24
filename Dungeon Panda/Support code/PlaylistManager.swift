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
 A PlaylistManager keeps track of shuffled playback orders within Tracklists.
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
     
     - Parameters:
        - staticTracklistManager: StaticTracklistManager instance to be used as a source of all tracklist information
        - persistentContainer: NSPersistentCloudKitContainer to be used for CoreData operations
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
    
    /**
     Retrieve the current playback index for a given playlist.
     
     - Parameter playlistID: Playlist (or tracklist) ID of interest.
     - Returns: Current playback index, or 0 if the ID is unrecognised.
    */
    func getCurrentPlaybackIndexFor(playlistID: String) -> Int
    {
        if let position = currentPositionsInPlaylistsByID[playlistID]
        {
            return Int(position.currentIndex)
        }
        else
        {
            return 0
        }
    }

    /**
     Call when a media player monitoring class notices that a track has finished.
     
     - Parameter playlistID: ID of playlist in which playback completed.
     - Returns: Playlist index in that playlist of next item to be played.
     
     Internally, if the end of the playlist has been reached, it is reshuffled and the returned index
     will be zero. Everything is persisted synchronously to Core Data.
    */
    func currentItemHasBeenPlayedIn(playlistID: String) -> Int {
        let playlist        = playlistsByID[playlistID]!
        let currentPosition = currentPositionsInPlaylistsByID[playlistID]!

        currentPosition.currentIndex += 1

        if currentPosition.currentIndex >= playlist.storeIDs.count
        {
            currentPosition.currentIndex = 0
            bisectAndReshuffle(playlist: playlist)
        }
        
        appDelegate.saveContext()
        return Int(currentPosition.currentIndex)
    }

    /**
     Takes all Store IDs of Tracks in a given Tracklist and shuffles them into a random order, returning an
     Array of the shuffled Store ID Strings.
     
     - Parameter tracklist: Tracklist to examine.
     - Returns: Shuffled order Array of Store IDs.
    */
    private func shuffleStoreIDsWithin(tracklist: Tracklist) -> [String]
    {
        var storeIDs = tracklist.getStoreIDArray()

        storeIDs.shuffle()
        storeIDs.shuffle()
        storeIDs.shuffle()
        
        return storeIDs
    }
    
    /**
     Takes a playlist and bisects its store ID array into two halves, shuffles each half, then
     rejoins them in reverse order.
     
     - Parameter playlist: Playlist to alter (mutated in place).
     
     The altered playlist is _not_ automatically saved back to Core Data.
    */
    private func bisectAndReshuffle(playlist: Playlist)
    {
        let array    = playlist.storeIDs
        let midpoint = Int(array.count / 2)
        var sliceA   = array[0 ..< midpoint]
        var sliceB   = array[midpoint ..< array.count]

        sliceA.shuffle()
        sliceA.shuffle()
        sliceA.shuffle()
        
        sliceB.shuffle()
        sliceB.shuffle()
        sliceB.shuffle()
        
        playlist.storeIDs = Array(sliceB) + Array(sliceA)
    }
}
