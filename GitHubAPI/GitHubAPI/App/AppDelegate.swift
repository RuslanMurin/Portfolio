//
//  AppDelegate.swift
//  GitHubAPI
//
//  Created by Ruslan Murin on 17.12.2021.
//

import UIKit
import ReactiveKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Appearance for iOS 15.0 and late.
        if #available(iOS 15.0, *) {
            let navigationAppearance = UINavigationBarAppearance()
            navigationAppearance.configureWithOpaqueBackground()
            navigationAppearance.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
            UINavigationBar.appearance().standardAppearance = navigationAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            tabAppearance.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
            UITabBar.appearance().standardAppearance = tabAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = InitialViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

