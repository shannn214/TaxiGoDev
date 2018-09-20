//
//  TaxiGoManager.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import TaxiGoDev

// MARK: This class manages the requirement data.
class TaxiGoManager {
    
    static let shared = TaxiGoManager()
        
    var taxiGo = TaxiGo.shared
        
    func setup() {

        // MARK: 
        taxiGo.auth.appID = Constants.appID
        taxiGo.auth.appSecret = Constants.appSecret
        taxiGo.auth.redirectURL = Constants.redirectURL
        
    }
    
    func getAccessToken() {
        
        // MARK:
        taxiGo.auth.getUserToken(success: { (auth) in
            
            let userDefaults = UserDefaults.standard
            
            userDefaults.setValue(auth.access_token, forKey: "access_token")
            userDefaults.setValue(auth.refresh_token, forKey: "refresh_token")
            userDefaults.synchronize()
            
        }) { (err) in
            print("Failed to get token: \(err.localizedDescription)")
        }
        
    }
    
    func checkUserToken() -> String? {
        
        let token = UserDefaults.standard.value(forKey: "access_token")
        
        guard let tokenString = token as? String else { return nil }
        
        return tokenString
        
    }
    
}
