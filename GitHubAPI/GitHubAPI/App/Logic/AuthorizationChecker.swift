//
//  AuthorizationChecker.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 20.12.2021.
//

import Foundation
import Alamofire
/// This file needs for validate user's OAuth token.
class AuthorizationChecker {
    /// Token status check.
    ///
    ///  - parameter token: Token.
    ///  - parameter completion: Completion.
    static func checkToken(token: String, completion: @escaping(Bool) -> Void) {
        AF.request(URL(string: "https://api.github.com/")!,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "token \(token)"],
                   interceptor: nil,
                   requestModifier: nil).response { response in
            guard let data = response.data else {
                completion(false)
                return
            }
            do {
                let message = try JSONDecoder().decode([String: String].self, from: data)
                if message["message"] == "Bad credentials" {
                    completion(false)
                } else { completion(true) }
            } catch {
                completion(false)
            }
        }
    }
}
