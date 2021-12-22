//
//  Owner.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 18.12.2021.
//

import Foundation
/// Repository's owner entity.
struct Owner: Codable {
    let login: String
    let id: Int
    let avatarURL: String
    let url: String
    let reposURL: String
    let type: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case url
        case reposURL = "repos_url"
        case type
    }
}
