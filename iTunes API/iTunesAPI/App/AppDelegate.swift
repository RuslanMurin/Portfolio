//
//  AppDelegate.swift
//  EvaluatingTest-iOS
//
//  Created by Ruslan Murin on 09.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

