import Vapor
import Fluent
import Foundation

final class Tap: Model {

    fileprivate struct FieldName {
        static let id = "id"
        static let userId = "user_id"
    }

    var id: Node?
    var userId: Int

    init(userId: Int) {
        self.id = nil
        self.userId = userId
    }

    init(node: Node, in context: Context) throws {
        id = node
        userId = try node.extract(FieldName.userId)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            FieldName.id        : id,
            FieldName.userId    : userId
            ])
    }
}

extension Tap: Preparation {
    static func prepare(_ database: Database) throws {

    }

    static func revert(_ database: Database) throws {
        
    }
}
