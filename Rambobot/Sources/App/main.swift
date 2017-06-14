import Vapor
import VaporMySQL
import Sessions

let vkUrl = "https://oauth.vk.com/authorize?client_id=\(Constants.Social.Vk.client)&display=page&redirect_uri=\(Constants.mainDomain)auth/vk&scope=friends&response_type=code"
let fbUrl = "https://www.facebook.com/v2.9/dialog/oauth?client_id=\(Constants.Social.Fb.client)&redirect_uri=\(Constants.mainDomain)auth/fb"

let drop = Droplet()

try drop.addProvider(VaporMySQL.Provider.self)

let memory = MemorySessions()
let sessions = SessionsMiddleware(sessions: memory)

drop.middleware.append(sessions)

drop.get { req in

    let userId = req.cookies["hash"] ?? ""
    let socialId = req.cookies["socialId"] ?? ""

    var user: User? = try User.query().filter("social", socialId).first()

    if var user = user {
        return try drop.view.make("play", ["name": user.name])
    } else {
        return try drop.view.make("welcome", ["vkUrl": vkUrl,"fbUrl": fbUrl])
    }

}

drop.group("v1") { api in
    api.resource("games", GameController())

    let roundController = GameRoundController()
    api.resource("games/rounds", roundController)
    api.put("games/rounds/close", handler: roundController.close)
    api.get("games/rounds/check", handler: roundController.check)
    api.get("games/rounds/click", handler: roundController.click)

    let roundAnswerController = RoundAnswerController()
    api.resource("answers", roundAnswerController)
    api.get("answers/users", handler: roundAnswerController.users)
}

let authController = AuthController()
drop.get("auth/vk", handler: authController.vk)
drop.get("auth/fb", handler: authController.fb)
drop.get("auth", handler: authController.auth)

drop.preparations.append(Game.self)
drop.preparations.append(GameRound.self)
drop.preparations.append(Answer.self)
drop.preparations.append(User.self)
drop.preparations.append(Tap.self)

drop.run()
