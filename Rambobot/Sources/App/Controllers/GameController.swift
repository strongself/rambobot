//
//  GameRoundController.swift
//  Rambobot
//
//  Created by Sam Mejlumyan on 22/05/2017.
//
//
import Vapor
import HTTP

final class GameController: ResourceRepresentable {

    func index(request: Request) throws -> ResponseRepresentable {
        guard let game = try Game.query().filter("active", 1).first() else {
            throw Abort.custom(status: Status.notFound, message: "Game not found")
        }

        return try game.converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        let gameTitle = request.data["game_name"]?.string ?? "Unknown Game"

        var game = Game(title: gameTitle)
        try game.save()

        return try game.converted(to: JSON.self)
    }

    func start(request: Request) throws -> ResponseRepresentable {
        return try index(request: request)
    }

    func makeResource() -> Resource<Game> {

        let resource = Resource<Game>(
            index: index,
            store: create
        )

        return resource
    }

}

extension Request {
    func game() throws -> Game {
        guard let json = json else { throw Abort.badRequest }
        return try Game(node: json)
    }
}
