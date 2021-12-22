//
//  UIView+Extensions.swift
//  Fonts-App
//
//  Created by Damir on 19.07.2021.
//

import UIKit

extension UIView {
/// Adds many subviews.
    func addSubviews(_ subviews: UIView...) {
      subviews.forEach { addSubview($0) }
    }
/// Adds many subviews.
    func addSubviews(contentsOf sequence: [UIView]) {
      sequence.forEach { addSubview($0) }
    }
}
