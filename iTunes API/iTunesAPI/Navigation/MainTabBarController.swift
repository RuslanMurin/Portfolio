//
//  MainTabBarController.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 09.12.2021.
//

import UIKit
///  TabBar of the app.
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
/// Tabs setup.
    func setupTabs() {
        viewControllers = [createNavController(for: AlbumsViewController(),
                                                  title: "Search",
                                                  image: nil,
                                                  selectedImage: nil),
                           createNavController(for: HistoryViewController(),
                                                  title: "Search history",
                                                  image: nil,
                                                  selectedImage: nil)
        ]
    }
    /**
     NavigationController creating.
     
     - parameter rootViewController: first ViewController.
     - parameter title: Title.
     - parameter image: Inactive statement image.
     - parameter selectedImage: Active statement image.
     
     - returns: Navigation Controller for TabBar's tab.
     */
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage?,
        selectedImage: UIImage?) -> UINavigationController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            navController.tabBarItem.selectedImage = selectedImage
            navController.navigationBar.prefersLargeTitles = true
            navController.view.backgroundColor = Constants.backgroundColor
            navController.navigationBar.prefersLargeTitles = false
            rootViewController.navigationItem.title = title
            return navController
        }
}
