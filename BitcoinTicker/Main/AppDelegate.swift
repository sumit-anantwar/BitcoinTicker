//
//  AppDelegate.swift
//  BitcoinTicker
//
//  Created by Sumit Anantwar on 21/05/2019.
//  Copyright © 2019 Sumit Anantwar. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Dependency Registry
    static var dependencyRegistry: DependencyRegistry!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Fabric.with([Crashlytics.self])
        
        return true
    }

}

