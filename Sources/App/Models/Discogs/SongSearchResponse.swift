//
//  SongSearchResponse.swift
//  App
//
//  Created by Laura Crosby on 12/1/21.
//

import Vapor

struct SongSearchResponse: Decodable {
    let id: Int
    let title: String
}

extension SongSearchResponse: Content { }
