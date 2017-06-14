//
//  AuthController.swift
//  Rambobot
//
//  Created by Sam Mejlumyan on 22/05/2017.
//
//
import Vapor
import HTTP
import Cookies

final class AuthController: ResourceRepresentable {

    func vk(request: Request) throws -> ResponseRepresentable {
        guard var query = request.uri.query else { return "" }

        var queryParameters: [String: String] = [:]
        query = query.replacingOccurrences(of: "vkontakte=", with: "")

        let parameters = query.components(separatedBy: "&")


        for parameter in parameters {
            let components = parameter.components(separatedBy: "=")
            if components.count > 1 {
                queryParameters[components[0]] = components[1]
            }
        }

        guard let code = queryParameters["code"] else {
            return ""
        }


        let methodUrl = "https://oauth.vk.com/access_token?client_id=\(Constants.Social.Vk.client)&client_secret=\(Constants.Social.Vk.secret)&redirect_uri=\(Constants.mainDomain)auth/vk&code=\(code)"

        let userAccessContent = try drop.client.get(methodUrl)
        let userAccessBytes = userAccessContent.body.bytes ?? []
        let accessJson = try JSON(bytes: userAccessBytes)

        let accessToken = accessJson["access_token"]?.string ?? ""
        let method = "/method/users.get?fields=photo_max,city,verified&access_token=\(accessToken)"

        let accessMethodUrl = "https://api.vk.com/\(method)"

        let userContent = try drop.client.get(accessMethodUrl)
        let userBytes = userContent.body.bytes ?? []
        let json = try JSON(bytes: userBytes).pathIndexableObject?["response"]

        guard let jsonArray = json?.array,
            jsonArray.count > 0 else {
                return userContent
                return "Response error"
        }

        guard
            let userId = json?[0]?["uid"]?.string,
            let firstName = json?[0]?["first_name"]?.string,
            let lastName = json?[0]?["last_name"]?.string,
            let photoUrl = json?[0]?["photo_max"]?.string
            else { return "Auth parameters error" }

        let socialId = "vk\(userId)"

        // User already exists
        var user = try User.query().filter("social", socialId).first()

        if user == nil {
            user = User(name: firstName, lastName: lastName, photoUrl: photoUrl, social: socialId)
            try user?.save()
        }

        let cookie = Cookie(name: "socialId", value: socialId)
        let cookieHash = Cookie(name: "hash", value: user?.id?.string ?? "")

        let response = Response(redirect: "/")
        response.cookies.insert(cookie)
        response.cookies.insert(cookieHash)

        return  response

    }

    func fb(request: Request) throws -> ResponseRepresentable {
        guard var query = request.uri.query else { return "" }

        var queryParameters: [String: String] = [:]
        query = query.replacingOccurrences(of: "vkontakte=", with: "")

        let parameters = query.components(separatedBy: "&")


        for parameter in parameters {
            let components = parameter.components(separatedBy: "=")
            if components.count > 1 {
                queryParameters[components[0]] = components[1]
            }
        }

        guard let code = queryParameters["code"] else {
            return ""
        }

        var methodUrl = "https://graph.facebook.com/oauth/access_token?client_id=\(Constants.Social.Fb.client)&redirect_uri=\(Constants.mainDomain)auth/fb&client_secret=\(Constants.Social.Fb.secret)&code=\(code)"

        let userAccessContent = try drop.client.get(methodUrl)
        let userAccessBytes = userAccessContent.body.bytes ?? []
        let accessJson = try JSON(bytes: userAccessBytes)

        let accessToken = accessJson["access_token"]?.string ?? ""

        let method = "https://graph.facebook.com/me?fields=id,email,first_name,last_name,picture.height(961)&access_token=\(accessToken)"

        let userContent = try drop.client.get(method)
        let userBytes = userContent.body.bytes ?? []

        let json = try JSON(bytes: userBytes)

        guard
            let userId = json["id"]?.string,
            let firstName = json["first_name"]?.string,
            let lastName = json["last_name"]?.string,
            let photoUrl = json["picture"]?["data"]?["url"]?.string
            else { return "Auth parameters error" }

        let socialId = "fb\(userId)"

        // User already exists
        var user = try User.query().filter("social", socialId).first()

        if user == nil {
            user = User(name: firstName, lastName: lastName, photoUrl: photoUrl, social: socialId)
            try user?.save()
        }

        let cookie = Cookie(name: "socialId", value: socialId)
        let cookieHash = Cookie(name: "hash", value: user?.id?.string ?? "")

        let response = Response(redirect: "/")
        response.cookies.insert(cookie)
        response.cookies.insert(cookieHash)

        return  response
    }

    func auth(request: Request) throws -> ResponseRepresentable {
        guard var query = request.uri.query else { return "" }
        var queryParameters: [String: String] = [:]

        if query.contains("facebook") {

        } else {
            query = query.replacingOccurrences(of: "vkontakte=", with: "")

            let parameters = query.components(separatedBy: "&")


            for parameter in parameters {
                let components = parameter.components(separatedBy: "=")
                if components.count > 1 {
                    queryParameters[components[0]] = components[1]
                }
            }

            guard let accessToken = queryParameters["access_token"], let _ = queryParameters["user_id"] else {
                return ""
            }

            let method = "/method/users.get?fields=photo_max,city,verified&access_token=\(accessToken)"
            let md5 = CryptoHasher(method: .md5, defaultKey: nil)
            let sigString = method+Constants.Social.Vk.key;

            let sig = try md5.make(sigString)

            let methodUrl = "https://api.vk.com/\(method)&sig=\(sig)"
            let userContent = try drop.client.get(methodUrl)
            let userBytes = userContent.body.bytes ?? []
            let json = try JSON(bytes: userBytes).pathIndexableObject?["response"]
            guard let jsonArray = json?.array,
                jsonArray.count > 0 else {
                    return userContent
                    return "Response error"
            }

            guard
                let userId = json?[0]?["uid"]?.string,
                let firstName = json?[0]?["first_name"]?.string,
                let lastName = json?[0]?["last_name"]?.string,
                let photoUrl = json?[0]?["photo_max"]?.string
                else { return "Auth parameters error" }

            let socialId = "vk\(userId)"

            // User already exists
            var user = try User.query().filter("social", socialId).first()

            if user == nil {
                user = User(name: firstName, lastName: lastName, photoUrl: photoUrl, social: socialId)
                try user?.save()
            }

            let cookie = Cookie(name: "socialId", value: socialId)
            let cookieHash = Cookie(name: "hash", value: user?.id?.string ?? "")
            
            let response = Response(redirect: "/")
            response.cookies.insert(cookie)
            response.cookies.insert(cookieHash)
            
            return  response
            
        }
        return JSON(["access_token": try queryParameters.makeNode()])
    }
    
    func makeResource() -> Resource<User> {
        
        let resource = Resource<User>(
        )
        
        return resource
    }
    
}
