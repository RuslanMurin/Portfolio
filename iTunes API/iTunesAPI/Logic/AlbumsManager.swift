//
//  Manager.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 10.12.2021.
//

import Foundation
protocol AlbumsDelegate: AnyObject {
    func showError(_ message: String)
}
/// Manager for work with Albums.
class AlbumsManager {
/// Manager's delegate.
    weak var delegate: AlbumsDelegate?
/// Searching albums by request's text.
    ///
    /// - parameter text: Request's text.
    /// - parameter completion: Completion.
    func searchAlbums(_ text: String, completion: @escaping([Album], Bool) -> ()) {
        DataLoader.getAlbums(searchRequest: text, completion: { [weak self] data in
            guard let data = data else {
                self?.delegate?.showError("Loading error.")
                return
            }
            JSONConverter.decodeDataToAlbums(data: data) { [weak self] albums, error in
                guard error == nil else {
                    self?.delegate?.showError("Loading error.")
                    completion([], true)
                    return
                }
                if let albums = albums {
                completion(albums.results ?? [], true)
                } else {
                    completion([], false)
                }
                RequestsStorage.append(text)
            }
        })
    }
}
