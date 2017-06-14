//
//  GameRoundController.swift
//  Rambobot
//
//  Created by Sam Mejlumyan on 22/05/2017.
//
//
import Vapor
import HTTP

final class GameRoundController: ResourceRepresentable {

    func index(request: Request) throws -> ResponseRepresentable {
        guard let activeRound = try GameRound.query().filter("active", 1).first() else {
            return try JSON(node: ["error"  : 1,
                                   "message": "Not found active round"
                ])
        }

        return try activeRound.converted(to: JSON.self)
    }

    // Start new round
    func create(request: Request) throws -> ResponseRepresentable {

        guard let gameId = request.data["game_id"]?.int else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Missing game id")
        }

        // Find game with game_id
        let game = try Game.query().filter("id", gameId).raw()

        if game.isNull {
            throw Abort.custom(status: Status.preconditionFailed, message: "Game not found")
        }

        // Find active round
        let activeRound = try GameRound.query().filter("active", 1).first()
        if activeRound != nil {
            throw Abort.custom(status: Status.conflict, message: "Already have active round")
        }

        var newRound = GameRound(gameId: gameId)
        try newRound.save()
        return try newRound.converted(to: JSON.self)
        
    }

    func close(request: Request) throws -> ResponseRepresentable {
        guard let roundId = request.data["round_id"]?.int else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Missing round id")
        }

        guard var round = try GameRound.query().filter("id", roundId).first() else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Round not found")
        }
        var taps = try Tap.query().all()

        for var tapItem in taps {
            try tapItem.delete()
            try tapItem.save()
        }

        round.active = 0
        try round.save()
        return round
    }

    func check(request: Request) throws -> ResponseRepresentable {
        guard let activeRound = try GameRound.query().filter("active", 1).first() else {
            return try JSON(node: [
                "error"  : 1,
                "message": "Not found active round"
                ])
        }

        let socialId = request.cookies["socialId"] ?? ""

        guard let user: User = try User.query().filter("social", socialId).first()  else {
            return ""
        }

        if let tap = try Tap.query().filter("user_id", user.id?.int ?? 0).first() {
            return ""
        }

        return try JSON(node: ["active": 1, "canClick": 1])

    }

    func click(request: Request) throws -> ResponseRepresentable {

        let socialId = request.cookies["socialId"] ?? ""

        guard let user: User = try User.query().filter("social", socialId).first()  else {
            return ""
        }

        if let tap = try Tap.query().filter("user_id", user.id?.int ?? 0).first() {
            return ""
        }

        var newTap = Tap(userId: user.id?.int ?? 0)
        try newTap.save()

        return try JSON(node: [
            "status"  : "ok"
        ])
        
    }

    func start(request: Request) throws -> ResponseRepresentable {
        return try index(request: request)
    }

    func makeResource() -> Resource<GameRound> {
        let resource = Resource<GameRound>(
            index: index,
            store: create
        )

        return resource
    }

}

extension Request {
    func round() throws -> GameRound {
        guard let json = json else { throw Abort.badRequest }
        return try GameRound(node: json)
    }
}
