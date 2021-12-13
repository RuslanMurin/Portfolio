//
//  RequestsStorage.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 13.12.2021.
//

import Foundation
/// Stores requests on device.
class RequestsStorage {
/// Current requests in storege.
    static var requests: [String] {
        get { return UserDefaults.standard.stringArray(forKey: "requests") ?? [] }
        set { return UserDefaults.standard.setValue(newValue, forKey: "requests") }
    }
/// Appends request in storage.
    ///
    /// - parameter text: Request's text.
    static func append(_ text: String) {
        var temp = RequestsStorage.requests
        if !temp.contains(text) && text != "" {
        temp.append(text)
        }
        RequestsStorage.requests = temp
    }
}
