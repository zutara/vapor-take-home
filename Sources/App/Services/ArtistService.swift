import Foundation
import Vapor

protocol ArtistService: Service {
    func searchArtist(artist: String, on req: Request) throws -> Future<[Artist]>
    func searchSongByArtist(artistId: Int, songName: String, on req: Request) throws -> Future<[Song]>
    
    func searchSongById(songId: Int, on req: Request) throws -> Future<SongSearchResponse>

}
