//
//  AppDelegate.swift
//  SportsTeamManager
//
//  Created by Vladislav on 17/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigator = UINavigationController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateInitialViewController()!
        navigator.viewControllers = [mainVC]
        
        self.window?.rootViewController = navigator
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

