//
//  UIViewController+Extensions.swift
//  EvaluatingTest-iOS
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import UIKit

extension UIViewController {
    /**
     Showing Alert message.

     - parameter message: Message's text.
     */
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: nil,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
}
