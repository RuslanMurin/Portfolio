//
//  Song.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 12.12.2021.
//

import Foundation
/// iTunes API response's songs.
class Songs: Codable {
/// All songs in response.
    var results: [Song]?

    enum CodingKeys: String, CodingKey {
        case results = "results"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        results = try values.decode([Song].self, forKey: .results)
        results?.removeFirst() //removing first element because it's always a dublicate of album in API response
    }
}
/// Song from iTunes.
class Song: Codable {

    let trackName: String
    let trackTimeMillis: Int

    enum CodingKeys: String, CodingKey {
        case trackName = "trackName"
        case trackTimeMillis = "trackTimeMillis"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackName = try values.decodeIfPresent(String.self, forKey: .trackName) ?? "Unknown track"
        trackTimeMillis = try values.decodeIfPresent(Int.self, forKey: .trackTimeMillis) ?? 0
    }
}

