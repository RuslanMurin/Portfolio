//
//  Int+Description.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 12.12.2021.
//

import Foundation

extension Int {
    /// Converts Int to time format "mm:ss".
    ///
    /// Needs if time in millis presents as Int.
    func toTimeFormat() -> String {
        let minutes = ((self / 1000) % 3600) / 60
        let seconds = ((self / 1000) % 3600) % 60
        let secs = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        return "\(minutes):" + secs
    }
}
