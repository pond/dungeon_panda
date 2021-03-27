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
        print("PlaylistManager init")

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
                print("PlaylistManager init: Successfully fetched playlists from Core Data")
                self.playlists = records
            }
        }
        catch
        {
            print("PlaylistManager init: Unable to fetch playlists from Core Data; creating new")
        }

        // Fetch all play positions within the playlists.
        //
        do
        {
            let records = try context.fetch(CurrentPositionInPlaylist.fetchRequest())
            if let records = records as? [CurrentPositionInPlaylist]
            {
                print("PlaylistManager init: Successfully fetched positions from Core Data")
                self.currentPositionsInPlaylists = records
            }
        }
        catch
        {
            print("PlaylistManager init: Unable to fetch positions from Core Data; creating new")
        }

        // Make local lookup easy by creating a Dictionary mapping playlist IDs
        // to the various objects above.
        //
        for playlist in self.playlists
        {
            self.playlistsByID[playlist.id!] = playlist
        }

        for position in self.currentPositionsInPlaylists
        {
            self.currentPositionsInPlaylistsByID[position.playlistID!] = position
        }

        // For all Tracklists, see if we have a Playlist defined and create one
        // if not. Remember, Tracklist and Playlist IDs are interchangeable.
        //
        for tracklist in staticTracklistManager.getTracklists()
        {
            if self.playlistsByID[tracklist.id] == nil
            {
                let newPlaylist = Playlist(context: context)
                newPlaylist.id = tracklist.id
                newPlaylist.displayName = tracklist.displayName
                newPlaylist.storeIDs = shuffleStoreIDsWithin(tracklist: tracklist)

                self.playlists.append(newPlaylist)
                self.playlistsByID[tracklist.id] = newPlaylist
            }

            if self.currentPositionsInPlaylistsByID[tracklist.id] == nil
            {
                let newPosition = CurrentPositionInPlaylist(context: context)
                newPosition.playlistID = tracklist.id
                newPosition.currentIndex = 0

                self.currentPositionsInPlaylists.append(newPosition)
                self.currentPositionsInPlaylistsByID[tracklist.id] = newPosition
            }
        }

        // Fetch the current playlist.
        //
        do
        {
            let records = try context.fetch(CurrentPlaylist.fetchRequest())
            if let records = records as? [CurrentPlaylist]
            {
                print("PlaylistManager init: Successfully fetched current playlist from Core Data")
                currentPlaylist = records.first
            }
        }
        catch
        {
            print("PlaylistManager init: Unable to current playlist from Core Data; creating new")
        }

        // Initialise a new current playlist object if need be.
        //
        if currentPlaylist == nil
        {
            self.currentPlaylist = CurrentPlaylist(context: context)
            self.currentPlaylist!.playlistID = self.playlists.first!.id
        }

        // Finally, save any changes made above.
        //
        appDelegate.saveContext()
    }

    /**
     Return a Playlist stored for the given ID.

     - Parameter playlistID: ID of Playlist (or Tracklist). **Must be valid**.
     - Returns: Playlist object corresponding to ID.

     The playlist ID must be valid, else an internal exception and app shutdown will occur.
     */
    func getPlaylistForID(playlistID: String) -> Playlist
    {
        return self.playlistsByID[playlistID]!
    }

    /**
     Return a Track in a given Playlist based on a Store ID.

     - Parameters:
         - playlist: The Playlist to examine
         - storeID: Store ID of track

     - Returns: Track if found, else `nil`.
    */
    func getTrackByStoreID(playlist: Playlist, storeID: String) -> Track?
    {
        let tracklist = self.staticTracklistManager.getTracklistBy(tracklistID: playlist.id!)!
        return tracklist.getTrackBy(storeID: storeID)
    }

    /**
     Return a Track in a given Playlist based on playback index.

     - Parameters:
         - playlist: The Playlist to examine
         - index: The playlist position (index)

     - Returns: Track if found, else `nil`.
    */
    func getTrackByCurrentPosition(playlist: Playlist, index: Int) -> Track?
    {
        if index >= 0 && index < playlist.storeIDs.count
        {
            let storeID = playlist.storeIDs[index]
            return getTrackByStoreID(playlist: playlist, storeID: storeID)
        }
        else
        {
            return nil
        }
    }

    /**
     Given a Playlist and Store ID, return the position (index) in the Playlist of the identified Track.

     - Parameters:
         - playlist: The Playlist to examine
         - storeID: Store ID of track

     - Returns: Position (index) of identified Track if found, else `nil`.
    */
    func getTrackIndexFor(playlist: Playlist, storeID: String) -> Int?
    {
        return playlist.storeIDs.firstIndex(of: storeID)
    }

    /**
     Retrieve the current playback index for a given playlist.

     - Parameter playlistID: Playlist (or tracklist) ID of interest.
     - Returns: Current playback index, or 0 if the ID is unrecognised.
    */
    func getCurrentPlaybackPositionFor(playlistID: String) -> Int
    {
        if let position = self.currentPositionsInPlaylistsByID[playlistID]
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
        let playlist        = self.playlistsByID[playlistID]!
        let currentPosition = self.currentPositionsInPlaylistsByID[playlistID]!

        currentPosition.currentIndex += 1

        if currentPosition.currentIndex >= playlist.storeIDs.count
        {
            currentPosition.currentIndex = 0
            bisectAndReshuffle(playlist: playlist)
        }

        appDelegate.saveContext()
        return Int(currentPosition.currentIndex)
    }

    // MARK: - PRIVATE

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
     rejoins them. This means that you don't risk having a song only just recently played near
     the end of the playlist, appearing near the very start of the new shuffle order; on the other
     hand, it does mean that the original first and last half of the list are always the first and
     last half (just with each in a new shuffle order).

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

        playlist.storeIDs = Array(sliceA) + Array(sliceB)
    }
}
