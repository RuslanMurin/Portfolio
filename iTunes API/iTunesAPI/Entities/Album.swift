//
//  Album.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 12.12.2021.
//

import Foundation
/// Albums from iTunes response.
class Albums: Codable {
/// API response's albums count.
    let resultCount : Int?
/// All albums in response.
    let results : [Album]?

    enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try container.decode(Int.self, forKey: .resultCount)
        results = try container.decode([Album].self, forKey: .results)
            .sorted {$0.collectionName < $1.collectionName} //Sorting alphabetically
    }
}
/// Album from iTunes.
class Album : Codable {

    let artistName : String
    let artworkUrl100 : String
    let collectionName : String
    let primaryGenreName : String
    let releaseDate : String
    let collectionId: Int
    let trackCount: Int

    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case artworkUrl100 = "artworkUrl100"
        case collectionName = "collectionName"
        case primaryGenreName = "primaryGenreName"
        case releaseDate = "releaseDate"
        case collectionId = "collectionId"
        case trackCount = "trackCount"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
        collectionName = try values.decodeIfPresent(String.self, forKey: .collectionName) ?? "Unknown Collection"
        primaryGenreName = try values.decodeIfPresent(String.self, forKey: .primaryGenreName) ?? "Music"
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName) ?? "Unknown artist"
        collectionId = try values.decodeIfPresent(Int.self, forKey: .collectionId) ?? 0
        trackCount = try values.decodeIfPresent(Int.self, forKey: .trackCount) ?? 0
    }
}
