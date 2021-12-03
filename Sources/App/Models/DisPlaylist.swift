//
//  DisPlaylist.swift
//  App
//
//  Created by Laura Crosby on 11/30/21.
//

import Vapor

struct DisPlaylist: Content {
    /// The unique identifier for this `Playlist`.
    var id: Int

    /// A title describing what this `Playlist` entails.
    var name: String
    
    var description: String
    let songs: [Song]
}
