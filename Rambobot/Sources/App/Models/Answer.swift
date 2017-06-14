import Vapor
import Fluent
import Foundation

final class Answer: Model {

    fileprivate struct FieldName {
        static let id = "id"
        static let roundId = "round_id"
        static let userId = "user_id"
        static let answer = "answer"
    }

    var id: Node?
    var roundId: Int
    var userId: Int
    var answer: Int

    init(roundId: Int, userId: Int, answer: Int) {
        self.id = nil
        self.roundId = roundId
        self.userId = roundId
        self.answer = answer
    }

    init(node: Node, in context: Context) throws {
        id = node
        roundId = try node.extract(FieldName.roundId)
        userId = try node.extract(FieldName.userId)
        answer = try node.extract(FieldName.answer)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            FieldName.id        : id,
            FieldName.roundId   : roundId,
            FieldName.userId    : userId,
            FieldName.answer    : answer
            ])
    }
}

extension Answer: Preparation {
    static func prepare(_ database: Database) throws {

    }

    static func revert(_ database: Database) throws {
        
    }
}
