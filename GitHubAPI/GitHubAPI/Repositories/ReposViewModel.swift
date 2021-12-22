//
//  ReposViewModel.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 18.12.2021.
//

import Foundation
import Bond
/// Repositories ViewController's ViewModel.
class ReposViewModel {
    var repositories = Observable<Repositories>([])
/// Parameter for pagination.
///
/// App loads pack of commits with ID greater than this value.
    private var since: Int = 0
    /// Possible error.
    var error = Observable<Error?>(nil)
/// Requests repositories.
    ///
    ///- parameter token: OAuth token.
    func requestRepos(token: String) {

        RepositoriesManager.request(with: URL(string: "https://api.github.com/repositories?since=\(since)")!,
                                    token: token) { [weak self] (repositories, error) in
            guard let error = error else {
                self?.repositories.value.append(contentsOf: repositories)
                self?.since = repositories.last?.id ?? 0
                return
            }
            self?.error.value = error
        }
    }
}
