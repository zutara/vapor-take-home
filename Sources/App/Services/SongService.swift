//
//  SongService.swift
//  App
//
//  Created by Laura Crosby on 11/19/21.
//

import Foundation
import Vapor

protocol SongService: Service {
    func searchSongById(songId: Int, on req: Request) throws -> Future<[Song]>
}
