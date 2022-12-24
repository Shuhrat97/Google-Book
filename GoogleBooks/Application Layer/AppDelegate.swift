//
//  AppDelegate.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 20/12/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        showMainTab()
        return true
    }
    
    func showMainTab(){
        window = UIWindow()
        window?.backgroundColor = .white
        let ctrl = TabbarController()
        window?.rootViewController = ctrl
        window?.makeKeyAndVisible()
    }

}

