//
//  StaticTracklistManager.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 22/03/21.
//

import Foundation
import UIKit

/**
 A statically initialised ("canned") set of Tracklists, designed for various tabletop gaming moods.
 */
class StaticTracklistManager
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var tracklists: [String:Tracklist] = [:]

    init()
    {
        var tracklist: Tracklist

        // Good: Background
        //
        tracklist = add(id: "good-background", displayName: "Good - Backround")

        tracklist.add(Track(storeID: "896588775",      displayName: "It's Not A Dream",          startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))
        tracklist.add(Track(storeID: "896588704",      displayName: "Marnie",                    startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))
        tracklist.add(Track(storeID: "i.NdlWQUPOgkpK", displayName: "Floating With The Crystal", startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))

        // Good: Tavern
        //
        tracklist = add(id: "good-tavern", displayName: "Good - Tavern")
        tracklist.add(Track(storeID: "896588781", displayName: "Kazuhiko and Marnie Dance", startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))
        tracklist.add(Track(storeID: "885304419", displayName: "The Party",                 startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))
        tracklist.add(Track(storeID: "883013089", displayName: "Addio!",                    startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))

        // Good: Quirky
        //
        tracklist = add(id: "good-quirky", displayName: "Good - Quirky")
        tracklist.add(Track(storeID: "669578598",  displayName: "Drippy",                  startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))
        tracklist.add(Track(storeID: "885304414",  displayName: "The Latin Quarter",       startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))
        tracklist.add(Track(storeID: "1263826302", displayName: "To The Land Of Faraway…", startOffset: 0, endOffset: 0, fadeIn: true, fadeOut: true))

        // Good: Victory
        //
        tracklist = add(id: "good-victory", displayName: "Good - Victory")
        tracklist.add(Track(storeID: "i.Ndl70SPOgkpK", displayName: "The Eternal Tree Of Life", startOffset: 0, endOffset: 0, fadeIn: false, fadeOut: true))
        tracklist.add(Track(storeID: "669578601",      displayName: "World Map",                startOffset: 0, endOffset: 0, fadeIn: false, fadeOut: true))
        tracklist.add(Track(storeID: "883013108",      displayName: "Porco e Bella - Ending",   startOffset: 0, endOffset: 0, fadeIn: false, fadeOut: true))
    }

    /**
     Retrieve an Array of all Tracklists

     -Returns: Array of Tracklists.
    */
    func getTracklists() -> [Tracklist]
    {
        return Array(tracklists.values)
    }

    /**
     Retrieve a Tracklist by ID.

     - Parameter tracklistID: Tracklist ID to retrieve.
     - Returns: Optional Tracklist - `nil` if ID is unknown.
    */
    func getTracklistBy(tracklistID: String) -> Tracklist?
    {
        return tracklists[tracklistID]
    }

    /**
     Add a given Tracklist, returning the same instance given. If a Tracklist with the same ID has
     already been added, it will be overwritten.

     - Parameter tracklist: Tracklist to add; its ID must be set
     - Returns: Tracklist instance that was just added
    */
    func add(_ tracklist: Tracklist) -> Tracklist
    {
        tracklists[tracklist.id] = tracklist
        return tracklist
    }

    /**
     Construct and add a new Tracklist, returning the new instance.

     - Parameter id: Tracklist ID
     - Parameter displayName: Human-facing Tracklist name
     - Returns: New Tracklist instance
    */
    func add(id: String, displayName: String) -> Tracklist
    {
        return add(Tracklist(id: id, displayName: displayName, tracks: []))
    }
}
