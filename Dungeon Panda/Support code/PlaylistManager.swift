//
//  PlaylistManager.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 22/03/21.
//

import Foundation
import CoreData
import UIKit
import MediaPlayer
import OSLog

/**
 A PlaylistManager keeps track of shuffled playback orders within Tracklists.
*/
class PlaylistManager {
    let logger      = Logger()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    let staticTracklistManager: StaticTracklistManager
    let persistentContainer:    NSPersistentContainer // NSPersistentCloudKitContainer

    var playlists:                       [Playlist]                         = [Playlist]()
    var playlistsByID:                   [String:Playlist]                  = [:]
    var currentPositionsInPlaylists:     [CurrentPositionInPlaylist]        = [CurrentPositionInPlaylist]()
    var currentPositionsInPlaylistsByID: [String:CurrentPositionInPlaylist] = [:]
    var currentPlaylist:                 CurrentPlaylist

    /**
     When created, a PlaylistManager fetches all static tracklists and for each:

     * Determines if it has a shuffle order defined for it yet and, if not, builds one
     * Determines the current index last recorded in that shuffle order

     iCloud-backed CoreData is used to retrieve and save the above data.

     - Parameters:
        - staticTracklistManager: StaticTracklistManager instance to be used as a source of all tracklist information
        - persistentContainer: NSPersistentCloudKitContainer or NSPersistentContainer to be used for CoreData operations
    */
    init(
        staticTracklistManager: StaticTracklistManager,
           persistentContainer: NSPersistentContainer // NSPersistentCloudKitContainer
    )
    {
        logger.notice("PlaylistManager init")

        self.staticTracklistManager = staticTracklistManager
        self.persistentContainer    = persistentContainer

        let context = self.persistentContainer.viewContext

        // Fetch all playlist records in Core Data locally now.
        //
        do
        {
            let records = try context.fetch(Playlist.fetchRequest())

            if !records.isEmpty
            {
                logger.notice("PlaylistManager init: Successfully fetched playlists from Core Data")
                self.playlists = records
            }
        }
        catch
        {
            logger.notice("PlaylistManager init: Unable to fetch playlists from Core Data; creating new")
        }

        // Fetch all play positions within the playlists.
        //
        do
        {
            let records = try context.fetch(CurrentPositionInPlaylist.fetchRequest())

            if !records.isEmpty
            {
                logger.notice("PlaylistManager init: Successfully fetched positions from Core Data")
                self.currentPositionsInPlaylists = records
            }
        }
        catch
        {
            logger.notice("PlaylistManager init: Unable to fetch positions from Core Data; creating new")
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
        // if not. Remember, Tracklist and Playlist IDs are interchangeable. We
        // handle out of date playlists here too.
        //
        for tracklist in staticTracklistManager.getTracklists()
        {
            // Handle out of date playlists.
            //
            if let playlist = self.playlistsByID[tracklist.id]
            {
                let sortedTracklistStoreIDs = tracklist.getStoreIDArray().sorted()
                let sortedPlaylistStoreIDs  = playlist.storeIDs.sorted()

                if playlist.version != tracklist.version ||
                   false == sortedPlaylistStoreIDs.elementsEqual(sortedTracklistStoreIDs)
                {
                    logger.notice("PlaylistManager init: Playlist \(tracklist.id) is out of date; updating")

                    playlist.displayName = tracklist.displayName
                    playlist.version     = tracklist.version
                    playlist.storeIDs    = PlaylistManager.shuffleStoreIDsWithin(tracklist: tracklist)

                    if let position = self.currentPositionsInPlaylistsByID[tracklist.id]
                    {
                        position.currentIndex        = 0
                        position.currentPlaybackTime = 0
                    }
                }
            }

            // Handle missing playlists.
            //
            else
            {
                let newPlaylist = Playlist(context: context)

                newPlaylist.id          = tracklist.id
                newPlaylist.displayName = tracklist.displayName
                newPlaylist.version     = tracklist.version
                newPlaylist.storeIDs    = PlaylistManager.shuffleStoreIDsWithin(tracklist: tracklist)

                self.playlists.append(newPlaylist)
                self.playlistsByID[tracklist.id] = newPlaylist
            }

            if self.currentPositionsInPlaylistsByID[tracklist.id] == nil
            {
                let newPosition = CurrentPositionInPlaylist(context: context)

                newPosition.playlistID          = tracklist.id
                newPosition.currentIndex        = 0
                newPosition.currentPlaybackTime = 0

                self.currentPositionsInPlaylists.append(newPosition)
                self.currentPositionsInPlaylistsByID[tracklist.id] = newPosition
            }
        }

        // Fetch the current playlist info, or create anew if necessary.
        //
        var currentPlaylistOptional: CurrentPlaylist?

        do
        {
            let records = try context.fetch(CurrentPlaylist.fetchRequest())

            if let firstRecord = records.first
            {
                logger.notice("PlaylistManager init: Successfully fetched current playlist from Core Data")
                currentPlaylistOptional = firstRecord
            }
        }
        catch
        {
            logger.notice("PlaylistManager init: Unable to current playlist from Core Data; creating new")
        }

        if currentPlaylistOptional == nil
        {
            currentPlaylistOptional             = CurrentPlaylist(context: context)
            currentPlaylistOptional!.playlistID = self.playlists.first!.id
        }

        self.currentPlaylist = currentPlaylistOptional!

        // Finally, save any changes made above.
        //
        appDelegate.saveContext()

        // Self-check before even bothering to start.
        //
        assert(self.playlists.count > 0)
        assert(self.playlistsByID.values.count > 0)
        assert(self.currentPositionsInPlaylists.count > 0)
        assert(self.currentPositionsInPlaylistsByID.values.count > 0)
    }

    // MARK: - CONVENIENCE ACCESSORS

    /**
     Find out about the currently playing, or most recently played music, according to Core Data.

     - Returns: Playlist, Track and index in that Track into the Playlist's Store IDs array.
    */
    func nowPlaying() -> (Playlist, Track, Int)
    {
        let currentPlaylistId = self.currentPlaylist.playlistID!
        let currentPlaylist   = getPlaylistForID(playlistID: currentPlaylistId)
        let currentIndex      = getCurrentPlaybackIndexFor(playlist: currentPlaylist)
        let currentTrack      = getTrackByIndex(playlist: currentPlaylist, index: currentIndex)

        return (currentPlaylist, currentTrack, currentIndex)
    }

    /**
     Return the current Playlist, according to Core Data.

     - Returns: Playlist.
    */
    func getPlayingPlaylist() -> Playlist
    {
        let (playlist, _, _) = nowPlaying()
        return playlist
    }

    /**
     Update the notion of the currently or most recently played playlist in Core Data.
    */
    func setPlayingPlayist(playlist: Playlist)
    {
        self.currentPlaylist.playlistID = playlist.id!
        appDelegate.saveContext()
    }

    /**
     Return the current Track being played in the current Playlist, according to Core Data.
     */
    func getPlayingTrack() -> Track
    {
        let (_, track, _) = nowPlaying()
        return track
    }

    /**
     Return the index in the currently playing Playlist's store ID array of the Track being played,
     according to Core Data.
     */
    func getPlayingTrackIndex() -> Int
    {
        let (_, _, index) = nowPlaying()
        return index
    }

    /**
     Return a media player queue descriptor for a given playlist, with the store IDs laid out in
     playlist order, the start item set according to that playlist's current playback index and
     start/end offsets configured for each track.

     - Parameter playlist: Playlist of interest
     - Returns: Media player queue descriptor, for use with e.g. "setQueue:with:".
    */
    func getQueueDescriptorFor(playlist: Playlist) -> MPMusicPlayerStoreQueueDescriptor
    {
        let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: playlist.storeIDs)
        let tracklist  = staticTracklistManager.getTracklistBy(tracklistID: playlist.id!)

        for storeID in playlist.storeIDs
        {
            let track = tracklist.getTrackBy(storeID: storeID)

            if track.startOffset != 0
            {
                descriptor.setStartTime(track.startOffset, forItemWithStoreID: storeID)
            }

            if track.endOffset != nil
            {
                descriptor.setEndTime(track.endOffset!, forItemWithStoreID: storeID)
            }
        }

        descriptor.startItemID = getTrackByIndex(
            playlist: playlist,
            index:    getCurrentPlaybackIndexFor(playlist: playlist)
        ).storeID

        return descriptor
    }

    /**
     Return a media player queue descriptor for a given Ttrack, with start/end offsets configured. The queue
     will be set up to include just the given Track and no others.

     - Parameter track: Track of interest
     - Returns: Media player queue descriptor, for use with e.g. "setQueue:with:".
     */
    func getQueueDescriptorFor(track: Track) -> MPMusicPlayerStoreQueueDescriptor
    {
        let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [track.storeID])

        if track.startOffset != 0
        {
            descriptor.setStartTime(track.startOffset, forItemWithStoreID: track.storeID)
        }

        // MusicPlaybackManager now does this manually via timers. The Apple
        // Music API is simply far too horribly broken to rely on the below.
        //
        //        if track.endOffset != nil
        //        {
        //            descriptor.setEndTime(track.endOffset!, forItemWithStoreID: track.storeID)
        //        }

        descriptor.startItemID = track.storeID

        return descriptor
    }

    // MARK: - GENERAL INTERFACE

    /**
     Return a Playlist stored for the given ID.

     - Parameter playlistID: ID of Playlist (or Tracklist).
     - Returns: Playlist object corresponding to ID or, to avoid crashes, a random Playlist if the ID is invalid.
     */
    func getPlaylistForID(playlistID: String) -> Playlist
    {
        if let playlist = self.playlistsByID[playlistID]
        {
            return playlist
        }
        else // ...wut, no playlist? Well, don't crash, at least...
        {
            logger.warning("WARNING: getPlaylistForID: ID \(playlistID) not found! Returning random playlist instead.")
            return self.playlists.randomElement()!
        }
    }

    /**
     Returns the Tracklist associated with the given Playlist, by relying on their interchangeable IDs.

     - Parameter playlist: Playlist for which associated Tracklist is to be returned.
     - Returns: Tracklist related to given Playlist.
    */
    func getTracklistForPlaylist(_ playlist: Playlist) -> Tracklist
    {
        return self.staticTracklistManager.getTracklistBy(tracklistID: playlist.id!)
    }

    /**
     Return a Track in a given Playlist based on a Store ID.

     - Parameters:
         - playlist: The Playlist to examine
         - storeID: Store ID of track

     - Returns: Track if found, else an arbitrary Track in the playlist to avoid crashes.
    */
    func getTrackByStoreID(playlist: Playlist, storeID: String) -> Track
    {
        let tracklist = getTracklistForPlaylist(playlist)
        return tracklist.getTrackBy(storeID: storeID)
    }

    /**
     Return a Track in a given Playlist based on playback index.

     - Parameters:
         - playlist: The Playlist to examine
         - index: The playlist position (index)

     - Returns: Track if found, else an arbitrary Track in the playlist to avoid crashes.

     If given an out of range index, assumes zero and returns the first Track in the Playlist.
    */
    func getTrackByIndex(playlist: Playlist, index: Int) -> Track
    {
        var safeIndex = index

        if index < 0 || index >= playlist.storeIDs.count
        {
            logger.warning("WARNING: getTrackByIndex: Index '\(index)' for playlist '\(String(describing: playlist.id))' is out of range; item count is \(playlist.storeIDs.count). Resetting to zero.")
            safeIndex = 0
        }

        let storeID = playlist.storeIDs[safeIndex]
        return getTrackByStoreID(playlist: playlist, storeID: storeID)
    }

    /**
     Given a Playlist and Store ID, return the position (index) in the Playlist of the identified Track.

     - Parameters:
         - playlist: The Playlist to examine
         - storeID: Store ID of track

     - Returns: Position (index) of identified Track if found, else just gives up and returns 0 to avoid crashes.
    */
    func getTrackIndexFor(playlist: Playlist, storeID: String) -> Int
    {
        if let index = playlist.storeIDs.firstIndex(of: storeID)
        {
            return index
        }
        else
        {
            logger.warning("WARNING: getTrackIndexFor: Store ID '\(storeID)' not found in playlist '\(String(describing: playlist.id))'. Returning zero instead.")
            return 0
        }
    }

    /**
     Retrieve the current playback index for a given playlist.

     - Parameter playlist: Playlist (or tracklist) of interest.
     - Returns: Current playback index, or 0 if the ID is unrecognised.
    */
    func getCurrentPlaybackIndexFor(playlist: Playlist?) -> Int
    {
        if playlist != nil,
           let position = self.currentPositionsInPlaylistsByID[playlist!.id!]
        {
            return Int(position.currentIndex)
        }
        else
        {
            logger.warning("WARNING: getCurrentPlaybackIndexFor: Playlist '\(String(describing: playlist?.id))' either missing or has no known current playback position. Returning zero instead.")
            return 0
        }
    }

    /**
     Set the current playback index for a given playlist, resetting the track playback time interval
     for that playlist.

     - Parameters:
         - playlist: Playlist (or tracklist) of interest.
         - index: Index to set as the currently playing track.
     */
    func setCurrentPlaybackIndexFor(playlist: Playlist, index: Int)
    {
        if let position = self.currentPositionsInPlaylistsByID[playlist.id!]
        {
            position.currentIndex        = Int32(index)
            position.currentPlaybackTime = 0

            appDelegate.saveContext()
        }
        else
        {
            logger.error("ERROR: setCurrentPlaybackIndexFor: Unable to retrieve a current playlist position; ignoring request.")
        }
    }

    /**
     Call when a media player monitoring class notices that a track has finished and to simultaneously be given
     the index of the next track to play in the playlist. This returned index is stored in CoreData as the new
     current playlist index for that playlist, so callers do not need to do that themselves and as a result, you
     may not need to use the returned index at all - `nowPlaying` will start returning the new track info
     straight away.

     - Parameter playlistID: ID of playlist in which playback completed.
     - Returns: Playlist index in that playlist of **next item to be played**.

     Internally, if the end of the playlist has been reached, it is reshuffled and the returned index
     will be zero. Everything is persisted synchronously to Core Data.
    */
    @discardableResult func currentItemHasBeenPlayedWithin(playlistID: String) -> Int
    {
        logger.debug("currentItemHasBeenPlayedWithin: Called for playlist '\(playlistID)'")

        let playingPlaylist = self.playlistsByID[playlistID]!
        let justPlayedIndex = getCurrentPlaybackIndexFor(playlist: playingPlaylist)
        var nextIndexToPlay = justPlayedIndex + 1

        if nextIndexToPlay >= playingPlaylist.storeIDs.count
        {
            logger.notice("currentItemHasBeenPlayedWithin: All items in this playlist have been played - shuffling")

            nextIndexToPlay = 0
            bisectAndReshuffle(playlist: playingPlaylist)
            appDelegate.saveContext()
        }

        logger.debug("currentItemHasBeenPlayedWithin: Next playback index is \(nextIndexToPlay)")

        setCurrentPlaybackIndexFor(playlist: playingPlaylist, index: nextIndexToPlay)

        return Int(nextIndexToPlay)
    }

    // MARK: - PRIVATE

    /**
     Takes all Store IDs of Tracks in a given Tracklist and shuffles them into a random order, returning an
     Array of the shuffled Store ID Strings. **Class method** (so that it can be called from `init`
     without XCode complaining that code is referencing `self` before all properties are initialised).

     - Parameter tracklist: Tracklist to examine.
     - Returns: Shuffled order Array of Store IDs.
    */
    private class func shuffleStoreIDsWithin(tracklist: Tracklist) -> [String]
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
