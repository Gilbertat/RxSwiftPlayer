//
//  AppDelegate.swift
//  RxSwiftPlayer
//
//  Created by Scott Gardner on 3/5/16.
//  Copyright © 2016 Scott Gardner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        customizeAppearance()
        customizeSplitViewController()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Helpers
    
    func customizeAppearance() {
        let hour = (Calendar.current as NSCalendar).component(.hour, from: Date())
        let primaryColor: UIColor
        
        switch hour {
            
        // Evening/early-morning
        case _ where hour > 19:
            fallthrough
        case 0...5:
            primaryColor = UIColor.darkGray
            
        // Morning
        case 6...10:
            primaryColor = UIColor.orange
            
        // Day/afternoon
        default:
            primaryColor = UIColor(red: 0.0, green: 128/255.0, blue: 1.0, alpha: 1.0) // Aqua
            
        }
        
        guard let defaultFont14 = UIFont(name: "Avenir-Light", size: 14),
            let defaultFont17 = UIFont(name: "Avenir-Light", size: 17),
            let rxSwiftPlayerFont = UIFont(name: "RxSwiftPlayer", size: 19.0)
            else { return }
        
        UINavigationBar.appearance().barTintColor = primaryColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: defaultFont17, NSForegroundColorAttributeName: UIColor.white]
        
        UITableView.appearance().separatorColor = primaryColor
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: rxSwiftPlayerFont], for: UIControlState())
        Button.appearance().tintColor = UIColor.white
        Button.appearance().backgroundColor = primaryColor
        
        UITextField.appearance().tintColor = primaryColor
        UITextField.appearance().font = defaultFont14
        UITextView.appearance().font = defaultFont14
        
        UISegmentedControl.appearance().tintColor = primaryColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: defaultFont17], for: UIControlState())
        
        UISlider.appearance().tintColor = primaryColor
        UIProgressView.appearance().tintColor = primaryColor
        
        UISwitch.appearance().onTintColor = primaryColor
        UISwitch.appearance().tintColor = primaryColor
        UIActivityIndicatorView.appearance().color = primaryColor
        
        UIStepper.appearance().tintColor = primaryColor
        
    }
    
    func customizeSplitViewController() {
        let splitViewController = window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers.last as! UINavigationController
        let navigationItem = navigationController.topViewController!.navigationItem
        navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            splitViewController.preferredDisplayMode = .allVisible
        }
    }
    
}
