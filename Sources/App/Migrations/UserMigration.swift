import Vapor
import FluentPostgreSQL

/// Allows `User` to be used as a dynamic migration.
extension User: Migration { }

extension Playlist: Migration { }

extension PlaylistSong: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(self, on: conn) { builder in
            
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.releaseId, type: PostgreSQLDataType.int)

            builder.field(for: \.playlistId)
            builder.reference(from: \.playlistId, to: \Playlist.id,
                onUpdate: nil,
                onDelete: .cascade)
        }
    }
}
