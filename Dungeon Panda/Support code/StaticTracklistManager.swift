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
        addGoodBackground()
        addGoodTavern()
        addGoodQuirky()
        addGoodVictory()

        addEvilBackground()
        addEvilBattle()
        addEvilTwisted()
        addEvilFailure()

        addAnyMagicAndMystery()
        addAnyHurry()
        addAnySorrow()
    }

    /**
     Retrieve an Array of all Tracklists

     - Returns: Array of Tracklists.
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
        assert(tracklists[tracklist.id] == nil, "Tracklist ID \(tracklist.id) has already been defined")
        tracklists[tracklist.id] = tracklist
        return tracklist
    }

    /**
     Construct and add a new Tracklist, returning the new instance.

     - Parameters:
        - id: Tracklist ID to add (interchangeable with Playlist IDs)
        - displayName: Human-facing Tracklist name
        - version: Version number
        - volumePercent: Percentage of volume to use relative to system reference level for all tracks
        - autoSwitchAfter: Optional playlist name, switched to automatically after one track plays to completion

     - Returns: New Tracklist instance
    */
    func add(
        id:              String,
        displayName:     String,
        version:         Int32,
        volumePercent:   Int32 = 100,
        autoSwitchAfter: String? = nil
    ) -> Tracklist
    {
        return add(Tracklist(id: id,
                    displayName: displayName,
                        version: version,
                  volumePercent: volumePercent,
                autoSwitchAfter: autoSwitchAfter,
                         tracks: []))
    }

    // MARK: - PRIVATE

    // =========================================================================
    // Evil - Background
    // =========================================================================
    //
    /// Add the `Evil - Background` static Tracklist.
    ///
    private func addEvilBackground()
    {
        let tracklist = self.add(id: "evil-background",
                        displayName: "Evil - Background",
                            version: 1,
                      volumePercent: 90,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "883501060",
                        displayName: "The Forest Of The Gods",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "948526708",
                        displayName: "Cosmos",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667051",
                        displayName: "Despair",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667080",
                        displayName: "Sorrow",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578518",
                        displayName: "The Accident",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638391",
                        displayName: "Shohmyoh",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 366,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440854740",
                        displayName: "The Alien Planet",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854774",
                        displayName: "The Shaft",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 184,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1443785890",
                        displayName: "Lento",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443785953",
                        displayName: "Candles In The Wind",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 166,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1082810990",
                        displayName: "Sub-Level 3",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 350,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1082810544",
                        displayName: "Atmosphere Station",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1082810533",
                        displayName: "Dark Discovery; Newt's Horror",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 108,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1082811821",
                        displayName: "The Queen",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378586",
                        displayName: "The Core",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378587",
                        displayName: "Dying World",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "362214274",
                        displayName: "Macrotus",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966284",
                        displayName: "Repentant",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966635",
                        displayName: "Apostate",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057014",
                        displayName: "Wallace",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "767230846",
                        displayName: "Sideral Universe",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1521641819",
                        displayName: "Borderlines",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536478364",
                        displayName: "Rose Of Victory",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1114649405",
                        displayName: "Anubis",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 180,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "380350146",
                        displayName: "Old Souls",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 346,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1309689770",
                        displayName: "Le Bouclier Fumant",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578680",
                        displayName: "The Horror Of Manna",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578682",
                        displayName: "Unrest",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721204",
                        displayName: "A Sentient Being",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "5554157",
                        displayName: "Hi Energy Proton Accelerator",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "726982844",
                        displayName: "Khan's Pets",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543396033",
                        displayName: "The Bluetide Computers",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825567",
                        displayName: "Encom, Part I",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "293897542",
                        displayName: "Lux Aeterna",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "43453375",
                        displayName: "Atmosphères For Orchestra",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 9,
                          endOffset: 8,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "724653382",
                        displayName: "Wind In Lonely Fences",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "693622051",
                        displayName: "Under Stars",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861210",
                        displayName: "Matta",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861334",
                        displayName: "Stars",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "684270302",
                        displayName: "Lanzarote",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "684270307",
                        displayName: "Ikebukuro",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714928031",
                        displayName: "Flowered Knife Shadows",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724207302",
                        displayName: "Monkey King",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862378",
                        displayName: "The Beastmaster 3",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149471",
                        displayName: "Hunting Dogs",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069205",
                        displayName: "Haunted Mansion Ambience",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Evil - Battle
    // =========================================================================
    //
    /// Add the `Evil - Battle` static Tracklist.
    ///
    private func addEvilBattle()
    {
        let tracklist = self.add(id: "evil-battle",
                        displayName: "Evil - Battle",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "785256921",
                        displayName: "The Refuge",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578826",
                        displayName: "The Wrath Of The White Witch",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578610",
                        displayName: "Imperial March",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501080",
                        displayName: "The Demon Power II",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501079",
                        displayName: "The Battle In Front Of The Ironworks",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802253",
                        displayName: "Battle",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501065",
                        displayName: "The Furies",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501084",
                        displayName: "The Demon God III",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854721",
                        displayName: "Breakaway",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 92,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440854732",
                        displayName: "The Droid",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 174,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1082811125",
                        displayName: "Futile Escape",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 185,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "62101114",
                        displayName: "Going After Newt",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1082811122",
                        displayName: "Ripley's Rescue",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848400",
                        displayName: "Malmori Rear Guard",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 38,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848402",
                        displayName: "Cowboy And The Jackers",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 25,
                          endOffset: 192,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "588848407",
                        displayName: "The Battle Begins",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848789",
                        displayName: "The Maze Battle",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848801",
                        displayName: "Shad's Pursuit",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1444138318",
                        displayName: "Cylon Attack / The End Of Atlantia",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 120,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "733966446",
                        displayName: "Dreadful",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291058471",
                        displayName: "Sea Wall",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 550,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1205025769",
                        displayName: "The Great Conjunction",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "7593378",
                        displayName: "First Attack",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "7593396",
                        displayName: "Big Battle",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069177",
                        displayName: "Abadis Forest",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069179",
                        displayName: "No Rest For The Wicked",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069184",
                        displayName: "Everdawn Basin",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472276447",
                        displayName: "Heat Her Up",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472276656",
                        displayName: "We Have To Kill It",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1455420272",
                        displayName: "Sky Battle",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263825789",
                        displayName: "Battle",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802373",
                        displayName: "The Battle Between Mehve And Corvette",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578819",
                        displayName: "The Final Battle Against The White Witch",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501053",
                        displayName: "The Demon God",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501743",
                        displayName: "Yubaba's Panic",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "62795351",
                        displayName: "Out Of Control; The Crash",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "62795526",
                        displayName: "The Final Fight",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "726982841",
                        displayName: "Surprise Attack",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 272,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "726982851",
                        displayName: "Battle In The Mutara Nebula",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 473,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883507127",
                        displayName: "Cataclysm - Dragon",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "403427669",
                        displayName: "Recognizer",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825344",
                        displayName: "Disc Wars",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545861909",
                        displayName: "The Horde",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854728",
                        displayName: "The Landing",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 92,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638391",
                        displayName: "Shohmyoh",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 368,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025549",
                        displayName: "The Power Ceremony",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069188",
                        displayName: "Let's End This",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Evil - Failure
    // =========================================================================
    //
    /// Add the `Evil - Failure` static Tracklist.
    ///
    private func addEvilFailure()
    {
        let tracklist = self.add(id: "evil-failure",
                        displayName: "Evil - Failure",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: "evil-background")

        tracklist.add(Track(storeID: "1443785957",
                        displayName: "Adagio",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 48,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149469",
                        displayName: "Prelude",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 26,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149505",
                        displayName: "Lost In The Storm",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501071",
                        displayName: "Princess Mononoke",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Evil - Twisted
    // =========================================================================
    //
    /// Add the `Evil - Twisted` static Tracklist.
    ///
    private func addEvilTwisted()
    {
        let tracklist = self.add(id: "evil-twisted",
                        displayName: "Evil - Twisted",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "evil-battle")

        tracklist.add(Track(storeID: "1497638387",
                        displayName: "Battle Against Clown",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638390",
                        displayName: "Dolls' Polyphony",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638392",
                        displayName: "Mutation",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1109391374",
                        displayName: "Rotating Room",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309689777",
                        displayName: "Les Olmèques",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802374",
                        displayName: "The Resurrection Of The Giant Warrior",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 64,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501086",
                        displayName: "The World Of The Dead",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1444085653",
                        displayName: "Rain Forest",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553910185",
                        displayName: "Alternative 3",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862379",
                        displayName: "The Beastmaster 4",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 37,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1291057994",
                        displayName: "Pilot",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 122,
                             fadeIn: false,
                            fadeOut: true))
    }

    // =========================================================================
    // Good - Background
    // =========================================================================
    //
    /// Add the `Good - Background` static Tracklist.
    ///
    private func addGoodBackground()
    {
        let tracklist = self.add(id: "good-background",
                        displayName: "Good - Background",
                            version: 1,
                      volumePercent: 90,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "882407917",
                        displayName: "Morning In The Slag Ravine",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "882407916",
                        displayName: "The Girl Who Fell From The Sky",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588775",
                        displayName: "\"It's Not A Dream\"",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588704",
                        displayName: "Marnie",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588797",
                        displayName: "Hisako's Story 1",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263828849",
                        displayName: "Gondoa",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588679",
                        displayName: "High Tide, Low Tide",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304426",
                        displayName: "Looking Back",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501267",
                        displayName: "Ashitaka And San",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013095",
                        displayName: "Porco E Bella",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501066",
                        displayName: "The Young Man From The East",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667022",
                        displayName: "The Sprout",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378582",
                        displayName: "Antichamber Suite I",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 330,
                          endOffset: 670,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378583",
                        displayName: "Antichamber Suite II",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 360,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "362214366",
                        displayName: "Lasiurus",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 385,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "570069182",
                        displayName: "The Blackmoor Mountains",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069192",
                        displayName: "Gone Home",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536478369",
                        displayName: "I Saw Your Ship",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883513473",
                        displayName: "Wandering Sophie",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "73157174",
                        displayName: "A Game Of Intrigue",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 22,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263825788",
                        displayName: "The Legend Of The Wind",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263826308",
                        displayName: "The Road To The Valley",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578514",
                        displayName: "One Fine Morning",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "420781698",
                        displayName: "Falling Lights",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "420781685",
                        displayName: "Another Verdant World",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501054",
                        displayName: "The Journey To The West",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507130",
                        displayName: "A Journey",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507137",
                        displayName: "Men Of The Earth",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553909945",
                        displayName: "From The Same Hill",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724653244",
                        displayName: "First Light",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724653305",
                        displayName: "An Arc Of Doves",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861231",
                        displayName: "Drift",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477532180",
                        displayName: "Wind On Water",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1479093109",
                        displayName: "Bringing Down The Light",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862076",
                        displayName: "Night Journey",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Good - Quirky
    // =========================================================================
    //
    /// Add the `Good - Quirky` static Tracklist.
    ///
    private func addGoodQuirky()
    {
        let tracklist = self.add(id: "good-quirky",
                        displayName: "Good - Quirky",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: "good-background")

        tracklist.add(Track(storeID: "669578598",
                        displayName: "Drippy",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304414",
                        displayName: "The Latin Quarter",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 16,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013097",
                        displayName: "Women Of Piccolo",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013089",
                        displayName: "Addio!",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "948526759",
                        displayName: "Walkin'",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "433212255",
                        displayName: "Jade",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578676",
                        displayName: "Mummy's Tummy",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457542869",
                        displayName: "Oh No!",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Good - Tavern
    // =========================================================================
    //
    /// Add the `Good - Tavern` static Tracklist.
    ///
    private func addGoodTavern()
    {
        let tracklist = self.add(id: "good-tavern",
                        displayName: "Good - Tavern",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: "good-background")

        tracklist.add(Track(storeID: "896588781",
                        displayName: "Kazuhiko And Marnie Dance",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304419",
                        displayName: "The Party",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667085",
                        displayName: "The Procession Of Celestial Beings I",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025764",
                        displayName: "The Pod Dance",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688781",
                        displayName: "Les Incas",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263826307",
                        displayName: "The Distant Days",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013090",
                        displayName: "Bygone Days",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507141",
                        displayName: "Memories - The Storekeeper’s Advice",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 24,
                          endOffset: 98,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1451973356",
                        displayName: "Merry Go Round Of Life",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Good - Victory
    // =========================================================================
    //
    /// Add the `Good - Victory` static Tracklist.
    ///
    private func addGoodVictory()
    {
        let tracklist = self.add(id: "good-victory",
                        displayName: "Good - Victory",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: "any-magic-and-mystery")

        tracklist.add(Track(storeID: "669578601",
                        displayName: "World Map",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 200,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883013108",
                        displayName: "Porco E Bella - Ending",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578672",
                        displayName: "Ni No Kuni - Wrath Of The White Witch",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 78,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1205025548",
                        displayName: "The Dark Crystal Overture",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "403427791",
                        displayName: "Flynn Lives",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688431",
                        displayName: "L'Aventure D'Esteban",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862130",
                        displayName: "A Hero's Theme",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "882407938",
                        displayName: "Laputa, Castle In The Sky",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 175,
                             fadeIn: false,
                            fadeOut: true))
    }

    // =========================================================================
    // Any - Hurry!
    // =========================================================================
    //
    /// Add the `Any - Hurry!` static Tracklist.
    ///
    private func addAnyHurry()
    {
        let tracklist = self.add(id: "any-hurry",
                        displayName: "Any - Hurry!",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: "good-background")

        tracklist.add(Track(storeID: "669578515",
                        displayName: "Motorville",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "785256928",
                        displayName: "The Falcon",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 75,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "885295067",
                        displayName: "Ponyo's Sisters Lend A Hand",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 94,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "885295045",
                        displayName: "Ponyo’s Sisters",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1082810538",
                        displayName: "Combat Drop",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 200,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "400623307",
                        displayName: "I Am The Doctor",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "403427803",
                        displayName: "Outlands, Part II",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Any - Magic & Mystery
    // =========================================================================
    //
    /// Add the `Any - Magic & Mystery` static Tracklist.
    ///
    private func addAnyMagicAndMystery()
    {
        let tracklist = self.add(id: "any-magic-and-mystery",
                        displayName: "Any - Magic & Mystery",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "883501063",
                        displayName: "Lady Eboshi",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501070",
                        displayName: "San And Ashitaka In The Forest Of The Deer God",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501203",
                        displayName: "Adagio Of Life And Death II",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 43,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "896588774",
                        displayName: "When I Held A Doll",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295054",
                        displayName: "Gran Mamare",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 58,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "895667081",
                        displayName: "Fate",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638388",
                        displayName: "Winds Over Neo-Tokyo",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 152,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440854728",
                        displayName: "The Landing",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 93,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378579",
                        displayName: "Beginnings I",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378581",
                        displayName: "Beginnings II",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378588",
                        displayName: "The Garden",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966210",
                        displayName: "The Binding Of Isaac",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "73327386",
                        displayName: "Tales Of The Future",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "73327388",
                        displayName: "Damask Rose",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057018",
                        displayName: "Mesa",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 95,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1062368475",
                        displayName: "Always",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "7593417",
                        displayName: "Prophecy Theme",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069183",
                        displayName: "Twin Souls",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533984915",
                        displayName: "S.T.A.Y.",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 30,
                          endOffset: 360,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1309688415",
                        displayName: "Le Vol Du Condor",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688773",
                        displayName: "En Navigant",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309689433",
                        displayName: "Le Passage Secret",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802370",
                        displayName: "In The Sea Of Corruption",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721194",
                        displayName: "The Pursuit",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721318",
                        displayName: "Revelation",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149474",
                        displayName: "Stalactite Gallery",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501060",
                        displayName: "The Forest Of The Gods",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "5554140",
                        displayName: "Is This What Everybody Wants",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "348595878",
                        displayName: "The Shape Of Things To Come",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443890585",
                        displayName: "Love Theme",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 86,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "403427785",
                        displayName: "Solar Sailer",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553910464",
                        displayName: "Events In Dense Fog",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553910712",
                        displayName: "Final Sunset",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1294875200",
                        displayName: "An Ending",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 83,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714899532",
                        displayName: "Voices",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "367363592",
                        displayName: "Sacred Stones",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1451903521",
                        displayName: "The Healing Place",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714416741",
                        displayName: "Meditation No. 2",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724437413",
                        displayName: "A Clearing",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025770",
                        displayName: "Finale",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 119,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "220242371",
                        displayName: "Ask The Mountains",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 131,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1521641808",
                        displayName: "...But Still We Go On",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Any - Sorrow
    // =========================================================================
    //
    /// Add the `Any - Sorrow` static Tracklist.
    ///
    private func addAnySorrow()
    {
        let tracklist = self.add(id: "any-sorrow",
                        displayName: "Any - Sorrow",
                            version: 1,
                      volumePercent: 100,
                    autoSwitchAfter: nil)
//
//        tracklist.add(Track(storeID: "895667086",
//                        displayName: "The Parting",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "785256920",
//                        displayName: "Nahoko",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "885304412",
//                        displayName: "Reminiscence",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "895667055",
//                        displayName: "Memories Of The Village",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "895667080",
//                        displayName: "Sorrow",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "588848790",
//                        displayName: "Gelt's Death",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "73327359",
//                        displayName: "Memories Of Green",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "1472276636",
//                        displayName: "Milowda",
//                     altDisplayName: nil,
//                      volumePercent: 80,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "881802374",
//                        displayName: "The Resurrection Of The Giant Warrior",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: 64,
//                             fadeIn: false,
//                            fadeOut: true))
//
//        tracklist.add(Track(storeID: "895667123",
//                        displayName: "Moon",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: 104,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "403427801",
//                        displayName: "Father And Son",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "403846004",
//                        displayName: "Adagio For Tron",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "714899528",
//                        displayName: "A Paler Sky",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))
//
//        tracklist.add(Track(storeID: "978344399",
//                        displayName: "The Appearance Of Colour",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: 420,
//                             fadeIn: false,
//                            fadeOut: true))
//
//        tracklist.add(Track(storeID: "1205025765",
//                        displayName: "Love Theme",
//                     altDisplayName: nil,
//                      volumePercent: 100,
//                        startOffset: 0,
//                          endOffset: nil,
//                             fadeIn: false,
//                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057991",
                        displayName: "Someone Lived This",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: 170,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "896588789",
                        displayName: "\"It's Like We Traded Places\"",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }
}
