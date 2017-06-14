import Vapor
import Fluent
import Foundation

final class GameRound: Model {

    fileprivate struct FieldName {
        static let id = "id"
        static let gameId = "game_id"
        static let active = "active"
    }

    static var entity = "rounds"

    var id: Node?
    var gameId: Int
    var active: Int

    init(gameId: Int) {
        self.id = nil
        self.gameId = gameId
        self.active = 1
    }

    init(node: Node, in context: Context) throws {
        id = node
        gameId = try node.extract(FieldName.gameId)
        active = try node.extract(FieldName.active)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            FieldName.id        : id,
            FieldName.gameId    : gameId,
            FieldName.active    : active
            ])
    }
}

extension GameRound {
    public convenience init?(from gameId: Int) throws {
        self.init(gameId: gameId)
    }
}
extension GameRound: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(GameRound.entity) { gameRounds in
            gameRounds.id()
            gameRounds.int(FieldName.gameId)
            gameRounds.int(FieldName.active)
        }
    }

    static func revert(_ database: Database) throws {
        
    }
}
