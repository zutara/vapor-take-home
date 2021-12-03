import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    // Basic "Hello Universe" example
    router.get { req in
        return "Hello Universe"
    }

    // Example of configuring a controller
    let userController = UserController()
    router.post("users", use: userController.create)
    router.get("users", User.parameter, use: userController.find)
    router.get("users", use: userController.index)
    router.put("users", User.parameter, use: userController.update)
    router.delete("users", User.parameter, use: userController.delete)

    let artistController = ArtistController()
    router.get("artists/search", use: artistController.searchArtist)
    router.get("artists", Int.parameter, "songs/search", use: artistController.searchArtistSongById)
    
    
    let playlistController = PlaylistController()
    // Had to change the route here because doesn't look like vapor 3 wants to work with same route registration
    router.delete("playlists/deleteSong", Int.parameter, "songs", Int.parameter, use: playlistController.deleteSong)
    router.post("playlists", use: playlistController.create)
    router.get("playlists", use: playlistController.fetch)
    router.get("playlists", Playlist.parameter, use: playlistController.findById)
    router.put("playlists", Playlist.parameter, use: playlistController.update)
    router.delete("playlists", Playlist.parameter, use: playlistController.delete)
    router.post("playlists", Int.parameter, "songs", Int.parameter, use: playlistController.addSong)
    
    
    router.get("song", Int.parameter, use: playlistController.searchSongById)

}
