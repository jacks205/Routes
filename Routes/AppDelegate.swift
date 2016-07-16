//
//  AppDelegate.swift
//  Routes
//
//  Created by Mark Jackson on 7/13/16.
//  Copyright © 2016 Mark Jackson. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import CocoaLumberjack

let topGradientBackgroundColor = UIColor.blackColor()
let bottomGradientBackgroundColor = UIColor(red: 0.28, green: 0.34, blue: 0.38, alpha: 1)
let progressBarViewBackgroundColor = UIColor(red:0.20, green:0.26, blue:0.28, alpha:1)

let addRouteViewBackgroundColor = UIColor(red:0.18, green:0.22, blue:0.25, alpha:1.00)

let lightGreenColor = UIColor(red:0.54, green:0.76, blue:0.37, alpha:1.00)
let darkGreenColor = UIColor(red:0.38, green:0.69, blue:0.22, alpha:1.00)
let lightYellowColor = UIColor(red:0.88, green:0.83, blue:0.39, alpha:1.00)
let darkYellowColor = UIColor(red:0.80, green:0.76, blue:0.27, alpha:1.00)
let lightRedColor = UIColor(red:0.92, green:0.33, blue:0.50, alpha:1.00)
let darkRedColor = UIColor(red:0.85, green:0.20, blue:0.38, alpha:1.00)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupLogger()
        Fabric.with([Crashlytics.self, Answers.self])
        
        let navBar = UINavigationBar.appearance()
        navBar.translucent = false
        navBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navBar.shadowImage = UIImage()
        navBar.tintColor = UIColor.grayColor()
        navBar.barTintColor = UIColor.clearColor()
        navBar.titleTextAttributes = [
            NSFontAttributeName : UIFont(name: "OpenSans", size: 16)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.grayColor()
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).defaultTextAttributes = [
            NSFontAttributeName : UIFont(name: "OpenSans", size: 12)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        let vc = RoutesTableViewController()
        let nvc = UINavigationController(rootViewController: vc)
        vc.title = "My Routes"
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func setupLogger() {
        DDLog.addLogger(DDTTYLogger.sharedInstance()) // TTY = Xcode console
        DDLog.addLogger(DDASLLogger.sharedInstance()) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = 60*60*24  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.addLogger(fileLogger)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
