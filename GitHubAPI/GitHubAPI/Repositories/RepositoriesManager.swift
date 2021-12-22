//
//  RepositoriesManager.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 18.12.2021.
//

import Foundation
import Alamofire
/// Manager for work with Repositories.
class RepositoriesManager {
/// Requests pack of repositories.
///
    ///- parameter url: request URL.
    ///- parameter token: OAuth token.
    ///- parameter completion: Completion.
    static func request(with url: URL, token: String, completion: @escaping(Repositories, Error?) -> Void) {
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: ["Authorization": "token \(token)"],
                   interceptor: nil,
                   requestModifier: nil).response { response in
            guard let data = response.data else { return }
            do {
            let repos = try JSONDecoder().decode(Repositories.self, from: data)
                completion(repos, nil)
            } catch {
                completion([], error)
            }
        }
    }
}
