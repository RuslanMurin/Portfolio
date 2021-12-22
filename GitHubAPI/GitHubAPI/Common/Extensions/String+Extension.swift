//
//  String+Extension.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 20.12.2021.
//

import Foundation

extension String {
/// Converts GitHub's Date presentation to needed format.
    func convertGithubDate() -> String {
        let parts = self.components(separatedBy: "-")
        let dayParts = parts[2].components(separatedBy: "T")
        return "\(dayParts[0]).\(parts[1]).\(parts[0])"
    }
}
