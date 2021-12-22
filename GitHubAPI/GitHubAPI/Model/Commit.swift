//
//  Commit.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 19.12.2021.
//

import Foundation
/// GitHub's commit converted format
struct Commit {
    let message: String
    let authorName: String
    let date: String
    let parentsSha: String
}
/// GitHub's commit entity.
struct CommitEntity: Codable {
    let commit: CommitStruct
    let parents: [Parent]

    enum CodingKeys: String, CodingKey {
        case commit, parents
    }
}

struct CommitStruct: Codable {
    let author: CommitAuthor
    let message: String

    enum CodingKeys: String, CodingKey {
        case author, message
    }
}

struct CommitAuthor: Codable {
    let name: String
    let date: String
    enum CodingKeys: String, CodingKey {
        case name, date
    }
}

struct Parent: Codable {
    let sha: String

    enum CodingKeys: String, CodingKey {
        case sha
    }
}

typealias Commits = [CommitEntity]
