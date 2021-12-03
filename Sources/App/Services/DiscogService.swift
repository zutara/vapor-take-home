import Vapor

struct DiscogService: ArtistService {
    private let searchURL = "https://api.discogs.com/"

    private let headers: HTTPHeaders = [
        "Authorization": "Discogs token=\(Environment.apiToken)"
    ]

    func searchArtist(artist: String, on req: Request) throws -> Future<[Artist]> {
        var components = URLComponents(string: searchURL + "database/search")
        components?.queryItems = [URLQueryItem(name: "q", value: artist)]

        guard let url = components?.url else {
            fatalError("Couldn't create search URL")
        }

        return try req.client().get(url, headers: headers).flatMap({ response in
            return try response.content.decode(ArtistSearchResponse.self).flatMap({ artistSearch in
                return req.future(artistSearch.results)
            })
        })
    }
    
    func searchSongByArtist(artistId: Int, songName: String, on req: Request) throws -> Future<[Song]> {
        let components = URLComponents(string: searchURL + "artists/" + String(artistId) + "/releases")

        guard let url = components?.url else {
            fatalError("Couldn't create search URL")
        }
        
        /// fuzzy search mapping for song name search -> i think the case insensitive is important, but if we want it to be true string matching that is also valid
        return try req.client().get(url, headers: headers).flatMap({ response in
            return try response.content.decode(ArtistSongSearchResponse.self).flatMap({ songSearch in
                return req.future(songSearch.releases.filter({ song in song.title.localizedCaseInsensitiveContains(songName) }))
            })
        })
    }
    
    func searchSongById(songId: Int, on req: Request) throws -> Future<SongSearchResponse> {
        let components = URLComponents(string: searchURL + "releases/" + String(songId))

        guard let url = components?.url else {
            fatalError("Couldn't create search URL")
        }
        
        return try req.client().get(url, headers: headers).flatMap({ response in
            return try response.content.decode(SongSearchResponse.self).flatMap({ songSearch in
                return req.future(songSearch)
            })
        })
    }
}
