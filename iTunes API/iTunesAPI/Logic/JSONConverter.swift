//
//  JSONConverter.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 10.12.2021.
//

import Foundation
/// Converts JSON data to entities.
class JSONConverter {
    /// Decode to albums.
    ///
    /// - parameter data: Data to decode.
    /// - parameter completion: Completion.
    static func decodeDataToAlbums(data: Data, completion: @escaping(Albums?, Error?) -> Void) {
        do {
            let albums = try JSONDecoder().decode(Albums.self, from: data as Data)
            DispatchQueue.main.async {
                completion(albums, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
    /// Decode to songs.
    ///
    /// - parameter data: Data to decode.
    /// - parameter completion: Completion.
    static func decodeDataToSongs(data: Data, completion: @escaping(Songs?, Error?) -> Void) {
        do {
            let albums = try JSONDecoder().decode(Songs.self, from: data as Data)
            DispatchQueue.main.async {
                completion(albums, nil)
            }
        } catch {
            completion(nil, error)
        }
    }
}
