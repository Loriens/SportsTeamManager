//
//  AppDelegate.swift
//  SportsTeamManager
//
//  Created by Vladislav on 17/03/2019.
//  Copyright © 2019 Vladislav. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let teamManager = TeamManager(modelName: "TeamManager")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigator = UINavigationController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateInitialViewController() as! MainViewController
        mainVC.teamManager = teamManager
        navigator.viewControllers = [mainVC]
        
        self.window?.rootViewController = navigator
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

