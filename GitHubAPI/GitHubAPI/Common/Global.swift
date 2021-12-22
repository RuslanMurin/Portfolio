//
//  Globaal.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 20.12.2021.
//

import UIKit
/**
 NavigationController creating.
 
 - parameter rootViewController: first ViewController.
 - parameter title: Title.
 - parameter image: Inactive statement image.
 - parameter selectedImage: Active statement image.
 
 - returns: Navigation Controller for TabBar's tab.
 */
    func createNavController(
    for rootViewController: UIViewController,
    title: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.navigationBar.prefersLargeTitles = false
        navController.view.backgroundColor = Constants.backgroundColor
        rootViewController.navigationItem.title = title
        return navController
    }
