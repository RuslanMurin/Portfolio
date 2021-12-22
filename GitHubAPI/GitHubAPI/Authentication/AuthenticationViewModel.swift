//
//  AuthenticationViewModel.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import Foundation
import SafariServices
import AuthenticationServices
import Bond
import ReactiveKit
/// Authentication Controller's ViewModel.
class AuthenticationViewModel {
/// To present AuthSession(iOS 13.0+).
    var delegate: AuthenticationViewController?
/// Authentication session.
    var authSession: ASWebAuthenticationSession?
/// Possible error.
    var error = Observable<Error?>(nil)
/// Data loading status.
    var isLoading = Observable<Bool>(false)
/// User's personal token.
    var token = Observable<String?>(nil)
///  Sarts authentication.
    func startLogin() {
        self.authenticate(with: AuthenticationMnager.getAuthenticateURL()) { [weak self] token in
            self?.token.value = token
        }
    }
/// Take authentication session code and request personal token.
    ///
    /// - parameter url: Authentication URL.
    /// - parameter completion: Completion.
    private func authenticate(with url: URL, completion: @escaping ((_ token: String) -> Void)) {
        isLoading.value = true
        authSession?.cancel()

        authSession = ASWebAuthenticationSession(url: url, callbackURLScheme: ENV.appScheme, completionHandler: { url, error in
            if let error = error {
                self.error.value = error
            }
            guard let url = url, error == nil else { return }
            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
            guard let code = queryItems?.filter({ $0.name == "code" }).first?.value else { return }
            AuthenticationMnager.authorize(code: code) { tokenDict, error in
                if let error = error {
                    self.error.value = error
                } else {
                    guard let token = tokenDict?["access_token"] else { return }
                    completion(token)
                }
            }
        })
        guard let delegate = delegate else {
            return
        }
        if #available(iOS 13.0, *) {
            authSession?.presentationContextProvider = delegate
        }
        authSession?.start()
// asyncAfter need to avoid double tap. (Native methods can't handle cancel authentication)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
            self?.isLoading.value = false
        }
    }
}
