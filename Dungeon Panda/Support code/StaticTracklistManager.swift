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

        addValhallaGoodBackground()
        addValhallaGoodTavern()
        addValhallaGoodQuirky()
        addValhallaGoodVictory()

        addValhallaEvilBackground()
        addValhallaEvilBattle()
        addValhallaEvilTwisted()
        addValhallaEvilFailure()

        addAnyValhallaMagicAndMystery()
        addAnyValhallaHurry()
        addAnyValhallaSorrow()
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
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "948526708",
                        displayName: "Cosmos",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667051",
                        displayName: "Despair",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667080",
                        displayName: "Sorrow",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578518",
                        displayName: "The Accident",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854740",
                        displayName: "The Alien Planet",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854774",
                        displayName: "The Shaft",
                     altDisplayName: nil,
                      volumePercent: 108,
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
                      volumePercent: 115,
                        startOffset: 0,
                          endOffset: 430,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378587",
                        displayName: "Dying World",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "362214274",
                        displayName: "Macrotus",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966284",
                        displayName: "Repentant",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966635",
                        displayName: "Apostate",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057014",
                        displayName: "Wallace",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1521641819",
                        displayName: "Borderlines",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536478364",
                        displayName: "Rose Of Victory",
                     altDisplayName: nil,
                      volumePercent: 140,
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
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: 346,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1309689770",
                        displayName: "Le Bouclier Fumant",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578680",
                        displayName: "The Horror Of Manna",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578682",
                        displayName: "Unrest",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721204",
                        displayName: "A Sentient Being",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1509086631",
                        displayName: "Hi Energy Proton Accelerator",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "726982844",
                        displayName: "Khan's Pets",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543396033",
                        displayName: "The Bluetide Computers",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825567",
                        displayName: "Encom, Part I",
                     altDisplayName: nil,
                      volumePercent: 117,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "293897542",
                        displayName: "Lux Aeterna",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "43453375",
                        displayName: "Atmosphères For Orchestra",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 9,
                          endOffset: 500,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "724653382",
                        displayName: "Wind In Lonely Fences",
                     altDisplayName: nil,
                      volumePercent: 105,
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
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861334",
                        displayName: "Stars",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "684270302",
                        displayName: "Lanzarote",
                     altDisplayName: nil,
                      volumePercent: 87,
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
                      volumePercent: 81,
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
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149471",
                        displayName: "Hunting Dogs",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069205",
                        displayName: "Haunted Mansion Ambience",
                     altDisplayName: nil,
                      volumePercent: 138,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1473582115",
                        displayName: "Riddle And Shadow",
                     altDisplayName: nil,
                      volumePercent: 118,
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
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006070",
                        displayName: "Hope Just Out Of Reach",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006185",
                        displayName: "Port Of Thieves",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006187",
                        displayName: "Tonal Architecture",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847631942",
                        displayName: "Rubble And Smoke",
                     altDisplayName: nil,
                      volumePercent: 127,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675285651",
                        displayName: "Drowning Jethro",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: 123,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1544458100",
                        displayName: "Rite Of Passage",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1544458104",
                        displayName: "The Sacred And The Profane",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445723925",
                        displayName: "Forbidden Forest",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1400508359",
                        displayName: "In The Jungle",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031930",
                        displayName: "Through The Underworld",
                     altDisplayName: nil,
                      volumePercent: 71,
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

        tracklist.add(Track(storeID: "1640104849",
                        displayName: "Cappadocia",
                     altDisplayName: nil,
                      volumePercent: 125,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640148602",
                        displayName: "Dead Kings And Living Gods",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203007",
                        displayName: "Frozen Lands",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203277",
                        displayName: "Animus Anomaly",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440654730",
                        displayName: "Dead Men Tell No Tales",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004737",
                        displayName: "Brackenbury",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640110651",
                        displayName: "Hideout",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640110661",
                        displayName: "The Animus 2.0",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: 252,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1597811111",
                        displayName: "Moonlight Tension",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370193588",
                        displayName: "Helheim",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507152",
                        displayName: "Abduction - The Lure Of Eternal Life",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 75,
                          endOffset: 192,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1569689287",
                        displayName: "The Ocean Bog",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596953302",
                        displayName: "Shattered Shields",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678660351",
                        displayName: "A Truth Whispered At Night",
                     altDisplayName: nil,
                      volumePercent: 125,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482830438",
                        displayName: "Musurgia Universalis",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054345",
                        displayName: "An Ominous Place",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618480106",
                        displayName: "Contemplation On Eternity",
                     altDisplayName: nil,
                      volumePercent: 135,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "205724429",
                        displayName: "Unauthorised Access",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1559225230",
                        displayName: "Sinister Mist",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1189857560",
                        displayName: "Underground Tunnel",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1189857564",
                        displayName: "Shagohod",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472026060",
                        displayName: "The Mole",
                     altDisplayName: nil,
                      volumePercent: 110,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472027363",
                        displayName: "Entering TYM",
                     altDisplayName: nil,
                      volumePercent: 123,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472026053",
                        displayName: "Detroit City Ambient, Part 1",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879808",
                        displayName: "Duskwood",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879893",
                        displayName: "Graveyard",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1639205401",
                        displayName: "Prelude Of Change",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1641148929",
                        displayName: "A Djinn's Oblivion",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649509244",
                        displayName: "In The Solemn Gloom",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649509700",
                        displayName: "Faith In The Percept",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1142772118",
                        displayName: "Are You Sure?",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "499880124",
                        displayName: "Radiowaves",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1661773556",
                        displayName: "Diseased",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309649367",
                        displayName: "Sirène",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617833187",
                        displayName: "Malfuction",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617834106",
                        displayName: "System Inoperative",
                     altDisplayName: nil,
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598302650",
                        displayName: "Tension",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1325847906",
                        displayName: "Flickering Shadows",
                     altDisplayName: nil,
                      volumePercent: 111,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1525225221",
                        displayName: "Shivering Dread",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1517686841",
                        displayName: "OK With Me",
                     altDisplayName: nil,
                      volumePercent: 127,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1316656485",
                        displayName: "Shadowland",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1454603886",
                        displayName: "Shadows Creeping -Battle With The Colossus-",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679418497",
                        displayName: "The Underdark",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859953",
                        displayName: "The Emerald Abyss",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640078145",
                        displayName: "Stealth",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859949",
                        displayName: "The Enclave",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533984721",
                        displayName: "Running Out",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533985180",
                        displayName: "Atmospheric Entry",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137623",
                        displayName: "Vignette: Visions",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1687337813",
                        displayName: "Scout Bot",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460037828",
                        displayName: "Impecunious Circumstances",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460037990",
                        displayName: "\"A Good Man In The Dirt\"",
                     altDisplayName: nil,
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460038012",
                        displayName: "Black Rider",
                     altDisplayName: nil,
                      volumePercent: 114,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702859955",
                        displayName: "Just A Scratch",
                     altDisplayName: nil,
                      volumePercent: 139,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860027",
                        displayName: "Brain Farm",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860030",
                        displayName: "Dynasties Of The Spire",
                     altDisplayName: nil,
                      volumePercent: 137,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1698938894",
                        displayName: "Moment Of Conflict",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1685071316",
                        displayName: "Kits",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702516449",
                        displayName: "In Hiding",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1577429534",
                        displayName: "Temptation",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1473582369",
                        displayName: "Secrets Of Azurah",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640089217",
                        displayName: "What It Has Always Been",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1725091387",
                        displayName: "Something's Coming",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1729994153",
                        displayName: "Les Ténèbres Et L'oubli",
                     altDisplayName: nil,
                      volumePercent: 60,
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
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501065",
                        displayName: "The Furies",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501080",
                        displayName: "The Demon Power II",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501084",
                        displayName: "The Demon God III",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "372939377",
                        displayName: "World Of The Dead",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 244,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883501743",
                        displayName: "Yubaba's Panic",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "726982851",
                        displayName: "Battle In The Mutara Nebula",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: 473,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "726982841",
                        displayName: "Surprise Attack",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: 272,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "726982843",
                        displayName: "Kirk's Explosive Reply",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718569",
                        displayName: "Combat Drop",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718931",
                        displayName: "Ripley's Rescue",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718939",
                        displayName: "Futile Escape",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 185,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440718954",
                        displayName: "Going After Newt",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854721",
                        displayName: "Breakaway",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: 92,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1440854728",
                        displayName: "The Landing",
                     altDisplayName: nil,
                      volumePercent: 90,
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

        tracklist.add(Track(storeID: "1444138318",
                        displayName: "Cylon Attack / The End Of Atlantia",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: 120,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883507127",
                        displayName: "Cataclysm - Dragon",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885285641",
                        displayName: "Spanish Dragon",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 20,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802253",
                        displayName: "Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802373",
                        displayName: "The Battle Between Mehve And Corvette",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443090240",
                        displayName: "The Dragon's Lair",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: 161,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "62795351",
                        displayName: "Out Of Control / The Crash",
                     altDisplayName: nil,
                      volumePercent: 116,
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
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825328",
                        displayName: "Recognizer",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825344",
                        displayName: "Disc Wars",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825333",
                        displayName: "Outlands",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545861909",
                        displayName: "The Horde",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862120",
                        displayName: "The Battle On The Pyramid",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1455420272",
                        displayName: "Sky Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481510276",
                        displayName: "To Kill An Ogre",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "971057963",
                        displayName: "The Cursed Army",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578610",
                        displayName: "Imperial March",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578819",
                        displayName: "The Final Battle Against The White Witch",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578826",
                        displayName: "The Wrath Of The White Witch",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069177",
                        displayName: "Abadis Forest",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069179",
                        displayName: "No Rest For The Wicked",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069184",
                        displayName: "Everdawn Basin",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069188",
                        displayName: "Let's End This",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443798610",
                        displayName: "The Whaler",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291058471",
                        displayName: "Sea Wall",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 550,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1472276447",
                        displayName: "Heat Her Up",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472276656",
                        displayName: "We Have To Kill It",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502471",
                        displayName: "Commanding The Fury",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502475",
                        displayName: "Silver For Monsters...",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502496",
                        displayName: "The Hunt Is Coming",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502544",
                        displayName: "On Thin Ice",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502551",
                        displayName: "Conjunction Of The Spheres",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031925",
                        displayName: "Arena Of Rage",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031937",
                        displayName: "The Path Of A Kingslayer",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031946",
                        displayName: "Howl Of The White Wolf",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054092",
                        displayName: "Last Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054211",
                        displayName: "To Arms",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442463007",
                        displayName: "Elite Guard Attacks",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442463415",
                        displayName: "Conan & Bombaata Battle",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847627867",
                        displayName: "For Blood, For Glory, For Honor",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847633931",
                        displayName: "Onslaught At The Gates",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951645",
                        displayName: "Death Or Sovngarde",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 166,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1326005909",
                        displayName: "Blood In The Foyada",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006172",
                        displayName: "All History Is Vengeance",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006186",
                        displayName: "Granite And Ashes",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237797",
                        displayName: "From Abysses Below And Beyond",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299350",
                        displayName: "Knight's Charge",
                     altDisplayName: nil,
                      volumePercent: 78,
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
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876758",
                        displayName: "Helen Frees The Mariner",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876897",
                        displayName: "Deacon's Speech",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442845605",
                        displayName: "Durant Is Dead",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482699247",
                        displayName: "I've Made My Choice, You'll Have To Make Yours",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482699249",
                        displayName: "Protecting Our Kind",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283561",
                        displayName: "Buffalo Run",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283730",
                        displayName: "Hunting The Buffalo",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284164",
                        displayName: "Crossing The River",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445723924",
                        displayName: "Riches And Glory",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445188306",
                        displayName: "Retribution",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1544457962",
                        displayName: "V",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443203652",
                        displayName: "The Towering Inferno: Main Title",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1385167998",
                        displayName: "Marauders Arrive",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1385167994",
                        displayName: "Corellia Chase",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "270186240",
                        displayName: "A Desperate Run Through The Tunnels",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 59,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500835983",
                        displayName: "The Frozen Lake",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 93,
                          endOffset: 217,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1547584108",
                        displayName: "Highlanders Waltz",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1547584867",
                        displayName: "Fight With Fear!",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514846",
                        displayName: "The Lie In Which You Linger",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514849",
                        displayName: "Let The Skies Boil",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671744",
                        displayName: "Trespasser - Dark Solas Theme",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671867",
                        displayName: "Trespasser - Qunari Mission",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671868",
                        displayName: "Trespasser - Qunari Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671741",
                        displayName: "Descent - Titan",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189843",
                        displayName: "Caelestinum Finale Termini",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519190020",
                        displayName: "Rite Of Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568208",
                        displayName: "Rapid As Wildfires",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568213",
                        displayName: "Chasing The Torrents",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568478",
                        displayName: "Gallant Challenge",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535610188",
                        displayName: "His Resolution",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535610207",
                        displayName: "Charge! Fearless Warriors",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535611501",
                        displayName: "Symphony Of Boreal Wind",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636299",
                        displayName: "Against The Invisible Net",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636316",
                        displayName: "Fiery Pursuit",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "298704454",
                        displayName: "Saw Bitch Workhorse",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1485424741",
                        displayName: "Flower Of Fingers",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481496322",
                        displayName: "Surkesh",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481496325",
                        displayName: "I'm Sorry",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481496331",
                        displayName: "Reaper Chase",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1522592692",
                        displayName: "Chase",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1522592696",
                        displayName: "One Way In",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640063111",
                        displayName: "DeMolay's Condemnation",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640103562",
                        displayName: "Forum Of Ox",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640119607",
                        displayName: "Through The Frontier",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640119810",
                        displayName: "Trouble In Town",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640121348",
                        displayName: "Battle At Sea",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1597811112",
                        displayName: "Maternal Instinct",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1597811118",
                        displayName: "The Silberspiegel Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370193071",
                        displayName: "Peaks Pass",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370193089",
                        displayName: "Magni And Modi",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370194143",
                        displayName: "Deliverance",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598200014",
                        displayName: "Nilfgaard Attacks",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 151,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1537049507",
                        displayName: "Augury",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1537049512",
                        displayName: "Kingdom Of Shadows",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1596810693",
                        displayName: "Omen Of War",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1596810849",
                        displayName: "Battle In The No Man's Land",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501079",
                        displayName: "The Battle In Front Of The Ironworks",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440494300",
                        displayName: "First Attack",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440494456",
                        displayName: "Big Battle",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "469356680",
                        displayName: "TALLY HO!",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535452368",
                        displayName: "Fódlan Winds",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678661627",
                        displayName: "The Spreading Eclipse",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678661639",
                        displayName: "Force Multiplication",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678662036",
                        displayName: "Will Against Will",
                     altDisplayName: nil,
                      volumePercent: 107,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1030638677",
                        displayName: "Metal Gear Online",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "569865667",
                        displayName: "Diablo III: Overture",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "569865668",
                        displayName: "Batman Arkham City: Main Theme",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618484344",
                        displayName: "Chrysalis Suspirii",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "205724103",
                        displayName: "African Rundown",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450669511",
                        displayName: "The Bridge",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1630113063",
                        displayName: "Irresistible Force",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1630113492",
                        displayName: "Seething Animosity",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1630113499",
                        displayName: "Undercurrents Of Hostility",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1630113732",
                        displayName: "Inevitable Conflict",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1189857642",
                        displayName: "Mighty Power",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1548347110",
                        displayName: "Saving The Orville",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1548347447",
                        displayName: "Ice Moon",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446737236",
                        displayName: "Iron Man 3",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879757",
                        displayName: "Orgrimmar",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "294992017",
                        displayName: "Rise Of The Vrykul",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "294992091",
                        displayName: "The Wrath Gate",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472026486",
                        displayName: "Jewel Of The Orient",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1632712011",
                        displayName: "They Are Coming",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640099150",
                        displayName: "Conflict On The Seas",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1664232791",
                        displayName: "Final Conflict",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1664232886",
                        displayName: "Final Crisis",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1664232887",
                        displayName: "The Enemy Warlord Appears",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1494288283",
                        displayName: "War Song Of Kings",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1494288467",
                        displayName: "Ice Blade",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1494289029",
                        displayName: "At The Dawn Of Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1494288288",
                        displayName: "Lion Dance",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649512622",
                        displayName: "Swirls Of The Stream",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649512631",
                        displayName: "Gilded Runner",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649512634",
                        displayName: "Jolts In The Forest",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1629006202",
                        displayName: "The Escape From Efrafa",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: 147,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1629006210",
                        displayName: "Final Struggle And Triumph",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: 156,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1709641590",
                        displayName: "Spaceship Chase",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1030638665",
                        displayName: "On The Trail",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561048874",
                        displayName: "Its Crash Could Not Be Denied",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561048885",
                        displayName: "Rise Again, Rise Again",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1571294322",
                        displayName: "Death In The Shallows",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1634930631",
                        displayName: "Midnight Mission",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585875153",
                        displayName: "Anacreon",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263341954",
                        displayName: "Dream Battle",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1501266151",
                        displayName: "No Man's Land",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666503316",
                        displayName: "Wrath Of Monoceros Caeli",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666503326",
                        displayName: "Dance With The Great Vortex",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666503337",
                        displayName: "Rage Beneath The Mountains",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596952754",
                        displayName: "Blood And Steel",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538361",
                        displayName: "For Honor! For Toussaint!",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500828825",
                        displayName: "Go",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1668420580",
                        displayName: "Heart Of Karaturam",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443622336",
                        displayName: "The Leviathan",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498708396",
                        displayName: "Robot Soldier/ Resurrection-Rescue -",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1624886764",
                        displayName: "遺忘",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1581423232",
                        displayName: "Ocean Princess",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "690532536",
                        displayName: "Towards The Asylum",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1541746025",
                        displayName: "Ontological Shock",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679419142",
                        displayName: "Final Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "971520720",
                        displayName: "Fleeing Kuro",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859940",
                        displayName: "Valor",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859952",
                        displayName: "The Chimera",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640078545",
                        displayName: "Aveline's Escape",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1688421723",
                        displayName: "Strength Of A Thousand Beards",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1699304346",
                        displayName: "Hober Mallow",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859947",
                        displayName: "The Titan",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859945",
                        displayName: "The Monitor",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1747547303",
                        displayName: "Rockwell's Proliferation I",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1682507078",
                        displayName: "Gravity",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498700272",
                        displayName: "MADNESS",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1697817315",
                        displayName: "Pedujara: Ephemeral Cycle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1579598403",
                        displayName: "If A Cause Is Worth Dying For Then Be",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1652582798",
                        displayName: "The Vault, Part 3 And 4",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498708228",
                        displayName: "To The Death",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719240596",
                        displayName: "First Flight",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719240602",
                        displayName: "Jackers Ahead!",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719241081",
                        displayName: "Space Battle",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719241086",
                        displayName: "Battle In The Maze",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719241726",
                        displayName: "Shad's Pursuit",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719241964",
                        displayName: "Destruction Of Hammerhead",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1693136498",
                        displayName: "Defend",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "882658799",
                        displayName: "Old Man's Deck Brush",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "882658798",
                        displayName: "Rough-Flying Airship Adventure",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1523806808",
                        displayName: "The Knight",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1523806831",
                        displayName: "Madder Sky",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1725091354",
                        displayName: "Young Heroes",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1737211838",
                        displayName: "Mountainborn Gale",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295066",
                        displayName: "Toki",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1753547992",
                        displayName: "Proper Tactic Formula",
                     altDisplayName: nil,
                      volumePercent: 60,
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
                      volumePercent: 108,
                        startOffset: 49,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149469",
                        displayName: "Prelude",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 26,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149505",
                        displayName: "Lost In The Storm",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501071",
                        displayName: "Princess Mononoke",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951623",
                        displayName: "Dragonsreach",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054351",
                        displayName: "Withered Roses",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1547585156",
                        displayName: "The Echo Of A Bygones",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507128",
                        displayName: "Signs Of Dusk",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640105295",
                        displayName: "Passing The Torch",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860039",
                        displayName: "Downfall",
                     altDisplayName: nil,
                      volumePercent: 130,
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

        tracklist.add(Track(storeID: "881802374",
                        displayName: "The Resurrection Of The Giant Warrior",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 64,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501086",
                        displayName: "The World Of The Dead",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1444085653",
                        displayName: "Rain Forest",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553910185",
                        displayName: "Alternative 3",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862379",
                        displayName: "The Beastmaster 4",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 37,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1291057994",
                        displayName: "Pilot",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: 122,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1326006067",
                        displayName: "Malfunction In The Ventral Terminus",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 136,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1443798728",
                        displayName: "Time Travel",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1544458091",
                        displayName: "Close Probing",
                     altDisplayName: nil,
                      volumePercent: 90,
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
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443854224",
                        displayName: "The Power Plant",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1522592699",
                        displayName: "Invaders",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457552640",
                        displayName: "Darkness",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1089460221",
                        displayName: "序曲",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688799",
                        displayName: "Les Dieux Des Incas",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1109391374",
                        displayName: "Rotating Room",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1632712012",
                        displayName: "Grim Discovery",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553230109",
                        displayName: "Nadir",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1571294323",
                        displayName: "Anguish Beyond The Veil",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1745066630",
                        displayName: "Realm Of The Skaven",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1491852251",
                        displayName: "Daemons To Dust",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: 127,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1498636232",
                        displayName: "I'm Sam Bell",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1525225935",
                        displayName: "Skyrim’s Dark Secret",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1199913998",
                        displayName: "The Fall",
                     altDisplayName: nil,
                      volumePercent: 134,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1517686848",
                        displayName: "You Look Lost",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896512380",
                        displayName: "God Territory",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514837",
                        displayName: "Nightmare's End",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203004",
                        displayName: "Leofirth’s Honor",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679418149",
                        displayName: "Szass Tam's Story",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1281822195",
                        displayName: "Treehouse",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "400623321",
                        displayName: "The Time Of Angels",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1033193882",
                        displayName: "The Original Sin",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1716588913",
                        displayName: "Loki's Binding",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1646521614",
                        displayName: "Consensual Hallucination",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500836563",
                        displayName: "Angel Attack",
                     altDisplayName: nil,
                      volumePercent: 63,
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
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588704",
                        displayName: "Marnie",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588797",
                        displayName: "Hisako's Story 1",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263828849",
                        displayName: "Gondoa",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896588679",
                        displayName: "High Tide, Low Tide",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304426",
                        displayName: "Looking Back",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501267",
                        displayName: "Ashitaka And San",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013095",
                        displayName: "Porco E Bella",
                     altDisplayName: nil,
                      volumePercent: 61,
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
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "362214366",
                        displayName: "Lasiurus",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: 385,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "570069182",
                        displayName: "The Blackmoor Mountains",
                     altDisplayName: nil,
                      volumePercent: 84,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "570069192",
                        displayName: "Gone Home",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536478369",
                        displayName: "I Saw Your Ship",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263825788",
                        displayName: "The Legend Of The Wind",
                     altDisplayName: nil,
                      volumePercent: 108,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263826308",
                        displayName: "The Road To The Valley",
                     altDisplayName: nil,
                      volumePercent: 124,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578514",
                        displayName: "One Fine Morning",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "420781698",
                        displayName: "Falling Lights",
                     altDisplayName: nil,
                      volumePercent: 115,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "420781685",
                        displayName: "Another Verdant World",
                     altDisplayName: nil,
                      volumePercent: 132,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501054",
                        displayName: "The Journey To The West",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507130",
                        displayName: "A Journey",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507137",
                        displayName: "Men Of The Earth",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507135",
                        displayName: "To The Countryside",
                     altDisplayName: nil,
                      volumePercent: 75,
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
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724653305",
                        displayName: "An Arc Of Doves",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477532180",
                        displayName: "Wind On Water",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1479093109",
                        displayName: "Bringing Down The Light",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 274,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862076",
                        displayName: "Night Journey",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507170",
                        displayName: "The Fire Of Life",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237449",
                        displayName: "Isles Of The Starry Dream",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847633969",
                        displayName: "Northpoint Nocturne",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876044",
                        displayName: "Swimming",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596952556",
                        displayName: "Journey's End",
                     altDisplayName: nil,
                      volumePercent: 118,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1458800801",
                        displayName: "Coming Home",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283731",
                        displayName: "The Path Of Old Tradition",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284111",
                        displayName: "Jacob And Thunder Heart Woman",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502480",
                        displayName: "Kaer Morhen",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502537",
                        displayName: "When No Man Has Gone Before",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538444",
                        displayName: "The Moon Over Mount Gorgon",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309211241",
                        displayName: "Spikeroog",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445188248",
                        displayName: "Calm Before The Storm",
                     altDisplayName: nil,
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872313",
                        displayName: "Another Day In Sandleford",
                     altDisplayName: nil,
                      volumePercent: 119,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872754",
                        displayName: "Fiver Is Alive!",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482699258",
                        displayName: "Time To Come Home",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "158328253",
                        displayName: "Granny Wendy",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850652",
                        displayName: "Ek Elska þik",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850653",
                        displayName: "Himinbjörg",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031936",
                        displayName: "Blue Mountains",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1373009959",
                        displayName: "Mutability",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 833,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189865",
                        displayName: "The Edge Of The Prairie",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481512264",
                        displayName: "Love Scene",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566129",
                        displayName: "Peaceful Hike",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636140",
                        displayName: "Embrace Of Sea Waves",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566133",
                        displayName: "The Fading Stories",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566703",
                        displayName: "Rays Of Sunlight",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535607381",
                        displayName: "Hence, Begins The Journey",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566125",
                        displayName: "Scattered Amongst The Tides",
                     altDisplayName: nil,
                      volumePercent: 137,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514853",
                        displayName: "Return To Skyhold",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568205",
                        displayName: "The Realm Within",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004736",
                        displayName: "Ondras Gift",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1757429885",
                        displayName: "Nimbus",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1757429657",
                        displayName: "Gougane Barra",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731118",
                        displayName: "Calling Across",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731119",
                        displayName: "The Waters Above",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731144",
                        displayName: "An Invitation",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731420",
                        displayName: "An Upwards Dance",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731431",
                        displayName: "Exhale",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1565731433",
                        displayName: "Lost And Found",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1576481801",
                        displayName: "A Bell-Ringer",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678692",
                        displayName: "Arrive To Lab",
                     altDisplayName: nil,
                      volumePercent: 130,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678698",
                        displayName: "Jeff",
                     altDisplayName: nil,
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847632221",
                        displayName: "Auridon Sunrise",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378582",
                        displayName: "Antichamber Suite I",
                     altDisplayName: nil,
                      volumePercent: 119,
                        startOffset: 330,
                          endOffset: 670,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378583",
                        displayName: "Antichamber Suite II",
                     altDisplayName: nil,
                      volumePercent: 140,
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
                      volumePercent: 118,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678660338",
                        displayName: "Within The Embrace",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1614352315",
                        displayName: "Heroic Deeds",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "218848763",
                        displayName: "Endtitle",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054344",
                        displayName: "Peaceful Moments",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618476205",
                        displayName: "Illuminated Coral Palace",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618476639",
                        displayName: "Stroll Along The Beach",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1630111394",
                        displayName: "Wordless Cliffs",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1548347342",
                        displayName: "Laura's Theme",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1146832204",
                        displayName: "New Dalaran",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1632711523",
                        displayName: "Ray Of Light",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1664232776",
                        displayName: "Crossroad At Dawn",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649506060",
                        displayName: "Village Surrounded By Green",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649506065",
                        displayName: "Enchanting Bedtime Stories",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649507008",
                        displayName: "A Desultory Stroll",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649507011",
                        displayName: "Chasing The Reflection",
                     altDisplayName: nil,
                      volumePercent: 137,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649507261",
                        displayName: "Languid And Quiet Moment",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649507265",
                        displayName: "Vagrant Wandering",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649505557",
                        displayName: "Flickering Shadows Of Trees",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649507605",
                        displayName: "Ethereal Mildness",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649507612",
                        displayName: "Resonant Chant In The Woods",
                     altDisplayName: nil,
                      volumePercent: 104,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649508460",
                        displayName: "Funneled Gorge",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649509223",
                        displayName: "Lingering Memories",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1629006191",
                        displayName: "Violet's Gone",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872747",
                        displayName: "Good Times In Watership Down",
                     altDisplayName: nil,
                      volumePercent: 124,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553230097",
                        displayName: "Threshold",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1002752604",
                        displayName: "Contact",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561048875",
                        displayName: "Periki's Overlook",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561048877",
                        displayName: "The Brass Citadel",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1122403539",
                        displayName: "Jellyfish",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617833171",
                        displayName: "Floating Office",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666496114",
                        displayName: "Old Tales Preserved",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666502707",
                        displayName: "A Letter From Afar",
                     altDisplayName: nil,
                      volumePercent: 108,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299405",
                        displayName: "Blessing Of Vivec",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1458801686",
                        displayName: "Anew",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445188249",
                        displayName: "Moment Of Respite",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1292989179",
                        displayName: "目標",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1292989580",
                        displayName: "期待",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1672018505",
                        displayName: "Making Gardens Out Of Silence In The Uncanny Valley",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: 488,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1682510764",
                        displayName: "Choose Wisely",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679417720",
                        displayName: "Reunited With Kira",
                     altDisplayName: nil,
                      volumePercent: 133,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617691222",
                        displayName: "377 Second Meditation",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1698938351",
                        displayName: "Soothing Nightfall",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460037986",
                        displayName: "Kings And Queens",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860043",
                        displayName: "Epilogue",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709635820",
                        displayName: "Expectation For Exploration",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1473582103",
                        displayName: "The Two-Moons Dance",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1701135226",
                        displayName: "A New World",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1729990872",
                        displayName: "Lumidouce's Repose",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1300076534",
                        displayName: "Ducks And Currents",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1737206175",
                        displayName: "Camellia Night",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1737206646",
                        displayName: "Creeks Of Nostalgia",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1737210355",
                        displayName: "When The Herb Fades",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1737210366",
                        displayName: "Trace Of Grace",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1759130611",
                        displayName: "Tales From The Hills",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1759130739",
                        displayName: "Per Amica Silentia Lunae",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502488",
                        displayName: "Yes, I Do...",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1758751133",
                        displayName: "Dreams Aglow",
                     altDisplayName: nil,
                      volumePercent: 137,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1671953570",
                        displayName: "Luther's Theme",
                     altDisplayName: nil,
                      volumePercent: 97,
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
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304414",
                        displayName: "The Latin Quarter",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 16,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013097",
                        displayName: "Women Of Piccolo",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883013089",
                        displayName: "Addio!",
                     altDisplayName: nil,
                      volumePercent: 126,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578676",
                        displayName: "Mummy's Tummy",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457542875",
                        displayName: "Rhythm",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457542865",
                        displayName: "Living With Rilakkuma",
                     altDisplayName: nil,
                      volumePercent: 132,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1518600730",
                        displayName: "And It Happened Like This",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482698915",
                        displayName: "Etiquette Lessons",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "158328526",
                        displayName: "Smee's Plan",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189836",
                        displayName: "A Sweet Smile",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1597810922",
                        displayName: "Four Iron Legs, Two Different Minds",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 66,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1598116878",
                        displayName: "A Day In Mondstadt",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "400623365",
                        displayName: "The Big Day",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709640675",
                        displayName: "Big Market",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "89286492",
                        displayName: "Gilderoy Lockhart",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1559225237",
                        displayName: "The Flourishing Past",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "469329898",
                        displayName: "Inumimi Ranka",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535606798",
                        displayName: "Welp, Didn't Expect That",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649510136",
                        displayName: "Melody Of Hidden Seeds",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1002478354",
                        displayName: "Fairies",
                     altDisplayName: nil,
                      volumePercent: 131,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1629006200",
                        displayName: "Kehaar's Theme",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666495784",
                        displayName: "Ariel's Footprints",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666499809",
                        displayName: "Sneaky & Mischievous",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1666496877",
                        displayName: "Cautious Explorers",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501059",
                        displayName: "Kodamas",
                     altDisplayName: nil,
                      volumePercent: 127,
                        startOffset: 0,
                          endOffset: 87,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1385168000",
                        displayName: "Is This Seat Taken?",
                     altDisplayName: nil,
                      volumePercent: 126,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1658416383",
                        displayName: "The Puzzle Box",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1687337702",
                        displayName: "Peculiar Encounter",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1717021834",
                        displayName: "Warawara",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1717012012",
                        displayName: "Treehopper",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498708112",
                        displayName: "An Unknown Land",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1552854764",
                        displayName: "Finding My Clamen",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883513494",
                        displayName: "Cleaning House",
                     altDisplayName: nil,
                      volumePercent: 115,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "882658782",
                        displayName: "Helping At The Bakery",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1725091338",
                        displayName: "Wake Up Boy!",
                     altDisplayName: nil,
                      volumePercent: 81,
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
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688781",
                        displayName: "Les Incas",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263826307",
                        displayName: "The Distant Days",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507141",
                        displayName: "Memories - The Storekeeper’s Advice",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 24,
                          endOffset: 98,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1451973356",
                        displayName: "Merry Go Round Of Life",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1495203872",
                        displayName: "They're Alive",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1369922096",
                        displayName: "Flaming Red Hair",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032054340",
                        displayName: "Evening In The Tavern",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502490",
                        displayName: "Drink Up, There's More!",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502550",
                        displayName: "Another Round For Everyone",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445882207",
                        displayName: "Two Hornpipes",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885285655",
                        displayName: "Town Jig",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502477",
                        displayName: "The Nightingale",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502487",
                        displayName: "Forged In Fire",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031934",
                        displayName: "A Watering Hole In The Harbor",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481512266",
                        displayName: "Tavern Music",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1746296271",
                        displayName: "Amber Ale",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1595923617",
                        displayName: "Pocket's Lookin' Light",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1595923621",
                        displayName: "Runnin' From Lariette",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502536",
                        displayName: "A Story You Won't Believe",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1495203991",
                        displayName: "Pretty Ballads Hide Bastard Truths",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879887",
                        displayName: "Tavern",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1626352394",
                        displayName: "Bulette Take The Liar",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649506038",
                        displayName: "Halcyon Times",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561048878",
                        displayName: "Farmer And The Fox",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561048887",
                        displayName: "Close To Board",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561049025",
                        displayName: "Quant'ay Lo Mon Consirat",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "469329468",
                        displayName: "HighSchoolLife",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1745066638",
                        displayName: "The Red Moon Inn",
                     altDisplayName: nil,
                      volumePercent: 134,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1490657048",
                        displayName: "Halling Efter Per Loof",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1490657049",
                        displayName: "Klockarpolskan Efter Elsa Siljebo",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1692982627",
                        displayName: "Finn's Boy",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1692982635",
                        displayName: "Beerzerk",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1725091096",
                        displayName: "The Boy With Green Hair",
                     altDisplayName: nil,
                      volumePercent: 60,
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
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 200,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "669578672",
                        displayName: "Ni No Kuni - Wrath Of The White Witch",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 78,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "883013108",
                        displayName: "Porco E Bella - Ending",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1545862130",
                        displayName: "A Hero's Theme",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "882407938",
                        displayName: "Laputa, Castle In The Sky",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 175,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1421238739",
                        displayName: "Three Hearts Afire",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507180",
                        displayName: "The End And The Beginning - Song Of Time (Theme Song) - Ending",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 432,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872756",
                        displayName: "Join My Owsla",
                     altDisplayName: nil,
                      volumePercent: 64,
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
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636140",
                        displayName: "Embrace Of Sea Waves",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568478",
                        displayName: "Gallant Challenge",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1309688431",
                        displayName: "L'aventure D'Esteban",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825349",
                        displayName: "Flynn Lives",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1131880963",
                        displayName: "Rebirth",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678660169",
                        displayName: "Victory",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440864386",
                        displayName: "The End",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1525730814",
                        displayName: "Oméga Orchestre",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1544402246",
                        displayName: "Town And Heart Beat",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1548347106",
                        displayName: "New Crew Member",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1548347451",
                        displayName: "Lifting Off The Ocean Floor",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519190035",
                        displayName: "Knighthood Excellence",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1639206061",
                        displayName: "Soar In The Wind",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1494288283",
                        displayName: "War Song Of Kings",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1629006194",
                        displayName: "Climbing The Down",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "41229180",
                        displayName: "Finale",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1571293955",
                        displayName: "Blackfin Triumphant",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1634929868",
                        displayName: "Revelation",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1634930956",
                        displayName: "Awakening Of Life",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "469356656",
                        displayName: "Vital Force",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "469329896",
                        displayName: "Test Flight Delight",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1662585586",
                        displayName: "Winding Through Avidya",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1668420573",
                        displayName: "Stepping On The Jade, Flying Above The Eaves",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "669578622",
                        displayName: "The Lead-Up To The Decisive Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501745",
                        displayName: "Reprise",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1518070703",
                        displayName: "Wings",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1682502332",
                        displayName: "Solace",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679419147",
                        displayName: "Fallen Foe",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "400623352",
                        displayName: "Words Win Wars",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1682509984",
                        displayName: "Never Forget",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640076968",
                        displayName: "Starbuck Disappears",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1691528537",
                        displayName: "Takeoff!",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1033194017",
                        displayName: "Golden Sun",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1579598903",
                        displayName: "Soul Love: Guitar To Orchestra Segue",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1579598646",
                        displayName: "Tema Principale: Orchestra Dedicata Ai Maestri",
                     altDisplayName: nil,
                      volumePercent: 60,
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
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295045",
                        displayName: "Ponyo’s Sisters",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295067",
                        displayName: "Ponyo's Sisters Lend A Hand",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: 94,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "785256928",
                        displayName: "The Falcon",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 75,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1656412489",
                        displayName: "I Am The Doctor",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825582",
                        displayName: "Outlands, Part II",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440663321",
                        displayName: "Guilty Of Being Innocent Of Being Jack Sparrow",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440654982",
                        displayName: "No Woman Has Ever Handled My Herschel",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885285639",
                        displayName: "Beyond The Darkness - Anthem From Earthsea",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502478",
                        displayName: "City Of Intrigues",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502486",
                        displayName: "Cloak And Dagger",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443203652",
                        displayName: "The Towering Inferno: Main Title",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443203665",
                        displayName: "The Towering Inferno: An Architect's Dream",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "158327948",
                        displayName: "Prologue",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1463898308",
                        displayName: "The Chase",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "269856904",
                        displayName: "Brave New World",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535610207",
                        displayName: "Charge! Fearless Warriors",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535611222",
                        displayName: "Riders Of The Wind, Onward",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585636140",
                        displayName: "Embrace Of Sea Waves",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538568478",
                        displayName: "Gallant Challenge",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519190020",
                        displayName: "Rite Of Battle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671739",
                        displayName: "Descent - Main Theme",
                     altDisplayName: nil,
                      volumePercent: 66,
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

        tracklist.add(Track(storeID: "1678659858",
                        displayName: "Years Of Training",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149506",
                        displayName: "A School Of Five Hundred",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1574617493",
                        displayName: "Links",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553230099",
                        displayName: "The Road Of Trials",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1506689320",
                        displayName: "She Requested It/Departing For Landing",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535606805",
                        displayName: "Make Haste, Partner",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1621817889",
                        displayName: "Darkstar",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "469329890",
                        displayName: "Transformation",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585875143",
                        displayName: "Journey To Trantor",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585875148",
                        displayName: "Over The Horizon",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263341728",
                        displayName: "Dung Defender",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1316656469",
                        displayName: "Darkest Of Kingdoms Part 2",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561297890",
                        displayName: "Butterflies",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498708413",
                        displayName: "ASIAN SYMPHONY 1. Dawn Of Asia",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1674442975",
                        displayName: "Illusions",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679417624",
                        displayName: "Dungeons And Dragons",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1687338176",
                        displayName: "Desert Chase",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460037830",
                        displayName: "The TCBS",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460038079",
                        displayName: "Helheimr",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860037",
                        displayName: "Jambalaya",
                     altDisplayName: nil,
                      volumePercent: 134,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "400623305",
                        displayName: "The Sun's Gone Wibbly",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640087426",
                        displayName: "Battle Royale",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1652582801",
                        displayName: "The Morning After",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1300076377",
                        displayName: "Surfing Dolphins",
                     altDisplayName: nil,
                      volumePercent: 66,
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
                      volumePercent: 90,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "883501063",
                        displayName: "Lady Eboshi",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501070",
                        displayName: "San And Ashitaka In The Forest Of The Deer God",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501203",
                        displayName: "Adagio Of Life And Death II",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 43,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "896588774",
                        displayName: "When I Held A Doll",
                     altDisplayName: nil,
                      volumePercent: 132,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885295054",
                        displayName: "Gran Mamare",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: 58,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "895667081",
                        displayName: "Fate",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440854728",
                        displayName: "The Landing",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: 93,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1150378579",
                        displayName: "Beginnings I",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378581",
                        displayName: "Beginnings II",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1150378588",
                        displayName: "The Garden",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "733966210",
                        displayName: "The Binding Of Isaac",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1291057018",
                        displayName: "Mesa",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: 115,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "570069183",
                        displayName: "Twin Souls",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533984915",
                        displayName: "S.T.A.Y.",
                     altDisplayName: nil,
                      volumePercent: 122,
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
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1127721318",
                        displayName: "Revelation",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501060",
                        displayName: "The Forest Of The Gods",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443890585",
                        displayName: "Love Theme",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: 86,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1553910464",
                        displayName: "Events In Dense Fog",
                     altDisplayName: nil,
                      volumePercent: 134,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553910712",
                        displayName: "Final Sunset",
                     altDisplayName: nil,
                      volumePercent: 113,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1653885382",
                        displayName: "Sacred Stones",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1451903521",
                        displayName: "The Healing Place",
                     altDisplayName: nil,
                      volumePercent: 67,
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

        tracklist.add(Track(storeID: "1521641808",
                        displayName: "But Still We Go On",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1373009957",
                        displayName: "Premonition",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: 426,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1373009959",
                        displayName: "Mutability",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: 402,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "971057962",
                        displayName: "Beyond",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440838789",
                        displayName: "The Search",
                     altDisplayName: nil,
                      volumePercent: 60,
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
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598299395",
                        displayName: "Over The Next Hill",
                     altDisplayName: nil,
                      volumePercent: 120,
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
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237192",
                        displayName: "Dusk Song Of The High Elves",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237445",
                        displayName: "Masque Of Reveries",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951317",
                        displayName: "Ancient Stones",
                     altDisplayName: nil,
                      volumePercent: 100,
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
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596952761",
                        displayName: "Sky Above, Voice Within",
                     altDisplayName: nil,
                      volumePercent: 99,
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
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876906",
                        displayName: "Mariner's Goodbye",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1463570498",
                        displayName: "Bacl2",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598302810",
                        displayName: "Peace Of Akatosh",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1495203992",
                        displayName: "Giltine The Artist",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1199914161",
                        displayName: "He Has To Go",
                     altDisplayName: nil,
                      volumePercent: 110,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675283565",
                        displayName: "Growling Bear's Vision",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284122",
                        displayName: "The Lakota, A Peaceful Nation",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284116",
                        displayName: "The Wheel And The Sunset",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675285940",
                        displayName: "Ghost Dance",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502484",
                        displayName: "Fate Calls",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538443",
                        displayName: "Beyond Hill And Dale...",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538452",
                        displayName: "Syanna",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1117538454",
                        displayName: "Lady Of The Lake",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872595",
                        displayName: "Allow Me To Take You To The Great Burrow",
                     altDisplayName: nil,
                      volumePercent: 140,
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
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "270186221",
                        displayName: "So Many New Worlds Revealed",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850344",
                        displayName: "Njól",
                     altDisplayName: nil,
                      volumePercent: 137,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1414850347",
                        displayName: "Jata",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031926",
                        displayName: "Dwarven Stone Upon Dwarven Stone",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031933",
                        displayName: "An Army Lying In Wait",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031941",
                        displayName: "Vergen By Night",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1032031943",
                        displayName: "A Quiet Corner",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1547583721",
                        displayName: "Gem In The Mountains",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1481514857",
                        displayName: "Thedas Love Theme",
                     altDisplayName: nil,
                      volumePercent: 133,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671745",
                        displayName: "Trespasser - Lost Elf Theme",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189839",
                        displayName: "A Storm, A Spire, And A Sanctum",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535607800",
                        displayName: "Whispering Plain",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535608140",
                        displayName: "Wayward Souls",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535608593",
                        displayName: "Awaiting The Future",
                     altDisplayName: nil,
                      volumePercent: 131,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535611222",
                        displayName: "Riders Of The Wind, Onward",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203275",
                        displayName: "Nott",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536203276",
                        displayName: "To The Next World",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1746295916",
                        displayName: "Reaper's Coast",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1746292950",
                        displayName: "Flight Of The Arora",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1485424843",
                        displayName: "Frozen Space",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533266364",
                        displayName: "Not What I Expected",
                     altDisplayName: nil,
                      volumePercent: 139,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500850216",
                        displayName: "Ori, Embracing The Light",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1538566945",
                        displayName: "Bird Call From Afar",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "445913519",
                        displayName: "Through The Woods",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: 104,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1585634895",
                        displayName: "Samurai's Sorrow",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585635014",
                        displayName: "Ones Who Strive To Live",
                     altDisplayName: nil,
                      volumePercent: 118,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1746296286",
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
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847631887",
                        displayName: "Omens In The Clouds",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640102223",
                        displayName: "The Crossroads Of The World",
                     altDisplayName: nil,
                      volumePercent: 110,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640106088",
                        displayName: "Altair And Darim",
                     altDisplayName: nil,
                      volumePercent: 132,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640106098",
                        displayName: "The Revelation",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640120176",
                        displayName: "HomeStead",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640121175",
                        displayName: "Temple Secrets",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640121576",
                        displayName: "What Came Before",
                     altDisplayName: nil,
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640149100",
                        displayName: "Winds Of Cyrene",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640149729",
                        displayName: "Nomads Of The White Desert",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457552641",
                        displayName: "Heal",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1457552644",
                        displayName: "Continue",
                     altDisplayName: nil,
                      volumePercent: 127,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004726",
                        displayName: "Encampment",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004742",
                        displayName: "Elmshore",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561004751",
                        displayName: "A New Act",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1370192787",
                        displayName: "Lullaby Of The Giants",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678659885",
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
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598200272",
                        displayName: "Who Did This To You?",
                     altDisplayName: nil,
                      volumePercent: 90,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598200293",
                        displayName: "Remembering Cintra",
                     altDisplayName: nil,
                      volumePercent: 134,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1757429875",
                        displayName: "Lover Stone",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1757429888",
                        displayName: "Ocean Hotel",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1598667763",
                        displayName: "Dawn Valley",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678706",
                        displayName: "GY Story",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1591678707",
                        displayName: "Butterfly",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442463185",
                        displayName: "Night Bird",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1062368475",
                        displayName: "Always",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1358149474",
                        displayName: "Stalactite Gallery",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1509086247",
                        displayName: "Is That What Everybody Wants",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825340",
                        displayName: "Solar Sailer",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714861225",
                        displayName: "An Ending",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 83,
                          endOffset: nil,
                             fadeIn: true,
                            fadeOut: false))

        tracklist.add(Track(storeID: "724437413",
                        displayName: "A Clearing",
                     altDisplayName: nil,
                      volumePercent: 94,
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

        tracklist.add(Track(storeID: "1358149508",
                        displayName: "Life Near The Surface",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "220242371",
                        displayName: "Ask The Mountains",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: 131,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "348595878",
                        displayName: "The Shape Of Things To Come",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883501738",
                        displayName: "The Sixth Station",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714899532",
                        displayName: "Voices",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "73327388",
                        displayName: "Damask Rose",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "73327386",
                        displayName: "Tales Of The Future",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440494309",
                        displayName: "Prophecy Theme",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1521542623",
                        displayName: "Tsushima Suite: V. Seiiki",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: 279,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1678660937",
                        displayName: "Another Day Rusts",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640102756",
                        displayName: "Byzantium",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1583651917",
                        displayName: "Ripples In The Sand",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482829883",
                        displayName: "Journey Sequence",
                     altDisplayName: nil,
                      volumePercent: 114,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482830257",
                        displayName: "The Rings Of Saturn",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482830268",
                        displayName: "Erbarme Dich",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596951313",
                        displayName: "From Past To Present",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618476648",
                        displayName: "In A Harmonious Atmosphere",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618476876",
                        displayName: "Stories Untold",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618482443",
                        displayName: "Evanescent Moments",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618483253",
                        displayName: "The Gaze Of The Ancients",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618484087",
                        displayName: "Now And Forevermore",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "862421072",
                        displayName: "Into The Darkness",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709641171",
                        displayName: "Arriving On Alpha",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1463541909",
                        displayName: "Mysterious Operation",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1630111859",
                        displayName: "Solitary Stray Bird",
                     altDisplayName: nil,
                      volumePercent: 138,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1548347108",
                        displayName: "System Searching",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585635601",
                        displayName: "Caress Of The Spirit",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472026480",
                        displayName: "Home",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472027158",
                        displayName: "LIMB Clinic",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472026046",
                        displayName: "Main Menu",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1472027183",
                        displayName: "Penthouse",
                     altDisplayName: nil,
                      volumePercent: 128,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879882",
                        displayName: "Teldrassil",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879888",
                        displayName: "Moonfall",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879890",
                        displayName: "Temple",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "288879892",
                        displayName: "Sacred",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "294991816",
                        displayName: "Crystalsong",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1629979082",
                        displayName: "Bioluminescent Ammonite",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640100138",
                        displayName: "The Secret Land Of Apollo",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640100829",
                        displayName: "Legendary Heirloom",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1664232779",
                        displayName: "Deep Shadows",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1394249906",
                        displayName: "Tending To Huey",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1442443553",
                        displayName: "The Kiss",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1550238998",
                        displayName: "Ice",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649505729",
                        displayName: "Those Lucid Dreams",
                     altDisplayName: nil,
                      volumePercent: 132,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649505723",
                        displayName: "Overnight Dew In The Woods",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649506598",
                        displayName: "Vigilant Minders",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649506918",
                        displayName: "Forest In The Light",
                     altDisplayName: nil,
                      volumePercent: 112,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649507005",
                        displayName: "Rustling Of Tender Foliage",
                     altDisplayName: nil,
                      volumePercent: 125,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649508460",
                        displayName: "Funneled Gorge",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649509228",
                        displayName: "Dust-Laden Recollections",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649509719",
                        displayName: "Beyond Klesha",
                     altDisplayName: nil,
                      volumePercent: 117,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649510126",
                        displayName: "Melody Of Sprouting Flowers",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649510145",
                        displayName: "Melody Of Dream Home",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649510965",
                        displayName: "Whispers Of Immensity",
                     altDisplayName: nil,
                      volumePercent: 118,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649510969",
                        displayName: "Immemorial Land",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649510971",
                        displayName: "In A Forgotten Tongue",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1002478349",
                        displayName: "Prologue",
                     altDisplayName: nil,
                      volumePercent: 131,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1629005914",
                        displayName: "Crossing The River And Onward",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1629006187",
                        displayName: "Through The Woods",
                     altDisplayName: nil,
                      volumePercent: 139,
                        startOffset: 0,
                          endOffset: 104,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "862421074",
                        displayName: "Crimson Leaves",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1142771956",
                        displayName: "Lamps",
                     altDisplayName: nil,
                      volumePercent: 108,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1142771953",
                        displayName: "One Blink For Yes",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553230095",
                        displayName: "First Confluence",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1553230107",
                        displayName: "The Crossing",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1652694839",
                        displayName: "City Beneath The Mountain",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1580020646",
                        displayName: "Death's Other Dominion - Ultima Thule",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1561048882",
                        displayName: "Huana",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585875141",
                        displayName: "The Only Story",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1585875144",
                        displayName: "The Imperial Library",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263341725",
                        displayName: "Reflection",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263341953",
                        displayName: "Dream",
                     altDisplayName: nil,
                      volumePercent: 126,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617833725",
                        displayName: "The Cloud",
                     altDisplayName: nil,
                      volumePercent: 118,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617834117",
                        displayName: "Inner Workings",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "596952416",
                        displayName: "Standing Stones",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1458800928",
                        displayName: "The Elves Of Old",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1458801538",
                        displayName: "Ancient Fragments",
                     altDisplayName: nil,
                      volumePercent: 120,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1517686629",
                        displayName: "Welcome Home",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1667156761",
                        displayName: "Spheres",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1454603882",
                        displayName: "Lakeside",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "896512379",
                        displayName: "MORI NO UTA",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1454327087",
                        displayName: "The Light",
                     altDisplayName: nil,
                      volumePercent: 135,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445188254",
                        displayName: "Fall From Grace",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675286205",
                        displayName: "After Wounded Knee",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1669477947",
                        displayName: "Vanquished",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1669477956",
                        displayName: "Courtyard",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679418146",
                        displayName: "Doric's Story",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679418835",
                        displayName: "Never Stop Failing",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859949",
                        displayName: "The Enclave",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859951",
                        displayName: "Old Friends",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859961",
                        displayName: "Reflections",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1682631586",
                        displayName: "Buried Mysteries",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1450859955",
                        displayName: "Haluk's Wisdom",
                     altDisplayName: nil,
                      volumePercent: 111,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1690849771",
                        displayName: "Within",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1690849768",
                        displayName: "Stars Above",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1687337821",
                        displayName: "Cave Mural",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1700991748",
                        displayName: "If You Look Down And See The Stars",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460037821",
                        displayName: "Dragons",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460037829",
                        displayName: "The Great War",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460037832",
                        displayName: "White As Bone",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1460038014",
                        displayName: "Other Sorts Of Scars",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1698938887",
                        displayName: "Foregone Depiction",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709634451",
                        displayName: "Searching For Clues",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709636183",
                        displayName: "Demain, Des L'aube",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1705382535",
                        displayName: "Quest For A Cure",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "400623301",
                        displayName: "Little Amy",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1473582362",
                        displayName: "Purr Of The Hunter",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640075777",
                        displayName: "Someone To Trust",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640076591",
                        displayName: "Kobol's Last Gleaming",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640076080",
                        displayName: "Epiphanies",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640076434",
                        displayName: "One Year Later",
                     altDisplayName: nil,
                      volumePercent: 95,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640076964",
                        displayName: "Goodbye Sam",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1682515359",
                        displayName: "Reverie",
                     altDisplayName: nil,
                      volumePercent: 127,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1697816352",
                        displayName: "Terrene Deliverance",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640085961",
                        displayName: "Welcome To The Brotherhood",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1650455235",
                        displayName: "Where's My Starpath Unit?",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1733328274",
                        displayName: "Flow State",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1701135232",
                        displayName: "A Life At The Bottom",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1729991067",
                        displayName: "Loch's Revitalization",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727671993",
                        displayName: "Phosphorus",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1116355303",
                        displayName: "Horizons",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1737208931",
                        displayName: "Guhua's Legacy",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1698939077",
                        displayName: "Dream Of White Branches",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709639402",
                        displayName: "Obscure Obsession",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1720031226",
                        displayName: "The Fields Of Asphodel",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1752850752",
                        displayName: "Polaris",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1636384042",
                        displayName: "Naru's Way",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1757720236",
                        displayName: "Shaman Village",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1758751146",
                        displayName: "To Dream's End",
                     altDisplayName: nil,
                      volumePercent: 63,
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
                      volumePercent: 113,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "785256920",
                        displayName: "Nahoko",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "885304412",
                        displayName: "Reminiscence",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667055",
                        displayName: "Memories Of The Village",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "895667080",
                        displayName: "Sorrow",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719241095",
                        displayName: "Gelt Dies",
                     altDisplayName: nil,
                      volumePercent: 140,
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
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "881802374",
                        displayName: "The Resurrection Of The Giant Warrior",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: 64,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "895667123",
                        displayName: "Moon",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: 103,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "403427801",
                        displayName: "Father And Son",
                     altDisplayName: nil,
                      volumePercent: 126,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1543825334",
                        displayName: "Adagio For TRON",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "714899528",
                        displayName: "A Paler Sky",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1654122410",
                        displayName: "The Appearance Of Colour",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: 420,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1291057991",
                        displayName: "Someone Lived This",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: 170,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "896588789",
                        displayName: "\"It's Like We Traded Places\"",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1062368749",
                        displayName: "The Very Air",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263828943",
                        displayName: "A Big Adventure",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "192058200",
                        displayName: "Another Time, Another Place: Flowers For Helena",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1421237449",
                        displayName: "Isles Of The Starry Dream",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326005525",
                        displayName: "Hinterlands",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326005912",
                        displayName: "The Brass Fortress",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1326006070",
                        displayName: "Hope Just Out Of Reach",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "847634015",
                        displayName: "Memories Of Yokuda Lost",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445876904",
                        displayName: "Balloon Flight",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507128",
                        displayName: "Signs Of Dusk",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1333502473",
                        displayName: "Spikeroog",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1199913534",
                        displayName: "The Girl",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1199913606",
                        displayName: "White Hair",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "883507154",
                        displayName: "Light And Shadow",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1440799961",
                        displayName: "Have You Got A Story For Me",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675284128",
                        displayName: "Gangrene",
                     altDisplayName: nil,
                      volumePercent: 87,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1477671745",
                        displayName: "Trespasser - Lost Elf Theme",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1519189860",
                        displayName: "Pure Sky",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535609141",
                        displayName: "Forlorn Child Of Archaic Winds",
                     altDisplayName: nil,
                      volumePercent: 104,
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
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1586681856",
                        displayName: "BB's Theme",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500836049",
                        displayName: "Death Of A'ba",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640119920",
                        displayName: "Farewell",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1485424718",
                        displayName: "Alone We Have No Future",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443719990",
                        displayName: "I Don't Remember",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "469331968",
                        displayName: "3cm",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263341955",
                        displayName: "White Palace",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1521542623",
                        displayName: "Tsushima Suite: V. Seiiki",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 279,
                          endOffset: 457,
                             fadeIn: true,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1598578191",
                        displayName: "Forget Me Knots",
                     altDisplayName: nil,
                      volumePercent: 60,
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
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618476889",
                        displayName: "What Now Remains",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618476901",
                        displayName: "Lonely Journey",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618477297",
                        displayName: "Swath Of Desolation",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618480787",
                        displayName: "When All Has Elapsed",
                     altDisplayName: nil,
                      volumePercent: 118,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618480796",
                        displayName: "Sorrows Of Strays",
                     altDisplayName: nil,
                      volumePercent: 73,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618483850",
                        displayName: "Drift Along The Lethe",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1618484092",
                        displayName: "At Dawn And Dusk",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1443109954",
                        displayName: "Pran's Theme 2",
                     altDisplayName: nil,
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1189857570",
                        displayName: "Life's End",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1535608789",
                        displayName: "A New Day With Hope",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649509233",
                        displayName: "Midnight Reflections",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872615",
                        displayName: "The Black Rabbit Of Inlé",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1446872751",
                        displayName: "They're Coming In From Above!",
                     altDisplayName: nil,
                      volumePercent: 101,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1030638664",
                        displayName: "Beautiful Mirage - An Unexpected Visitor",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1030638671",
                        displayName: "Disarmament",
                     altDisplayName: nil,
                      volumePercent: 109,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1641148935",
                        displayName: "Song Of Transference And End Credits",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "499880120",
                        displayName: "Leeloominai",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "499880126",
                        displayName: "Human Nature",
                     altDisplayName: nil,
                      volumePercent: 136,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1627033692",
                        displayName: "Remembering The Departed",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709642361",
                        displayName: "Bubble",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1599167840",
                        displayName: "Days",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1122403542",
                        displayName: "Kanashiki Senjyou",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1263341737",
                        displayName: "Resting Grounds",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "598302668",
                        displayName: "Auriel's Ascension",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1517686081",
                        displayName: "Ceremonial",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649508952",
                        displayName: "Whitewood Memorabilia",
                     altDisplayName: nil,
                      volumePercent: 114,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1445188268",
                        displayName: "The Toll Of War",
                     altDisplayName: nil,
                      volumePercent: 122,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1292988566",
                        displayName: "敗者",
                     altDisplayName: nil,
                      volumePercent: 107,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500829025",
                        displayName: "Rest In Peace Brother",
                     altDisplayName: nil,
                      volumePercent: 130,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1454603888",
                        displayName: "Wander's Death",
                     altDisplayName: nil,
                      volumePercent: 69,
                        startOffset: 0,
                          endOffset: 126,
                             fadeIn: false,
                            fadeOut: true))

        tracklist.add(Track(storeID: "1597811119",
                        displayName: "The Devil's Pass",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649510648",
                        displayName: "Long-Lost Chapters",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498708608",
                        displayName: "ASIAN SYMPHONY 4. Absolution",
                     altDisplayName: nil,
                      volumePercent: 124,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "675285956",
                        displayName: "Rations",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679418403",
                        displayName: "Swear To It",
                     altDisplayName: nil,
                      volumePercent: 114,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679419150",
                        displayName: "A Red Wizard's Blade",
                     altDisplayName: nil,
                      volumePercent: 108,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640078537",
                        displayName: "Poverty",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1682630407",
                        displayName: "The Crescent Moon's Waning",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1682629868",
                        displayName: "Oracle Of The Void",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1692606049",
                        displayName: "Boreal",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1500849629",
                        displayName: "Ash And Bone",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1687338166",
                        displayName: "Rakuen",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709634351",
                        displayName: "Where All Waters Converge",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1708475973",
                        displayName: "Daylight",
                     altDisplayName: nil,
                      volumePercent: 121,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640075383",
                        displayName: "Refugees Return",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640075783",
                        displayName: "Gentle Execution",
                     altDisplayName: nil,
                      volumePercent: 96,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640077079",
                        displayName: "The Passage Of Time",
                     altDisplayName: nil,
                      volumePercent: 89,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1697816540",
                        displayName: "Serene Stroll",
                     altDisplayName: nil,
                      volumePercent: 135,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640087690",
                        displayName: "Ou La Mort",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1713261061",
                        displayName: "Requiem For All Time",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1033194007",
                        displayName: "Orchestre",
                     altDisplayName: nil,
                      volumePercent: 82,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1650454673",
                        displayName: "The Night Before",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1650455269",
                        displayName: "Luthen Of Coruscant",
                     altDisplayName: nil,
                      volumePercent: 70,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498708225",
                        displayName: "A Solemn Vow",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1729667300",
                        displayName: "Starfall",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1725091391",
                        displayName: "Father And Son",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1730558902",
                        displayName: "Waterfalls",
                     altDisplayName: nil,
                      volumePercent: 75,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "655119119",
                        displayName: "All Gone",
                     altDisplayName: nil,
                      volumePercent: 85,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1725091385",
                        displayName: "No Way Home",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1752850755",
                        displayName: "Lodestar In Evernight",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1756555221",
                        displayName: "The Sorrow Of Farewell Spares None",
                     altDisplayName: nil,
                      volumePercent: 62,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1720031226",
                        displayName: "The Fields Of Asphodel",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1745059848",
                        displayName: "Aqueous Grief",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Evil - Background
    // =========================================================================
    //
    /// Add the `Valhalla Evil - Background` static Tracklist.
    ///
    private func addValhallaEvilBackground()
    {
        let tracklist = self.add(id: "valhalla-evil-background",
                        displayName: "Valhalla Evil - Background",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "1554011549",
                        displayName: "Another Failure",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1554011552",
                        displayName: "At Peace",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1638178810",
                        displayName: "Black Dove",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1638178813",
                        displayName: "Shifting Sands",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1539736902",
                        displayName: "How To Be Eaten By A Woman",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1539736904",
                        displayName: "A Dream Within A Dream",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1539737042",
                        displayName: "Starve The Ego, Feed The Soul",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431327",
                        displayName: "Moment Of Calm",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431531",
                        displayName: "Warcry",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536058576",
                        displayName: "Cue #1 – Variation On Logos #1",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536058579",
                        displayName: "Cue #2 – Variation On Horizon #1",
                     altDisplayName: nil,
                      volumePercent: 133,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536058588",
                        displayName: "Cue #3 – The Soldier #1",
                     altDisplayName: nil,
                      volumePercent: 128,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536058808",
                        displayName: "Cue #6 – The Soldier #2",
                     altDisplayName: nil,
                      volumePercent: 118,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702859944",
                        displayName: "How Much Do You Remember",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860021",
                        displayName: "Clandestine Activities",
                     altDisplayName: nil,
                      volumePercent: 137,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860024",
                        displayName: "When The Dust Settles",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137630",
                        displayName: "The Resonant Canyon",
                     altDisplayName: nil,
                      volumePercent: 105,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702515833",
                        displayName: "Creeping Closer",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719948320",
                        displayName: "Echoes Of Us",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Evil - Battle
    // =========================================================================
    //
    /// Add the `Valhalla Evil - Battle` static Tracklist.
    ///
    private func addValhallaEvilBattle()
    {
        let tracklist = self.add(id: "valhalla-evil-battle",
                        displayName: "Valhalla Evil - Battle",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "1533949709",
                        displayName: "Wind",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949711",
                        displayName: "Race",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949713",
                        displayName: "Drivecraft",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949902",
                        displayName: "Cool And Dangerous",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949907",
                        displayName: "Sprint",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949908",
                        displayName: "Patience And Determination",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949913",
                        displayName: "Full Throttle",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949924",
                        displayName: "Group B",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1605200444",
                        displayName: "War Rig",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1605200446",
                        displayName: "Mirage",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562499360",
                        displayName: "Fury",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562499576",
                        displayName: "Hunting Grounds",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1581055374",
                        displayName: "Station X",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1638178808",
                        displayName: "Canyons",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1638178811",
                        displayName: "Before Dawn",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1532313879",
                        displayName: "Deep Blue",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431324",
                        displayName: "Blood Dragon Theme",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431538",
                        displayName: "Resurrection",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482151595",
                        displayName: "Battle For Supremacy",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1568861042",
                        displayName: "Mainframe",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679418509",
                        displayName: "The Ruckus",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1686269858",
                        displayName: "Virtual Skyglow",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1689851273",
                        displayName: "Cyber Heist",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1697975469",
                        displayName: "Omni",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1704924474",
                        displayName: "On The Streets",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1699747826",
                        displayName: "Full Speed",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1700478382",
                        displayName: "Full Speed",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1671897161",
                        displayName: "The Chase",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1640272940",
                        displayName: "Florence Rooftops",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1747547310",
                        displayName: "Rockwell's Proliferation II",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1697815802",
                        displayName: "Blade Abracadabra",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1715819189",
                        displayName: "Thrasher",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1720062826",
                        displayName: "Digital Horizon",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727446158",
                        displayName: "Left The Stove On",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727446172",
                        displayName: "Taxi!",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1631819979",
                        displayName: "EPICA",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719927614",
                        displayName: "Silicon 93",
                     altDisplayName: nil,
                      volumePercent: 139,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727673350",
                        displayName: "Detonation",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1523962911",
                        displayName: "12 To Midnight",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1756789649",
                        displayName: "Nyctophile",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1758156063",
                        displayName: "Will Of The Sword",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Evil - Failure
    // =========================================================================
    //
    /// Add the `Valhalla Evil - Failure` static Tracklist.
    ///
    private func addValhallaEvilFailure()
    {
        let tracklist = self.add(id: "valhalla-evil-failure",
                        displayName: "Valhalla Evil - Failure",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "valhalla-evil-background")

        tracklist.add(Track(storeID: "1533949896",
                        displayName: "Dance With Death",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949922",
                        displayName: "Explosion",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562499578",
                        displayName: "Outcome",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1523937034",
                        displayName: "Moving Mountains",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1532313878",
                        displayName: "Brooklyn",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431536",
                        displayName: "Death Of A Cyborg",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1660767883",
                        displayName: "New York",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1661635116",
                        displayName: "Where The Sun Sets",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "380350137",
                        displayName: "Dream Is Collapsing",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "691264363",
                        displayName: "Ruined Landscape",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702516024",
                        displayName: "Infant Epiphany",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1713086315",
                        displayName: "Shadows Of Doubt",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1523962914",
                        displayName: "100 Miles Away",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1646521621",
                        displayName: "Electric Storm",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Evil - Twisted
    // =========================================================================
    //
    /// Add the `Valhalla Evil - Twisted` static Tracklist.
    ///
    private func addValhallaEvilTwisted()
    {
        let tracklist = self.add(id: "valhalla-evil-twisted",
                        displayName: "Valhalla Evil - Twisted",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "valhalla-evil-battle")

        tracklist.add(Track(storeID: "1094501232",
                        displayName: "Vile World",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431371",
                        displayName: "Protektor",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1689851275",
                        displayName: "Next Gen Swag",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702859946",
                        displayName: "Access To The System",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1720512564",
                        displayName: "Abyss Lane",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1646521614",
                        displayName: "Consensual Hallucination",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Good - Background
    // =========================================================================
    //
    /// Add the `Valhalla Good - Background` static Tracklist.
    ///
    private func addValhallaGoodBackground()
    {
        let tracklist = self.add(id: "valhalla-good-background",
                        displayName: "Valhalla Good - Background",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "1758758556",
                        displayName: "Youth",
                     altDisplayName: nil,
                      volumePercent: 99,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1554011547",
                        displayName: "Biding Time",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1539737035",
                        displayName: "Drive It Like You Stole It",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1645976375",
                        displayName: "The Remedy",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431529",
                        displayName: "Sleeping Dragon",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1659877547",
                        displayName: "Lake Serenity",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562332640",
                        displayName: "The Drummer",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562332647",
                        displayName: "Human",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482151611",
                        displayName: "Spatial Lullaby",
                     altDisplayName: nil,
                      volumePercent: 79,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1654331822",
                        displayName: "Marimba",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "691264813",
                        displayName: "The Auryn",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1710119536",
                        displayName: "City Lights",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702859940",
                        displayName: "Welcome To Neon Noodles",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137626",
                        displayName: "Seeds Of The Crown",
                     altDisplayName: nil,
                      volumePercent: 88,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137636",
                        displayName: "Cascades",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137640",
                        displayName: "A Chorus Of Tongues",
                     altDisplayName: nil,
                      volumePercent: 104,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1710181758",
                        displayName: "Alchemy",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1714978315",
                        displayName: "Daydream",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727445766",
                        displayName: "EOD",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727446168",
                        displayName: "Sick Day",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727671971",
                        displayName: "Peace Forever",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1752850748",
                        displayName: "Nought May Endure But Mutability",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1753634673",
                        displayName: "Midnight",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1759130722",
                        displayName: "Patches Of Sunlight",
                     altDisplayName: nil,
                      volumePercent: 92,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762566946",
                        displayName: "To The Golden Willow",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762566942",
                        displayName: "Fire In The Mountains",
                     altDisplayName: nil,
                      volumePercent: 61,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762566948",
                        displayName: "Bridge Of The Horned Ones",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1764821119",
                        displayName: "Hoshizora",
                     altDisplayName: nil,
                      volumePercent: 64,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Good - Quirky
    // =========================================================================
    //
    /// Add the `Valhalla Good - Quirky` static Tracklist.
    ///
    private func addValhallaGoodQuirky()
    {
        let tracklist = self.add(id: "valhalla-good-quirky",
                        displayName: "Valhalla Good - Quirky",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "valhalla-good-background")

        tracklist.add(Track(storeID: "1654331822",
                        displayName: "Marimba",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727446074",
                        displayName: "Snowplow",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Good - Tavern
    // =========================================================================
    //
    /// Add the `Valhalla Good - Tavern` static Tracklist.
    ///
    private func addValhallaGoodTavern()
    {
        let tracklist = self.add(id: "valhalla-good-tavern",
                        displayName: "Valhalla Good - Tavern",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "valhalla-good-background")

        tracklist.add(Track(storeID: "1649038387",
                        displayName: "Brooklyn. Friday. Love.",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1652694836",
                        displayName: "Bobbit's Path",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Valhalla Good - Victory
    // =========================================================================
    //
    /// Add the `Valhalla Good - Victory` static Tracklist.
    ///
    private func addValhallaGoodVictory()
    {
        let tracklist = self.add(id: "valhalla-good-victory",
                        displayName: "Valhalla Good - Victory",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: "any-valhalla-magic-and-mystery")

        tracklist.add(Track(storeID: "1533949936",
                        displayName: "Game Over",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1758759578",
                        displayName: "Los Angeles",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1144974098",
                        displayName: "Memories",
                     altDisplayName: nil,
                      volumePercent: 63,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1581055381",
                        displayName: "Here On Earth",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1638178877",
                        displayName: "All This Time",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1153352184",
                        displayName: "Starchaser",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "691264359",
                        displayName: "Ivory Tower",
                     altDisplayName: nil,
                      volumePercent: 68,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1710181559",
                        displayName: "I Miss Daft Punk",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1693636864",
                        displayName: "Vic Viper",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1714862553",
                        displayName: "Subspace",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1721769096",
                        displayName: "End Credits",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1697975469",
                        displayName: "Omni",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1716589536",
                        displayName: "Purpose Is Glorious",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498699567",
                        displayName: "KIDS RETURN",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1759693351",
                        displayName: "Low Performance Audio",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Any - Valhalla Hurry!
    // =========================================================================
    //
    /// Add the `Any - Valhalla Hurry!` static Tracklist.
    ///
    private func addAnyValhallaHurry()
    {
        let tracklist = self.add(id: "any-valhalla-hurry",
                        displayName: "Any - Valhalla Hurry!",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "1533949708",
                        displayName: "The Perfect Corner",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949904",
                        displayName: "Challenge",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949928",
                        displayName: "Remember Me",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1533949931",
                        displayName: "Triumph",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1144973776",
                        displayName: "Sunset",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1144973945",
                        displayName: "Jason",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649038394",
                        displayName: "Change Your Heart Or Die",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649216556",
                        displayName: "Above The Clouds",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562332652",
                        displayName: "Train To Dresden",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1568861028",
                        displayName: "Subduction",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860020",
                        displayName: "Pre-Collapse Culinary Dishes",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1707735176",
                        displayName: "Downtown",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702516142",
                        displayName: "VCR Bug",
                     altDisplayName: nil,
                      volumePercent: 81,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702516848",
                        displayName: "Sinister Journey",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1704176705",
                        displayName: "Cosmic Gate",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1747547306",
                        displayName: "Team Downriver Run",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1718835219",
                        displayName: "Vertical Drop",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1722084966",
                        displayName: "To You",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1725042665",
                        displayName: "Liminal Space",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727403603",
                        displayName: "Horizon Chase",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1740176567",
                        displayName: "Again And Again",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1742714312",
                        displayName: "Sky City",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1749896449",
                        displayName: "Last Night",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1759693350",
                        displayName: "High Performance Audio",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1748370988",
                        displayName: "In The Wires",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Any - Valhalla Magic & Mystery
    // =========================================================================
    //
    /// Add the `Any - Valhalla Magic & Mystery` static Tracklist.
    ///
    private func addAnyValhallaMagicAndMystery()
    {
        let tracklist = self.add(id: "any-valhalla-magic-and-mystery",
                        displayName: "Any - Valhalla Magic & Mystery",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "1562499358",
                        displayName: "State Of Balance",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562499361",
                        displayName: "The Pines",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562499364",
                        displayName: "Night Falls",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562499577",
                        displayName: "Sunrise, Sunset",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1581055378",
                        displayName: "Ritual",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1554011551",
                        displayName: "Malgam",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679239082",
                        displayName: "Runner",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679239083",
                        displayName: "Detach / Adrift",
                     altDisplayName: nil,
                      volumePercent: 65,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1679239084",
                        displayName: "Embrace",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1539736322",
                        displayName: "Animus Vox",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1539736984",
                        displayName: "Between Two Points",
                     altDisplayName: nil,
                      volumePercent: 86,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1539737029",
                        displayName: "We Swarm",
                     altDisplayName: nil,
                      volumePercent: 76,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1642434520",
                        displayName: "A Rounded Pyramid",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1562332639",
                        displayName: "Northern Lights",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482151602",
                        displayName: "Gravitational Constant",
                     altDisplayName: nil,
                      volumePercent: 104,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1482151598",
                        displayName: "Distant Nebula",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1536058813",
                        displayName: "Cue #8 – The Soldier #4",
                     altDisplayName: nil,
                      volumePercent: 100,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1674263247",
                        displayName: "Depiction",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "691264366",
                        displayName: "Fantasia",
                     altDisplayName: nil,
                      volumePercent: 115,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1692621962",
                        displayName: "Event Horizon",
                     altDisplayName: nil,
                      volumePercent: 110,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617691219",
                        displayName: "Verdigris",
                     altDisplayName: nil,
                      volumePercent: 94,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1617691221",
                        displayName: "A Western Surface",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702859941",
                        displayName: "First Day Orientation",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702859942",
                        displayName: "Training Cycles",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702859950",
                        displayName: "Reclaim Your Legacy",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860022",
                        displayName: "The Spire",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702860032",
                        displayName: "My Personal Chef",
                     altDisplayName: nil,
                      volumePercent: 140,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137634",
                        displayName: "Flock",
                     altDisplayName: nil,
                      volumePercent: 80,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137624",
                        displayName: "Titan",
                     altDisplayName: nil,
                      volumePercent: 83,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1105137628",
                        displayName: "The Midnight Wood",
                     altDisplayName: nil,
                      volumePercent: 102,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1709634465",
                        displayName: "Deductive Rendition",
                     altDisplayName: nil,
                      volumePercent: 71,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1702515839",
                        displayName: "Pacy Investigations",
                     altDisplayName: nil,
                      volumePercent: 97,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1717829381",
                        displayName: "Noah's Theme",
                     altDisplayName: nil,
                      volumePercent: 78,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1701135232",
                        displayName: "A Life At The Bottom",
                     altDisplayName: nil,
                      volumePercent: 66,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1498699470",
                        displayName: "DESTINY",
                     altDisplayName: nil,
                      volumePercent: 116,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1727446096",
                        displayName: "Are You Happy Jane?",
                     altDisplayName: nil,
                      volumePercent: 67,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1720173942",
                        displayName: "Iko's Odyssey",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1523962906",
                        displayName: "Out Of Time",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1743466144",
                        displayName: "Iterations",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1752249411",
                        displayName: "Lightspeed",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1749914926",
                        displayName: "Northbound",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1759131196",
                        displayName: "Everlasting Promise",
                     altDisplayName: nil,
                      volumePercent: 108,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1678731716",
                        displayName: "A Memory Of Hope",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762566941",
                        displayName: "And Yet Another Journey Begins",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762566943",
                        displayName: "Sailing Down The Lily River",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762566944",
                        displayName: "The Royal Harbor",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762566948",
                        displayName: "Bridge Of The Horned Ones",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762567249",
                        displayName: "Ancient Sacrifice",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1762567250",
                        displayName: "How It All Ended",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1745059866",
                        displayName: "Dissolved Dawn",
                     altDisplayName: nil,
                      volumePercent: 93,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1499350340",
                        displayName: "Sea Of Tranquility, Part 3",
                     altDisplayName: nil,
                      volumePercent: 77,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }

    // =========================================================================
    // Any - Valhalla Sorrow
    // =========================================================================
    //
    /// Add the `Any - Valhalla Sorrow` static Tracklist.
    ///
    private func addAnyValhallaSorrow()
    {
        let tracklist = self.add(id: "any-valhalla-sorrow",
                        displayName: "Any - Valhalla Sorrow",
                            version: 2,
                      volumePercent: 100,
                    autoSwitchAfter: nil)

        tracklist.add(Track(storeID: "1649038487",
                        displayName: "Photograph",
                     altDisplayName: nil,
                      volumePercent: 103,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "636431534",
                        displayName: "Cyber Commando",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1649511769",
                        displayName: "A Sense Of Furtive Unrest",
                     altDisplayName: nil,
                      volumePercent: 137,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1670557647",
                        displayName: "Void",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "691264368",
                        displayName: "Theme Of Sadness",
                     altDisplayName: nil,
                      volumePercent: 98,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1704137846",
                        displayName: "Lemniscate",
                     altDisplayName: nil,
                      volumePercent: 60,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1627033692",
                        displayName: "Remembering The Departed",
                     altDisplayName: nil,
                      volumePercent: 91,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1729667300",
                        displayName: "Starfall",
                     altDisplayName: nil,
                      volumePercent: 74,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))

        tracklist.add(Track(storeID: "1719928415",
                        displayName: "Leave Without Me",
                     altDisplayName: nil,
                      volumePercent: 72,
                        startOffset: 0,
                          endOffset: nil,
                             fadeIn: false,
                            fadeOut: false))
    }
}
