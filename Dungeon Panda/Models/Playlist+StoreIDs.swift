//
//  Playlist+StoreIDs.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 23/03/21.
//

import Foundation

/**
 An adaptation of https://stackoverflow.com/a/50515075/ arising because XCode's code generator did
 not like letting me use a Transformable value in the Core Data model with a custom type of `Array`. Build errors
 arose. This is most likely because of the necessity to keep things compatible with the iCloud storage layer.
*/
extension Playlist
{
    var storeIDs: [String]
    {
        set(storeIDs)
        {
            // The "description" call literally just returns a JSON-like string
            // representing the array - very useful!
            //
            self.encodedStoreIDs = storeIDs.description
        }

        get
        {
            let encodedStoreIDsAsData = self.encodedStoreIDs!.data(using: String.Encoding.utf8)
            let decodedStoreIDs: [String] = try! JSONDecoder().decode([String].self, from: encodedStoreIDsAsData!)

            return decodedStoreIDs
        }
    }
}
