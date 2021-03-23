//
//  MiscError.swift
//  Dungeon Panda
//
//  Created by Andrew Hodgkinson on 19/03/21.
//

import Foundation

/**
 Encapsulate details of miscellaneous error conditions.
*/
struct MiscError: Error
{
    enum ErrorKind
    {
        case appleMusic
    }

    let kind: ErrorKind
    let message: String
}
