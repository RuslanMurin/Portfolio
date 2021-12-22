//
//  Constants.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import UIKit
/// UI constants.
class Constants {
    /// Supports color scheme of different iOS versions.
    static let backgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }()
    /// Activity indicator style for all iOS versions.
    static let activityStyle: UIActivityIndicatorView.Style = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView.Style.large
        } else {
            return UIActivityIndicatorView.Style.whiteLarge
        }
    }()
    static let cellFontSize: CGFloat = 14
}
