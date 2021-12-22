//
//  CustomController.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import UIKit
/// Behavior for configuring view controller UI elements.
protocol InterfaceSetupProtocol: AnyObject {
    ///  General setting. Should include addSubviews() and makeConstraints().
    func commonSetup()
    /// Adding subviews to Controller's view.
    func addSubviews()
    /// Making constraints of subviews.
    func makeConstraints()
}
