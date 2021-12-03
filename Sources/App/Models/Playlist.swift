//
//  Playlist.swift
//  App
//
//  Created by Laura Crosby on 11/18/21.
//

import Vapor
import FluentPostgreSQL

/// A single entry of a User list.
final class Playlist: PostgreSQLModel {
    typealias Database = PostgreSQLDatabase
    
    /// The unique identifier for this `Playlist`.
    var id: Int?

    /// A title describing what this `Playlist` entails.
    var name: String
    
    var description: String

    /// Creates a new `Playlist`.
    init(id: Int? = nil, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
}

/// Allows `Playlist` to be encoded to and decoded from HTTP messages.
extension Playlist: Content { }

/// Allows `Playlist` to be used as a dynamic parameter in route definitions.
extension Playlist: Parameter { }
