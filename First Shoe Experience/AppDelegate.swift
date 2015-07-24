//
//  AppDelegate.swift
//  FirstShoeExperience
//
//  Created by Openly on 23/03/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad )
        {
            Mixpanel.sharedInstanceWithToken("d52771f8a4174277206123367506b544")
        }
        else
        {
            Mixpanel.sharedInstanceWithToken("f356a6b875b569d3b0317a7b884ab2e9")
        }
        let mixpanel: Mixpanel = Mixpanel.sharedInstance()
        
        var pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor (red: (236/255.0), green: (236/255.0), blue: (236/255.0), alpha: 1.0)
        pageController.currentPageIndicatorTintColor = UIColor .whiteColor()
        pageController.backgroundColor = UIColor .whiteColor()
        Fabric.with([Crashlytics()])

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


}
