//
//  AuthenticationManager.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import Foundation
import Alamofire
/// Manager for work with authentication.
class AuthenticationMnager {
/// Returns authentication session URL.
    ///
    /// - returns: Session URL.
    static func getAuthenticateURL() -> URL {

        var urlComponent = URLComponents(string: "https://github.com/login/oauth/authorize")!

        let queryItems = [
            URLQueryItem(name: "client_id", value: "\(ENV.clientID)"),
            URLQueryItem(name: "redirect_uri", value: "\(ENV.appScheme)://login"),
            URLQueryItem(name: "client_secret", value: ENV.clientSecret)
        ]

        urlComponent.queryItems = queryItems

        return urlComponent.url!
    }
/// Authorize user after taking session code.
    ///
    /// - parameter code: Authentication session code.
    /// - parameter completion: Completion.
    static func authorize(code: String, completion: @escaping([String: String]?, Error?) -> Void) {
        AF.request(URL(string: "https://github.com/login/oauth/access_token")!,
                   method: .post,
                   parameters: ["client_id": ENV.clientID,
                                "client_secret": ENV.clientSecret,
                                "code": code,
                                "redirect_uri": "\(ENV.appScheme)://login"],
                   encoding: JSONEncoding.default,
                   headers: ["Accept": "application/json"],
                   interceptor: nil,
                   requestModifier: nil).response { response in
            do {
                guard let data = response.data else { return }
                let tokenDict = try JSONDecoder().decode([String: String].self, from: data)
                UserDefaults.standard.setValue(tokenDict["access_token"], forKey: "tokenKey")
                completion(tokenDict, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
}
