//
//  AppDelegate.swift
//  TaxiGoDev
//
//  Created by shannn214 on 09/04/2018.
//  Copyright (c) 2018 shannn214. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        TaxiGoManager.shared.setup()
        
//        let token = UserDefaults.value(forKey: "access_token") as? String
//        if token != nil {
//            TaxiGoManager.shared.taxiGo.auth.accessToken = token
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = UIStoryboard.mapStoryboard().instantiateInitialViewController()
//        } else {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.window?.rootViewController = UIStoryboard.loginStoryboard().instantiateInitialViewController()
//        }
        
        // NOTE: Remove the key before publish
        GMSServices.provideAPIKey("AIzaSyAsTGKqYqUFXmAyAGFkj3Xr8AHyQI75U1E")
        GMSPlacesClient.provideAPIKey("AIzaSyAe8rnl49gZp8i1Zt37Ze5UhbOFscFVhxg")

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

}

