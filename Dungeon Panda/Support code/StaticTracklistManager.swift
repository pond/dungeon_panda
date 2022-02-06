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
     - Returns: Tracklist - defaults to random track if ID is unrecognised, to avoid crashes.
    */
    func getTracklistBy(tracklistID: String) -> Tracklist
    {
        if let tracklist = tracklists[tracklistID]
        {
            return tracklist
        }
        else // ...wut, no tracklist? Well, don't crash, at least...
        {
            return tracklists.values.randomElement()!
        }
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
                            version: 2,
                      volumePercent: 90,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "883501060",
                        displayName: "The Forest Of The Gods",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "948526708",
                        displayName: "Cosmos",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667051",
                        displayName: "Despair",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667080",
                        displayName: "Sorrow",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578518",
                        displayName: "The Accident",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638391",
                        displayName: "Shohmyoh",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: 366,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440854740",
                        displayName: "The Alien Planet",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854774",
                        displayName: "The Shaft",
                     altDisplayName: nil,
                      volumePercent: 120,
                        startOffset: 0,
                          endOffset: 184,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1443785890",
                        displayName: "Lento",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443785953",
                        displayName: "Candles In The Wind",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: 115,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440718719",
                        displayName: "Sub-Level 3",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: 350,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440718710",
                        displayName: "Atmosphere Station",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718555",
                        displayName: "Dark Discovery/Newt's Horror",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: 108,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440718959",
                        displayName: "The Queen",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378586",
                        displayName: "The Core",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: 430,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378587",
                        displayName: "Dying World",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "362214274",
                        displayName: "Macrotus",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966284",
                        displayName: "Repentant",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966635",
                        displayName: "Apostate",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057014",
                        displayName: "Wallace",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "767230846",
                        displayName: "Sideral Universe",
                     altDisplayName: nil,
                      volumePercent: 70,
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
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1114649405",
                        displayName: "Anubis",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: 180,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "380350146",
                        displayName: "Old Souls",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: 346,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1309689770",
                        displayName: "Le Bouclier Fumant",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578680",
                        displayName: "The Horror Of Manna",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578682",
                        displayName: "Unrest",
                     altDisplayName: nil,
                      volumePercent: 107,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721204",
                        displayName: "A Sentient Being",
                     altDisplayName: nil,
                      volumePercent: 117,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1509086631",
                        displayName: "Hi Energy Proton Accelerator",
                     altDisplayName: nil,
                      volumePercent: 113,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "726982844",
                        displayName: "Khan's Pets",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543396033",
                        displayName: "The Bluetide Computers",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825567",
                        displayName: "Encom, Part I",
                     altDisplayName: nil,
                      volumePercent: 125,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "293897542",
                        displayName: "Lux Aeterna",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "43453375",
                        displayName: "Atmosphères For Orchestra",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 9,
                          endOffset: 500,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "724653382",
                        displayName: "Wind In Lonely Fences",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861195",
                        displayName: "Under Stars",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861210",
                        displayName: "Matta",
                     altDisplayName: nil,
                      volumePercent: 117,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861334",
                        displayName: "Stars",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "684270302",
                        displayName: "Lanzarote",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "684270307",
                        displayName: "Ikebukuro",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714928031",
                        displayName: "Flowered Knife Shadows",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724207302",
                        displayName: "The Monkey King",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862378",
                        displayName: "The Beastmaster 3",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149471",
                        displayName: "Hunting Dogs",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069205",
                        displayName: "Haunted Mansion Ambience",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1473582115",
                        displayName: "Riddle And Shadow",
                     altDisplayName: nil,
                      volumePercent: 129,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596952762",
                        displayName: "Death In The Darkness",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006041",
                        displayName: "Midnight In Shadow Cleft",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006070",
                        displayName: "Hope Just Out Of Reach",
                     altDisplayName: nil,
                      volumePercent: 113,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006185",
                        displayName: "Port Of Thieves",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006187",
                        displayName: "Tonal Architecture",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847631942",
                        displayName: "Rubble And Smoke",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675285651",
                        displayName: "Drowning Jethro",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: 123,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1544458100",
                        displayName: "Rite Of Passage",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1544458104",
                        displayName: "The Sacred And The Profane",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445723925",
                        displayName: "Forbidden Forest",
                     altDisplayName: nil,
                      volumePercent: 115,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1400508359",
                        displayName: "In The Jungle",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031930",
                        displayName: "Through The Underworld",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514764",
                        displayName: "Champions Of The Just",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "477786801",
                        displayName: "Cappadocia",
                     altDisplayName: nil,
                      volumePercent: 106,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1594447005",
                        displayName: "Dead Kings And Living Gods",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203007",
                        displayName: "Frozen Lands",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203277",
                        displayName: "Animus Anomaly",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440654730",
                        displayName: "Dead Men Tell No Tales",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004737",
                        displayName: "Brackenbury",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "337151241",
                        displayName: "Hideout",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "337151246",
                        displayName: "The Animus 2.0",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: 252,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1597811111",
                        displayName: "Moonlight Tension",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370193588",
                        displayName: "Helheim",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507152",
                        displayName: "Abduction - The Lure Of Eternal Life",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 75,
                          endOffset: 192,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1569689287",
                        displayName: "The Ocean Bog",
                     altDisplayName: nil,
                      volumePercent: 128,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596953302",
                        displayName: "Shattered Shields",
                     altDisplayName: nil,
                      volumePercent: 138,
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "883501053",
                        displayName: "The Demon God",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501065",
                        displayName: "The Furies",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501080",
                        displayName: "The Demon Power II",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501084",
                        displayName: "The Demon God III",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "372939377",
                        displayName: "World Of The Dead",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: 244,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883501743",
                        displayName: "Yubaba's Panic",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "726982851",
                        displayName: "Battle In The Mutara Nebula",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: 473,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "726982841",
                        displayName: "Surprise Attack",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: 272,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "726982843",
                        displayName: "Kirk's Explosive Reply",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718569",
                        displayName: "Combat Drop",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718931",
                        displayName: "Ripley's Rescue",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718939",
                        displayName: "Futile Escape",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 185,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718954",
                        displayName: "Going After Newt",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854721",
                        displayName: "Breakaway",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: 92,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440854728",
                        displayName: "The Landing",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 92,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854732",
                        displayName: "The Droid",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: 174,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "588848400",
                        displayName: "Malmori Rear Guard",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 38,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848402",
                        displayName: "Cowboy And The Jackers",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 25,
                          endOffset: 192,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "588848407",
                        displayName: "The Battle Begins",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848789",
                        displayName: "The Maze Battle",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848801",
                        displayName: "Shad's Pursuit",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848802",
                        displayName: "Destruction Of Hammerhead",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1444138318",
                        displayName: "Cylon Attack / The End Of Atlantia",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: 120,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883507127",
                        displayName: "Cataclysm - Dragon",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885285641",
                        displayName: "Spanish Dragon",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 20,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802253",
                        displayName: "Battle",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802373",
                        displayName: "The Battle Between Mehve And Corvette",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443090240",
                        displayName: "The Dragon's Lair",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: 161,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440494300",
                        displayName: "First Attack",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440494456",
                        displayName: "Big Battle",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "62795351",
                        displayName: "Out Of Control / The Crash",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "62795526",
                        displayName: "The Final Fight",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966446",
                        displayName: "Dreadful",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825328",
                        displayName: "Recognizer",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825344",
                        displayName: "Disc Wars",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825333",
                        displayName: "Outlands",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545861909",
                        displayName: "The Horde",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862120",
                        displayName: "The Battle On The Pyramid",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1455420272",
                        displayName: "Sky Battle",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481510276",
                        displayName: "To Kill An Ogre",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "971057963",
                        displayName: "The Cursed Army",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578610",
                        displayName: "Imperial March",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578819",
                        displayName: "The Final Battle Against The White Witch",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578826",
                        displayName: "The Wrath Of The White Witch",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069177",
                        displayName: "Abadis Forest",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069179",
                        displayName: "No Rest For The Wicked",
                     altDisplayName: nil,
                      volumePercent: 88,
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

        tracklist.add(Track(storeID: "570069188",
                        displayName: "Let's End This",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443798610",
                        displayName: "The Whaler",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291058471",
                        displayName: "Sea Wall",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: 550,
                             fadeIn: false,
                            fadeOut: true))

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
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025549",
                        displayName: "The Power Ceremony",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025769",
                        displayName: "The Great Conjunction",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502471",
                        displayName: "Commanding The Fury",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502475",
                        displayName: "Silver For Monsters...",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502496",
                        displayName: "The Hunt Is Coming",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502544",
                        displayName: "On Thin Ice",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502551",
                        displayName: "Conjunction Of The Spheres",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031925",
                        displayName: "Arena Of Rage",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031937",
                        displayName: "The Path Of A Kingslayer",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031946",
                        displayName: "Howl Of The White Wolf",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054092",
                        displayName: "Last Battle",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054211",
                        displayName: "To Arms",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "472750763",
                        displayName: "Prologue / Anvil Of Grom",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 59,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "472750764",
                        displayName: "Riddle Of Steel / Riders Of Doom",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 95,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "472750933",
                        displayName: "Battle Of The Mounds, Part 1",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442463007",
                        displayName: "Elite Guard Attacks",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442463415",
                        displayName: "Conan & Bombaata Battle",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847627867",
                        displayName: "For Blood, For Glory, For Honor",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847633931",
                        displayName: "Onslaught At The Gates",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951645",
                        displayName: "Death Or Sovngarde",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: 166,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1326005909",
                        displayName: "Blood In The Foyada",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006172",
                        displayName: "All History Is Vengeance",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006186",
                        displayName: "Granite And Ashes",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237797",
                        displayName: "From Abysses Below And Beyond",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299350",
                        displayName: "Knight's Charge",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299558",
                        displayName: "Stormclouds On The Battlefield",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1369922178",
                        displayName: "Weathertop",
                     altDisplayName: nil,
                      volumePercent: 113,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876758",
                        displayName: "Helen Frees The Mariner",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876897",
                        displayName: "Deacon's Speech",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442845605",
                        displayName: "Durant Is Dead",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482699247",
                        displayName: "I've Made My Choice, You'll Have To Make Yours",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482699249",
                        displayName: "Protecting Our Kind",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283561",
                        displayName: "Buffalo Run",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283730",
                        displayName: "Hunting The Buffalo",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284164",
                        displayName: "Crossing The River",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445723924",
                        displayName: "Riches And Glory",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445188306",
                        displayName: "Retribution",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1544457962",
                        displayName: "V",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443203652",
                        displayName: "The Towering Inferno: Main Title",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1385167998",
                        displayName: "Marauders Arrive",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1385167994",
                        displayName: "Corellia Chase",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "270186240",
                        displayName: "A Desperate Run Through The Tunnels",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 59,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500835983",
                        displayName: "The Frozen Lake",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 93,
                          endOffset: 217,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1547584108",
                        displayName: "Highlanders Waltz",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1547584867",
                        displayName: "Fight With Fear!",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514846",
                        displayName: "The Lie In Which You Linger",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514849",
                        displayName: "Let The Skies Boil",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671744",
                        displayName: "Trespasser - Dark Solas Theme",
                     altDisplayName: nil,
                      volumePercent: 114,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671867",
                        displayName: "Trespasser - Qunari Mission",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671868",
                        displayName: "Trespasser - Qunari Battle",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671741",
                        displayName: "Descent - Titan",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189843",
                        displayName: "Caelestinum Finale Termini",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519190020",
                        displayName: "Rite Of Battle",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568208",
                        displayName: "Rapid As Wildfires",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568213",
                        displayName: "Chasing The Torrents",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568478",
                        displayName: "Gallant Challenge",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535610188",
                        displayName: "His Resolution",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535610207",
                        displayName: "Charge! Fearless Warriors",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535611501",
                        displayName: "Symphony Of Boreal Wind",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576318746",
                        displayName: "Wrath Of Monoceros Caeli",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576318753",
                        displayName: "Dance With The Great Vortex",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576318767",
                        displayName: "Rage Beneath The Mountains",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636299",
                        displayName: "Against The Invisible Net",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636316",
                        displayName: "Fiery Pursuit",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "298704454",
                        displayName: "Saw Bitch Workhorse",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1485424741",
                        displayName: "Flower Of Fingers",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481496322",
                        displayName: "Surkesh",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481496325",
                        displayName: "I'm Sorry",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481496331",
                        displayName: "Reaper Chase",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1522592692",
                        displayName: "Chase",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1522592696",
                        displayName: "One Way In",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1593860115",
                        displayName: "DeMolay's Condemnation",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "477786787",
                        displayName: "Forum Of Ox",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "571303212",
                        displayName: "Through The Frontier",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "571303215",
                        displayName: "Trouble In Town",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "571303310",
                        displayName: "Battle At Sea",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1597811112",
                        displayName: "Maternal Instinct",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1597811118",
                        displayName: "The Silberspiegel Battle",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370193071",
                        displayName: "Peaks Pass",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370193089",
                        displayName: "Magni And Modi",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370194143",
                        displayName: "Deliverance",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598200014",
                        displayName: "Nilfgaard Attacks",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: 151,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1537049507",
                        displayName: "Augury",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1537049512",
                        displayName: "Kingdom Of Shadows",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1596810693",
                        displayName: "Omen Of War",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1596810849",
                        displayName: "Battle In The No Man's Land",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501079",
                        displayName: "The Battle In Front Of The Ironworks",
                     altDisplayName: nil,
                      volumePercent: 64,
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "evil-background")

        tracklist.add(Track(storeID: "1443785957",
                        displayName: "Adagio",
                     altDisplayName: nil,
                      volumePercent: 106,
                        startOffset: 49,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149469",
                        displayName: "Prelude",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 26,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149505",
                        displayName: "Lost In The Storm",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501071",
                        displayName: "Princess Mononoke",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951623",
                        displayName: "Dragonsreach",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054351",
                        displayName: "Withered Roses",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1547585156",
                        displayName: "The Echo Of A Bygones",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507128",
                        displayName: "Signs Of Dusk",
                     altDisplayName: nil,
                      volumePercent: 72,
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
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638390",
                        displayName: "Dolls' Polyphony",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638392",
                        displayName: "Mutation",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: 197,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "881802374",
                        displayName: "The Resurrection Of The Giant Warrior",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 64,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501086",
                        displayName: "The World Of The Dead",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1444085653",
                        displayName: "Rain Forest",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553910185",
                        displayName: "Alternative 3",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862379",
                        displayName: "The Beastmaster 4",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: 37,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1291057994",
                        displayName: "Pilot",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: 122,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1326006067",
                        displayName: "Malfunction In The Ventral Terminus",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: 136,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1443798728",
                        displayName: "Time Travel",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1544458091",
                        displayName: "Close Probing",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514761",
                        displayName: "Escape From The Fade",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1547583725",
                        displayName: "Shadows Of The Past",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443854224",
                        displayName: "The Power Plant",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1522592699",
                        displayName: "Invaders",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457552640",
                        displayName: "Darkness",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1089460221",
                        displayName: "序曲",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688799",
                        displayName: "Les Dieux Des Incas",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
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
                            version: 2,
                      volumePercent: 90,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "896588775",
                        displayName: "\"It's Not A Dream\"",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588704",
                        displayName: "Marnie",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588797",
                        displayName: "Hisako's Story 1",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263828849",
                        displayName: "Gondoa",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588679",
                        displayName: "High Tide, Low Tide",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304426",
                        displayName: "Looking Back",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501267",
                        displayName: "Ashitaka And San",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013095",
                        displayName: "Porco E Bella",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501066",
                        displayName: "The Young Man From The East",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667022",
                        displayName: "The Sprout",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "362214366",
                        displayName: "Lasiurus",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: 385,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "570069182",
                        displayName: "The Blackmoor Mountains",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069192",
                        displayName: "Gone Home",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536478369",
                        displayName: "I Saw Your Ship",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263825788",
                        displayName: "The Legend Of The Wind",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263826308",
                        displayName: "The Road To The Valley",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578514",
                        displayName: "One Fine Morning",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "420781698",
                        displayName: "Falling Lights",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "420781685",
                        displayName: "Another Verdant World",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501054",
                        displayName: "The Journey To The West",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507130",
                        displayName: "A Journey",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507137",
                        displayName: "Men Of The Earth",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507135",
                        displayName: "To The Countryside",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553909945",
                        displayName: "From The Same Hill",
                     altDisplayName: nil,
                      volumePercent: 104,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724653244",
                        displayName: "First Light",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724653305",
                        displayName: "An Arc Of Doves",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477532180",
                        displayName: "Wind On Water",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1479093109",
                        displayName: "Bringing Down The Light",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 274,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862076",
                        displayName: "Night Journey",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507170",
                        displayName: "The Fire Of Life",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "472750929",
                        displayName: "Conan Love Theme",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237449",
                        displayName: "Isles Of The Starry Dream",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847633969",
                        displayName: "Northpoint Nocturne",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876044",
                        displayName: "Swimming",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596952556",
                        displayName: "Journey's End",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1458800801",
                        displayName: "Coming Home",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283731",
                        displayName: "The Path Of Old Tradition",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284111",
                        displayName: "Jacob And Thunder Heart Woman",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502480",
                        displayName: "Kaer Morhen",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502537",
                        displayName: "When No Man Has Gone Before",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538444",
                        displayName: "The Moon Over Mount Gorgon",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309211241",
                        displayName: "Spikeroog",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445188248",
                        displayName: "Calm Before The Storm",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872313",
                        displayName: "Another Day In Sandleford",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872754",
                        displayName: "Fiver Is Alive!",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482699258",
                        displayName: "Time To Come Home",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "158328253",
                        displayName: "Granny Wendy",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850652",
                        displayName: "Ek Elska þik",
                     altDisplayName: nil,
                      volumePercent: 108,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850653",
                        displayName: "Himinbjörg",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031936",
                        displayName: "Blue Mountains",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1405428938",
                        displayName: "Mutability",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 833,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189865",
                        displayName: "The Edge Of The Prairie",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481512264",
                        displayName: "Love Scene",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566129",
                        displayName: "Peaceful Hike",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636140",
                        displayName: "Embrace Of Sea Waves",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566133",
                        displayName: "The Fading Stories",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566703",
                        displayName: "Rays Of Sunlight",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535607381",
                        displayName: "Hence, Begins The Journey",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576317472",
                        displayName: "Old Tales Preserved",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566125",
                        displayName: "Scattered Amongst The Tides",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514853",
                        displayName: "Return To Skyhold",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568205",
                        displayName: "The Realm Within",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004736",
                        displayName: "Ondras Gift",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "797144336",
                        displayName: "Nimbus",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "797144282",
                        displayName: "Gougane Barra",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731118",
                        displayName: "Calling Across",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731119",
                        displayName: "The Waters Above",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731144",
                        displayName: "An Invitation",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731420",
                        displayName: "An Upwards Dance",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731431",
                        displayName: "Exhale",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731433",
                        displayName: "Lost And Found",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576481801",
                        displayName: "A Bell-Ringer",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678692",
                        displayName: "Arrive To Lab",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678698",
                        displayName: "Jeff",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847632221",
                        displayName: "Auridon Sunrise",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378582",
                        displayName: "Antichamber Suite I",
                     altDisplayName: nil,
                      volumePercent: 120,
                        startOffset: 330,
                          endOffset: 670,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378583",
                        displayName: "Antichamber Suite II",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: 360,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1443090591",
                        displayName: "A Game Of Intrigue",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 22,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861231",
                        displayName: "Drift",
                     altDisplayName: nil,
                      volumePercent: 81,
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "good-background")

        tracklist.add(Track(storeID: "669578598",
                        displayName: "Drippy",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304414",
                        displayName: "The Latin Quarter",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 16,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013097",
                        displayName: "Women Of Piccolo",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013089",
                        displayName: "Addio!",
                     altDisplayName: nil,
                      volumePercent: 132,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "433212255",
                        displayName: "Jade",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578676",
                        displayName: "Mummy's Tummy",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457542869",
                        displayName: "Oh No!",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1518600730",
                        displayName: "And It Happened Like This",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482698915",
                        displayName: "Etiquette Lessons",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "158328526",
                        displayName: "Smee's Plan",
                     altDisplayName: nil,
                      volumePercent: 115,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189836",
                        displayName: "A Sweet Smile",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576317265",
                        displayName: "Ariel's Footprints",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576317722",
                        displayName: "Sneaky & Mischievous",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1597810922",
                        displayName: "Four Iron Legs, Two Different Minds",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: 66,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1598116878",
                        displayName: "A Day In Mondstadt",
                     altDisplayName: nil,
                      volumePercent: 76,
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "good-background")

        tracklist.add(Track(storeID: "895667085",
                        displayName: "The Procession Of Celestial Beings I",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025764",
                        displayName: "The Pod Dance",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688781",
                        displayName: "Les Incas",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263826307",
                        displayName: "The Distant Days",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507141",
                        displayName: "Memories - The Storekeeper’s Advice",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 24,
                          endOffset: 98,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1451973356",
                        displayName: "Merry Go Round Of Life",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1495203872",
                        displayName: "They're Alive",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1369922096",
                        displayName: "Flaming Red Hair",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054340",
                        displayName: "Evening In The Tavern",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502490",
                        displayName: "Drink Up, There's More!",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502550",
                        displayName: "Another Round For Everyone",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445882207",
                        displayName: "Two Hornpipes",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885285655",
                        displayName: "Town Jig",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502477",
                        displayName: "The Nightingale",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502487",
                        displayName: "Forged In Fire",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031934",
                        displayName: "A Watering Hole In The Harbor",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481512266",
                        displayName: "Tavern Music",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1357657729",
                        displayName: "Amber Ale",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1595923617",
                        displayName: "Pocket's Lookin' Light",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1595923621",
                        displayName: "Runnin' From Lariette",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502536",
                        displayName: "A Story You Won't Believe",
                     altDisplayName: nil,
                      volumePercent: 89,
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "any-magic-and-mystery")

        tracklist.add(Track(storeID: "669578601",
                        displayName: "World Map",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: 200,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883013108",
                        displayName: "Porco E Bella - Ending",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578672",
                        displayName: "Ni No Kuni - Wrath Of The White Witch",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: 78,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1205025548",
                        displayName: "The Dark Crystal Overture",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "403427791",
                        displayName: "Flynn Lives",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688431",
                        displayName: "L'Aventure D'Esteban",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862130",
                        displayName: "A Hero's Theme",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "882407938",
                        displayName: "Laputa, Castle In The Sky",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: 175,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1421238739",
                        displayName: "Three Hearts Afire",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507180",
                        displayName: "The End And The Beginning - Song Of Time (Theme Song) - Ending",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 432,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872756",
                        displayName: "Join My Owsla",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514771",
                        displayName: "Journey To Skyhold",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671739",
                        displayName: "Descent - Main Theme",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636140",
                        displayName: "Embrace Of Sea Waves",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568478",
                        displayName: "Gallant Challenge",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "good-background")

        tracklist.add(Track(storeID: "669578515",
                        displayName: "Motorville",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578518",
                        displayName: "The Accident",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295045",
                        displayName: "Ponyo’s Sisters",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295067",
                        displayName: "Ponyo's Sisters Lend A Hand",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: 94,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "785256928",
                        displayName: "The Falcon",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: 75,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "400623307",
                        displayName: "I Am The Doctor",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825582",
                        displayName: "Outlands, Part II",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440663321",
                        displayName: "Guilty Of Being Innocent Of Being Jack Sparrow",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440654982",
                        displayName: "No Woman Has Ever Handled My Herschel",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885285639",
                        displayName: "Beyond The Darkness - Anthem From Earthsea",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502478",
                        displayName: "City Of Intrigues",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502486",
                        displayName: "Cloak And Dagger",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443203652",
                        displayName: "The Towering Inferno: Main Title",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443203665",
                        displayName: "The Towering Inferno: An Architect's Dream",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "158327948",
                        displayName: "Prologue",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1463898308",
                        displayName: "The Chase",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "269856904",
                        displayName: "Brave New World",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535610207",
                        displayName: "Charge! Fearless Warriors",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535611222",
                        displayName: "Riders Of The Wind, Onward",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636140",
                        displayName: "Embrace Of Sea Waves",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568478",
                        displayName: "Gallant Challenge",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519190020",
                        displayName: "Rite Of Battle",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671739",
                        displayName: "Descent - Main Theme",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514771",
                        displayName: "Journey To Skyhold",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1213439319",
                        displayName: "Years Of Training",
                     altDisplayName: nil,
                      volumePercent: 86,
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "883501063",
                        displayName: "Lady Eboshi",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501070",
                        displayName: "San And Ashitaka In The Forest Of The Deer God",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501203",
                        displayName: "Adagio Of Life And Death II",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: 43,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "896588774",
                        displayName: "When I Held A Doll",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295054",
                        displayName: "Gran Mamare",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: 58,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "895667081",
                        displayName: "Fate",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1497638388",
                        displayName: "Winds Over Neo-Tokyo",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: 102,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440854728",
                        displayName: "The Landing",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: 93,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378579",
                        displayName: "Beginnings I",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378581",
                        displayName: "Beginnings II",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378588",
                        displayName: "The Garden",
                     altDisplayName: nil,
                      volumePercent: 111,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966210",
                        displayName: "The Binding Of Isaac",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057018",
                        displayName: "Mesa",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: 115,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "570069183",
                        displayName: "Twin Souls",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533984915",
                        displayName: "S.T.A.Y.",
                     altDisplayName: nil,
                      volumePercent: 129,
                        startOffset: 30,
                          endOffset: 360,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "881802370",
                        displayName: "In The Sea Of Corruption",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721194",
                        displayName: "The Pursuit",
                     altDisplayName: nil,
                      volumePercent: 122,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721318",
                        displayName: "Revelation",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501060",
                        displayName: "The Forest Of The Gods",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443890585",
                        displayName: "Love Theme",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: 86,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1553910464",
                        displayName: "Events In Dense Fog",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553910712",
                        displayName: "Final Sunset",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "367363592",
                        displayName: "Sacred Stones",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1451903521",
                        displayName: "The Healing Place",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714416741",
                        displayName: "Meditation No. 2",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025770",
                        displayName: "Finale",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: 119,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1521641808",
                        displayName: "But Still We Go On",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1405427315",
                        displayName: "Premonition",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: 426,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1405428938",
                        displayName: "Mutability",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: 402,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "971057962",
                        displayName: "Beyond",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "472750767",
                        displayName: "Atlantean Sword",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "472750930",
                        displayName: "The Search",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1369922191",
                        displayName: "The Council Of Elrond Assembles / \"Aníron\"",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299303",
                        displayName: "Peaceful Waters",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299395",
                        displayName: "Over The Next Hill",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299570",
                        displayName: "The Prophecy Fulfilled",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237171",
                        displayName: "Gryphons Soar In The Sun",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237192",
                        displayName: "Dusk Song Of The High Elves",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237445",
                        displayName: "Masque Of Reveries",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951317",
                        displayName: "Ancient Stones",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951728",
                        displayName: "Distant Horizons",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951749",
                        displayName: "Dawn",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596952761",
                        displayName: "Sky Above, Voice Within",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1563886798",
                        displayName: "Enchantment",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 160,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1445876753",
                        displayName: "The Bubble",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876906",
                        displayName: "Mariner's Goodbye",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1463570498",
                        displayName: "Bacl2",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598302810",
                        displayName: "Peace Of Akatosh",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1495203992",
                        displayName: "Giltine The Artist",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1199914161",
                        displayName: "He Has To Go",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283565",
                        displayName: "Growling Bear's Vision",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284122",
                        displayName: "The Lakota, A Peaceful Nation",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284116",
                        displayName: "The Wheel And The Sunset",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675285940",
                        displayName: "Ghost Dance",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502484",
                        displayName: "Fate Calls",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538443",
                        displayName: "Beyond Hill And Dale...",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538452",
                        displayName: "Syanna",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538454",
                        displayName: "Lady Of The Lake",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1518300462",
                        displayName: "Celeste",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1518300653",
                        displayName: "Snow",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872595",
                        displayName: "Allow Me To Take You To The Great Burrow",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "372939372",
                        displayName: "Secret Garden",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: 176,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "270186219",
                        displayName: "Writing The Chronicles",
                     altDisplayName: nil,
                      volumePercent: 132,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "270186221",
                        displayName: "So Many New Worlds Revealed",
                     altDisplayName: nil,
                      volumePercent: 131,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850344",
                        displayName: "Njól",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850347",
                        displayName: "Jata",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031926",
                        displayName: "Dwarven Stone Upon Dwarven Stone",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031933",
                        displayName: "An Army Lying In Wait",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031941",
                        displayName: "Vergen By Night",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031943",
                        displayName: "A Quiet Corner",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1547583721",
                        displayName: "Gem In The Mountains",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514857",
                        displayName: "Thedas Love Theme",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671745",
                        displayName: "Trespasser - Lost Elf Theme",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189839",
                        displayName: "A Storm, A Spire, And A Sanctum",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535607800",
                        displayName: "Whispering Plain",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535608140",
                        displayName: "Wayward Souls",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535608593",
                        displayName: "Awaiting The Future",
                     altDisplayName: nil,
                      volumePercent: 138,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535611222",
                        displayName: "Riders Of The Wind, Onward",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203275",
                        displayName: "Nott",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203276",
                        displayName: "To The Next World",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1357657481",
                        displayName: "Reaper's Coast",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1260559162",
                        displayName: "Flight Of The Arora",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1485424843",
                        displayName: "Frozen Space",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533266364",
                        displayName: "Not What I Expected",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500850216",
                        displayName: "Ori, Embracing The Light",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566945",
                        displayName: "Bird Call From Afar",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "445913519",
                        displayName: "Through The Woods",
                     altDisplayName: nil,
                      volumePercent: 128,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585634895",
                        displayName: "Samurai's Sorrow",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585635014",
                        displayName: "Ones Who Strive To Live",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1357657918",
                        displayName: "Path Of The Godwoken",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "380350246",
                        displayName: "Time",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847631887",
                        displayName: "Omens In The Clouds",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "477786768",
                        displayName: "The Crossroads Of The World",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "477786812",
                        displayName: "Altair And Darim",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "477786814",
                        displayName: "The Revelation",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "571303217",
                        displayName: "HomeStead",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "571303303",
                        displayName: "Temple Secrets",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "571303313",
                        displayName: "What Came Before",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1594447025",
                        displayName: "Winds Of Cyrene",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1594447248",
                        displayName: "Nomads Of The White Desert",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457552641",
                        displayName: "Heal",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457552644",
                        displayName: "Continue",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004726",
                        displayName: "Encampment",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004742",
                        displayName: "Elmshore",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004751",
                        displayName: "A New Act",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1597811119",
                        displayName: "The Devil's Pass",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370192787",
                        displayName: "Lullaby Of The Giants",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1213439326",
                        displayName: "Anointed",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598200120",
                        displayName: "Kaer Morhen",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598200272",
                        displayName: "Who Did This To You?",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598200293",
                        displayName: "Remembering Cintra",
                     altDisplayName: nil,
                      volumePercent: 135,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "797144332",
                        displayName: "Lover Stone",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "797144337",
                        displayName: "Ocean Hotel",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598667763",
                        displayName: "Dawn Valley",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678706",
                        displayName: "GY Story",
                     altDisplayName: nil,
                      volumePercent: 107,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678707",
                        displayName: "Butterfly",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1205025767",
                        displayName: "The Gelfling Ruins",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442463185",
                        displayName: "Night Bird",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440494309",
                        displayName: "Prophecy Theme",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1062368475",
                        displayName: "Always",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149474",
                        displayName: "Stalactite Gallery",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1509086247",
                        displayName: "Is That What Everybody Wants",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825340",
                        displayName: "Solar Sailer",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861225",
                        displayName: "An Ending",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 83,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724437413",
                        displayName: "A Clearing",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443090596",
                        displayName: "May Angels Fly Thee Home",
                     altDisplayName: nil,
                      volumePercent: 140,
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
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "895667086",
                        displayName: "The Parting",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "785256920",
                        displayName: "Nahoko",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304412",
                        displayName: "Reminiscence",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667055",
                        displayName: "Memories Of The Village",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667080",
                        displayName: "Sorrow",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "588848790",
                        displayName: "Gelt's Death",
                     altDisplayName: nil,
                      volumePercent: 106,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "73327359",
                        displayName: "Memories Of Green",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472276636",
                        displayName: "Milowda",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802374",
                        displayName: "The Resurrection Of The Giant Warrior",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: 64,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "895667123",
                        displayName: "Moon",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: 103,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "403427801",
                        displayName: "Father And Son",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "403846004",
                        displayName: "Adagio For Tron",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714899528",
                        displayName: "A Paler Sky",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "978344399",
                        displayName: "The Appearance Of Colour",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: 420,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1205025765",
                        displayName: "Dark Crystal Love Theme",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057991",
                        displayName: "Someone Lived This",
                     altDisplayName: nil,
                      volumePercent: 129,
                        startOffset: 0,
                          endOffset: 170,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "896588789",
                        displayName: "\"It's Like We Traded Places\"",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "472750929",
                        displayName: "Conan Love Theme",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1062368749",
                        displayName: "The Very Air",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263828943",
                        displayName: "A Big Adventure",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "192058200",
                        displayName: "Another Time, Another Place: Flowers For Helena",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237449",
                        displayName: "Isles Of The Starry Dream",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326005525",
                        displayName: "Hinterlands",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326005912",
                        displayName: "The Brass Fortress",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006070",
                        displayName: "Hope Just Out Of Reach",
                     altDisplayName: nil,
                      volumePercent: 113,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847634015",
                        displayName: "Memories Of Yokuda Lost",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876904",
                        displayName: "Balloon Flight",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507128",
                        displayName: "Signs Of Dusk",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502473",
                        displayName: "Spikeroog",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1199913534",
                        displayName: "The Girl",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1199913606",
                        displayName: "White Hair",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507154",
                        displayName: "Light And Shadow",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440799961",
                        displayName: "Have You Got A Story For Me",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284128",
                        displayName: "Gangrene",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671745",
                        displayName: "Trespasser - Lost Elf Theme",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189860",
                        displayName: "Pure Sky",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535609141",
                        displayName: "Forlorn Child Of Archaic Winds",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "971519733",
                        displayName: "The Blinded Forest",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: 172,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1500850213",
                        displayName: "A Stirring Of Memories",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1586681856",
                        displayName: "BB's Theme",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1518300462",
                        displayName: "Celeste",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500836049",
                        displayName: "Death Of A'ba",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "571303216",
                        displayName: "Farewell",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1485424718",
                        displayName: "Alone We Have No Future",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }
}

