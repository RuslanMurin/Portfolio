//
//  RepoViewModel.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 19.12.2021.
//

import Foundation
import Bond
/// ViewModel for Repo's ViewController.
class RepoViewModel {
/// Data loading status.
    var isLoading = Observable<Bool>(false)
/// Possible error.
    var error = Observable<Error?>(nil)
/// Last commit in repository.
    var lastCommit = Observable<Commit?>(nil)
/// Loads last published commit.
    ///
    /// All commits are loaded first, then the last one is found and converted to presentation format.
    ///
    /// - parameter commitsUrl: URL of all commits.
    /// - parameter token: OAuth token.
    func loadLastCommit(commitsUrl: URL, token: String) {
        isLoading.value = true

        CommitsManager.requestCommits(by: commitsUrl, token: token) { [weak self] commits, error in
            guard let lastCommit = commits.first else { return }
            let convertedCommit = Commit(message: lastCommit.commit.message,
                                         authorName: lastCommit.commit.author.name,
                                         date: lastCommit.commit.author.date,
                                         parentsSha: lastCommit.parents.first?.sha ?? "No Sha found")

            self?.lastCommit.value = convertedCommit
            self?.error.value = error
            self?.isLoading.value = false
        }
    }
}
