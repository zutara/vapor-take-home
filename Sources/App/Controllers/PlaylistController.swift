//
//  PlaylistController.swift
//  App
//
//  Created by Laura Crosby on 11/17/21.
//

import Vapor
import Fluent

final class PlaylistController {
    
    func create(_ req: Request) throws -> Future<DisPlaylist> {
        let newPlaylist = try req.content.decode(Playlist.self).flatMap { playlist in
            return playlist.save(on: req)
        }
        return newPlaylist.map { playlist in
            return DisPlaylist(id: playlist.id ?? -1, name: playlist.name, description: playlist.description, songs: [])
        }
    }
    
    func fetch(_ req: Request) throws -> Future<[DisPlaylist]> {
        let playlists: EventLoopFuture<[Playlist]> = Playlist.query(on: req).all()
        let convertedDisplaylists = playlists.map { playlists in
            return try playlists.map { playlist -> EventLoopFuture<DisPlaylist> in
                return try self.convertPlayList(playlist: playlist, req: req)
            }
        }
        
        let converted = convertedDisplaylists.flatMap { displaylists in
            displaylists.flatten(on: req)
        }
        
        return converted
    }
    
    func findById(_ req: Request) throws -> Future<DisPlaylist> {
        
        let playlistToConvert = try req.parameters.next(Playlist.self).flatMap { playlist in
            return req.future(playlist)
        }
        
        let newDisplaylist = playlistToConvert.map { playlist -> EventLoopFuture<DisPlaylist> in
            return try self.convertPlayList(playlist: playlist, req: req)
        }.flatMap { flatList in
            return flatList
        }
        
        return newDisplaylist
    }
    
    func update(_ req: Request) throws -> Future<DisPlaylist> {
        let updatedplaylist = try req.parameters.next(Playlist.self).flatMap({ playlist -> EventLoopFuture<Playlist> in
            return try req.content.decode(Playlist.self).flatMap { updatedPlaylist -> EventLoopFuture<Playlist> in
                playlist.name = updatedPlaylist.name
                playlist.description = updatedPlaylist.description
                return playlist.update(on: req)
            }
        })
        
        let newDisplaylist = updatedplaylist.map { playlist -> EventLoopFuture<DisPlaylist> in
            return try self.convertPlayList(playlist: playlist, req: req)
        }.flatMap { flatList in
            return flatList
        }
        
        return newDisplaylist
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Playlist.self).flatMap { playlist in
            return playlist.delete(on: req)
        }.transform(to: .noContent)
    }

    func addSong(_ req: Request) throws -> Future<PlaylistSong> {
        let playlistId = try req.parameters.next(Int.self)
        let songId = try req.parameters.next(Int.self)
        let playlistSong = PlaylistSong.init(id: nil, releaseId: songId, playlistId: playlistId)
        return playlistSong.save(on: req)
    }
    
    //TODO remove song from playlist
    func deleteSong(_ req: Request) throws -> Future<HTTPStatus> {
        let playlistId = try req.parameters.next(Int.self)
        let songId = try req.parameters.next(Int.self)
        let songToDelete = PlaylistSong.query(on: req).filter(\.playlistId == playlistId).filter(\.releaseId == songId)
        return songToDelete.delete().transform(to: .noContent)
    }
    
    
    
    // ------- extra things
    func convertPlayList(playlist: Playlist, req: Request) throws -> Future<DisPlaylist> {
        let service: ArtistService = try req.make(ArtistService.self)

        let playlistSongs =  PlaylistSong.query(on: req).filter(\.playlistId == playlist.id!).all()
        let x = playlistSongs.flatMap { playlistSongs -> EventLoopFuture<[SongSearchResponse]> in
            let songsInPlaylist: [EventLoopFuture<SongSearchResponse>] = try playlistSongs.map { pSong -> EventLoopFuture<SongSearchResponse> in
                let foundSong: EventLoopFuture<SongSearchResponse> = try service.searchSongById(songId: pSong.releaseId!, on: req)
                return foundSong
            }
            return songsInPlaylist.flatten(on: req)
        }
        
        let displayLists = x.map { playlistSongs in
            return DisPlaylist(
                id: playlist.id!,
                name: playlist.name,
                description: playlist.description,
                songs: playlistSongs.map {
                    song -> Song in
                    return Song.init(id: song.id, mainRelease: nil, title: song.title)
                } // playlistSongs
                )
        }
        
        return displayLists
    }
    
    ///  searches song by song id
    func searchSongById(_ req: Request) throws -> Future<SongSearchResponse> {
        let songId = try req.parameters.next(Int.self)
        let service = try req.make(ArtistService.self)
        return try service.searchSongById(songId: songId, on: req)
    }
}
