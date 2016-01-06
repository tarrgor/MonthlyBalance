//
//  AppDelegate.swift
//  MonthlyBalance
//
//  Created by Thorsten Klusemann on 08.11.15.
//  Copyright © 2015 Karrmarr Software. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  var settings: Settings = Settings()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let contentViewController = storyboard.instantiateInitialViewController()
    let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MainMenuViewController")
    let slideMenuViewController = SlideMenuViewController(menuViewController: menuViewController, contentViewController: contentViewController!)
    
    self.window?.rootViewController = slideMenuViewController
    
    self.window?.makeKeyAndVisible()
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    self.settings.save()
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
    self.settings.save()
  }
}

