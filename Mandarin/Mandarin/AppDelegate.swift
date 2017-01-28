
//
//  AppDelegate.swift
//  Mandarin
//
//  Created by Oleg on 11/20/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

import UIKit
import SwiftyVK


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        googleSignIn()
        
        UIWindow.mainWindow.makeKeyAndVisible()
        
        UINavigationController.main.viewControllers = [UIStoryboard.main["container"]!]// for initial start
       
        return true
    }
    
    func googleSignIn() {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

     func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        VK.process(url: url, options: options)
        return ( GIDSignIn.sharedInstance().handle(url as URL!,sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                   annotation: options[UIApplicationOpenURLOptionsKey.annotation]) ||
                FBSDKApplicationDelegate.sharedInstance().application(app, open: url as URL,
                                                                  sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String!,
                                                                  annotation: options[UIApplicationOpenURLOptionsKey.annotation]) )
    }
}

