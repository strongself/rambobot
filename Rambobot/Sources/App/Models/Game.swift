import Vapor
import Fluent
import Foundation

final class Game: Model {

    fileprivate struct FieldName {
        static let id = "id"
        static let title = "title"
        static let active = "active"
    }

    var id: Node?
    var title: String
    var active: Int

    init(title: String) {
        self.id = nil
        self.title = title
        self.active = 1
    }

    init(node: Node, in context: Context) throws {
        id = node
        title = try node.extract(FieldName.title)
        active = try node.extract(FieldName.active)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            FieldName.id        : id,
            FieldName.title     : title,
            FieldName.active    : active
            ])
    }
}

extension Game {
    public convenience init?(from string: String) throws {
        self.init(title: string)
    }
}

extension Game: Preparation {
    static func prepare(_ database: Database) throws {

    }

    static func revert(_ database: Database) throws {

    }
}
