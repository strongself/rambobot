import Vapor
import Fluent
import Foundation

final class User: Model {

    fileprivate struct FieldName {
        static let id = "id"
        static let name = "name"
        static let lastName = "last_name"
        static let photoUrl = "photo_url"
        static let social = "social"
    }

    var id: Node?
    var name: String
    var lastName: String
    var photoUrl: String?
    var social: String

    init(name: String, lastName: String, photoUrl: String, social: String) {
        self.id = nil
        self.name = name
        self.lastName = lastName
        self.photoUrl = photoUrl
        self.social = social
    }

    init(node: Node, in context: Context) throws {
        id = node
        name = try node.extract(FieldName.name)
        lastName = try node.extract(FieldName.lastName)
        photoUrl = try node.extract(FieldName.photoUrl)
        social = try node.extract(FieldName.social)
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            FieldName.id        : id,
            FieldName.name      : name,
            FieldName.lastName  : lastName,
            FieldName.photoUrl  : photoUrl,
            FieldName.social    : social
            ])
    }
}

extension User: Preparation {
    static func prepare(_ database: Database) throws {

    }

    static func revert(_ database: Database) throws {

    }
}
