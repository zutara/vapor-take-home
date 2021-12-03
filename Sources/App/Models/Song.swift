//
//  Song.swift
//  App
//
//  Created by Laura Crosby on 11/18/21.
//

import Vapor

struct Song: Codable {
    let id: Int
    let mainRelease: Int?
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case mainRelease = "main_release"
        case title
    }
}

/// Allows `Song` to be encoded to and decoded from HTTP messages.
extension Song: Content { }
