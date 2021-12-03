//
//  PlaylistSong.swift
//  App
//
//  Created by Laura Crosby on 11/22/21.
//

import Vapor
import FluentPostgreSQL

/// A single entry of a User list.
final class PlaylistSong: PostgreSQLModel {
    typealias Database = PostgreSQLDatabase
    
    /// The unique identifier for this `PlaylistSong`.
    var id: Int?

    /// A title describing what this `PlaylistSong` entails.
    var releaseId: Int?
    
    var playlistId: Int
    var playlist: Parent<PlaylistSong, Playlist> {
        return parent(\.playlistId)
    }

    /// Creates a new `PlaylistSong`.
    init(id: Int? = nil, releaseId: Int? = nil, playlistId: Int) {
        self.id = id
        self.releaseId = releaseId
        self.playlistId = playlistId
    }

    enum CodingKeys: String, CodingKey {
        case id
        case releaseId
        case playlistId
    }
}

/// Allows `PlaylistSong` to be encoded to and decoded from HTTP messages.
extension PlaylistSong: Content { }

/// Allows `PlaylistSong` to be used as a dynamic parameter in route definitions.
extension PlaylistSong: Parameter { }
