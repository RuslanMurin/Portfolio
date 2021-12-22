//
//  CommitsManager.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 19.12.2021.
//

import Foundation
import Alamofire

class CommitsManager {
/// Requests all commits of repository.
    ///
    /// - parameter url: Commits URL.
    /// - parameter token: Access token.
    /// - parameter completion: Completion.
    static func requestCommits(by url: URL, token: String, completion: @escaping(Commits, Error?) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "token \(token)"],
                   interceptor: nil,
                   requestModifier: nil).response { response in
            guard let data = response.data else { return }
            do {
                let commits = try JSONDecoder().decode(Commits.self, from: data)
                completion(commits, nil)
            } catch {
                print(error)
                completion([], error)
            }
        }
    }
}
