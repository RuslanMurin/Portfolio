//
//  Downloader.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 10.12.2021.
//

import Foundation
import Alamofire

/// Requests data from iTunes.
class DataLoader {
    /// Requests albums.
    ///
    /// - parameter searchRequest: Request's text.
    /// - parameter completion: Completion.
    class func getAlbums(searchRequest: String, completion: @escaping (Data?) -> Void){

        let convertedString = searchRequest.reduce(""){ $1 == " " ? "\($0)+" : "\($0)\($1)"}

        AF.request("https://itunes.apple.com/search?term=\(convertedString)&entity=album")
            .responseJSON{ response in
                completion(response.data)
            }
    }
    /// Requests songs in album.
    ///
    /// - parameter albumID: Album's identifier in iTunes.
    /// - parameter completion: Completion.
    class func getSongs (albumID: Int, completion: @escaping (Data?) -> Void){

        let convertedID = String(albumID)

        AF.request("https://itunes.apple.com/lookup?id=\(convertedID)&entity=song")
            .responseJSON{ response in
                completion(response.data)
            }
    }
}
