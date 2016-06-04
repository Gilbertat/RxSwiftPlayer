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
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        customizeAppearance()
        customizeSplitViewController()
        
        return true
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
    
    // MARK: - Helpers
    
    func customizeAppearance() {
        let hour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
        let primaryColor: UIColor
        
        switch hour {
            
        // Evening/early-morning
        case _ where hour > 19:
            fallthrough
        case 0...5:
            primaryColor = UIColor.darkGrayColor()
            
        // Morning
        case 6...10:
            primaryColor = UIColor.orangeColor()
            
        // Day/afternoon
        default:
            primaryColor = UIColor(red: 0.0, green: 128/255.0, blue: 1.0, alpha: 1.0) // Aqua
            
        }
        
        guard let defaultFont14 = UIFont(name: "Avenir-Light", size: 14),
            defaultFont17 = UIFont(name: "Avenir-Light", size: 17),
            rxSwiftPlayerFont = UIFont(name: "RxSwiftPlayer", size: 19.0)
            else { return }
        
        UINavigationBar.appearance().barTintColor = primaryColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: defaultFont17, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UITableView.appearance().separatorColor = primaryColor
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: rxSwiftPlayerFont], forState: .Normal)
        Button.appearance().tintColor = UIColor.whiteColor()
        Button.appearance().backgroundColor = primaryColor
        
        UITextField.appearance().tintColor = primaryColor
        UITextField.appearance().font = defaultFont14
        UITextView.appearance().font = defaultFont14
        
        UISegmentedControl.appearance().tintColor = primaryColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSFontAttributeName: defaultFont17], forState: .Normal)
        
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
        navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            splitViewController.preferredDisplayMode = .AllVisible
        }
    }
    
}
