//
//  InitialViewController.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 20.12.2021.
//

import UIKit
/// Controller substrate.
///
/// Needs to avoid AppDelegate's error. The token is validated inside the controller.
class InitialViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // After checking the token, the corresponding controller is presented.
        if let token = UserDefaults.standard.string(forKey: "tokenKey") {
            AuthorizationChecker.checkToken(token: token) { authorized in
                let controller = authorized
                ? createNavController(for: ReposViewController(token: token), title: "Repositories")
                : AuthenticationViewController(viewModel: AuthenticationViewModel())
                controller.modalPresentationStyle = .overCurrentContext
                // 0.3 sec default animation delay needs to complete self's present
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self.present(controller, animated: true)
                }
            }
        } else  {
            let controller = AuthenticationViewController(viewModel: AuthenticationViewModel())
            controller.modalPresentationStyle = .overFullScreen
            // 0.3 sec default animation delay needs to complete self's present
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.present(controller, animated: true)
            }
        }
    }
}
