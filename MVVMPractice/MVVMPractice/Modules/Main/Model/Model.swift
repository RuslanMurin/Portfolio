//
//  Model.swift
//  Pryaniki
//
//  Created by Ruslan Murin on 04.03.2021.
//

import Foundation
import UIKit

struct Model: Codable {
    let data: [Datum]
    let view: [String]
}

struct Datum: Codable {
    let name: String
    let data: DataClass
    
}

struct DataClass: Codable {
    let text: String?
    let url: String?
    let selectedID: Int?
    let variants: [Variant]?

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case url = "url"
        case selectedID = "selectedID"
        case variants = "variants"
    }
}

struct Variant: Codable {
    let id: Int
    let text: String
}
