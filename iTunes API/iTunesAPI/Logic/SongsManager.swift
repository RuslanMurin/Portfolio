//
//  SongsManager.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 10.12.2021.
//

import Foundation
///Manager for work with songs.
class SongsManager {
    /// Searching songs by identifier.
        ///
        /// - parameter albumID: Album's iTunes identifier..
        /// - parameter completion: Completion.
    func getSongs(albumID: Int, completion: @escaping([Song], Bool) -> Void) {
        DataLoader.getSongs(albumID: albumID) { data in
            completion([], false)
            guard let data = data else {
                completion([], true)
                return
            }
            JSONConverter.decodeDataToSongs(data: data) { songs, error in
                guard error == nil else {
                    completion([], true)
                    return
                }
                completion(songs?.results ?? [], true)
            }
        }
    }
}
