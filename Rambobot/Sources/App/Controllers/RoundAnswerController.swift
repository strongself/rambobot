//
//  RoundAnswerController.swift
//  Rambobot
//
//  Created by Sam Mejlumyan on 22/05/2017.
//
//

import Vapor
import HTTP
import Fluent

final class RoundAnswerController: ResourceRepresentable {

    // Add new answer
    func create(request: Request) throws -> ResponseRepresentable {

        guard let roundId = request.data["round_id"]?.int,
            let userId = request.data["user_id"]?.int,
            let answer = request.data["answer"]?.int else {
                throw Abort.custom(status: Status.preconditionFailed, message: "Missing parameters")
        }

        var newAnswer = Answer(roundId: roundId, userId: userId, answer: answer)
        try newAnswer.save()
        return try newAnswer.converted(to: JSON.self)

    }

    func users(request: Request) throws -> ResponseRepresentable {
        guard let roundId = request.data["round_id"]?.int else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Missing round id")
        }

        let taps = try Tap.query().union(User.self).all()
        var users: [User] = []
        var lowPriorityUsers: [User] = []

        for tap: Tap in taps {
            let answers = try Answer.query().all()
            var lowUser = false
            for answer: Answer in answers {
                if answer.userId == tap.userId {
                    lowUser = true
                    break
                }
            }

            if let user = try User.query().filter("id", tap.userId).first() {
                if lowUser {
                    lowPriorityUsers.append(user)
                } else {
                    users.append(user)
                }

            }
        }

        let totalUsers = users+lowPriorityUsers

        guard var round = try GameRound.query().filter("id", roundId).first() else {
            throw Abort.custom(status: Status.preconditionFailed, message: "Round not found")
        }
        var tapps = try Tap.query().all()

        for var tapItem in tapps {
            try tapItem.delete()
            try tapItem.save()
        }

        round.active = 0
        try round.save()

        return try totalUsers.makeNode().converted(to: JSON.self)

    }

    func makeResource() -> Resource<GameRound> {
        let resource = Resource<GameRound>(
            store: create
        )

        return resource
    }
    
}
