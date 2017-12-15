//
//  AppDelegate.swift
//  Stock
//
//  Created by Kim Younghoo on 11/11/17.
//  Copyright © 2017 0hoo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //[C6-15]
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var window: UIWindow?
    
    let tabBarController = UITabBarController()
    
    //[C6-16]
    var groupsViewController: GroupsViewController? {
        return (tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController as? GroupsViewController
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: GroupsViewController()),
            UINavigationController(rootViewController: StocksViewController())
        ]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.tintColor = .themeBlue
        window?.makeKeyAndVisible()
        
        return true
    }
}
