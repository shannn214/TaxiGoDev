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
        
        GMSServices.provideAPIKey("AIzaSyAsTGKqYqUFXmAyAGFkj3Xr8AHyQI75U1E") // <YOUR_GMS_API_KEY>
        GMSPlacesClient.provideAPIKey("AIzaSyAe8rnl49gZp8i1Zt37Ze5UhbOFscFVhxg") // <YOUR_GMS_API_KEY>
        
        // MARK: Check if the user has logged in before.
        guard TaxiGoManager.shared.checkUserToken() == nil else {
            // MARK: Check if the token is valid or not.
            let now = NSDate().timeIntervalSince1970
            guard let expiredTime = UserDefaults.standard.value(forKey: "token_expired_date") as? Double else { return true }
            if now > expiredTime {

                TaxiGoManager.shared.refreshToken { (isValid) in

                    if isValid {
                        // MARK: Setup the token in TaxiGoDev and switch the VC to map
                        TaxiGoManager.shared.taxiGo.auth.accessToken = TaxiGoManager.shared.checkUserToken()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = UIStoryboard.mapStoryboard().instantiateInitialViewController()

                    } else {

                        print("Failed to refresh token.")

                    }

                }

            } else {

                TaxiGoManager.shared.taxiGo.auth.accessToken = TaxiGoManager.shared.checkUserToken()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = UIStoryboard.mapStoryboard().instantiateInitialViewController()

            }

            return true
        }
        
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
//        guard let code = NSURLComponents(string: "\(url)")?.queryItems?.filter({ $0.name == "code" }).first,
//            let authCode = code.value else { return false }
        
        taxiGo.auth.authCode = taxiGo.auth.getAuthCode(url: url)
        TaxiGoManager.shared.getAccessToken()
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.window?.rootViewController = UIStoryboard.mapStoryboard().instantiateInitialViewController()
        
        return true
    }

}

