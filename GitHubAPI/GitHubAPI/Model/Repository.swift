//
//  Repository.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 18.12.2021.
//

import Foundation
/// GitHubs' repository entity.
struct Repository: Codable {
    let id: Int
    let name: String
    let owner: Owner
    let url: String
    let commitsURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case url
        case commitsURL = "commits_url"
    }
}

typealias Repositories = [Repository]
