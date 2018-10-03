//
//  TaxiGoManager.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import TaxiGoDev

var taxiGoManager = TaxiGoManager.shared

// MARK: This class manages the requirement data.
class TaxiGoManager {
    
    static let shared = TaxiGoManager()
        
    var taxiGo = TaxiGo.shared
        
    func setup() {

        // MARK: TaxiGoDev provides some properties to store the requirement data. 
        taxiGo.auth.appID = Constants.appID
        taxiGo.auth.appSecret = Constants.appSecret
        taxiGo.auth.redirectURL = Constants.redirectURL
        taxiGo.api.url = Constants.productionUrl
        taxiGo.api.apiKey = Constants.apiKey
//        taxiGo.api.startObservingStatus = false
        
    }
    
    func getAccessToken() {
        
        // MARK: If you has stored the data in TaxiGoDev's properties, you can request the token without parameters.
        taxiGo.auth.getUserToken(success: { (auth) in

            guard let tokenExpiredTime = auth.token_expiry_date else { return }
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(auth.access_token, forKey: "access_token")
            userDefaults.setValue(tokenExpiredTime, forKey: "token_expired_date")
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
    
    func refreshToken(success: @escaping (Bool) -> Void) {
        
        let token = UserDefaults.standard.value(forKey: "refresh_token")
        guard let tokenString = token as? String else { return }
        taxiGo.auth.refreshToken = tokenString
        taxiGo.auth.refreshToken(success: { (refreshToken) in
            
            guard let tokenExpiredTime = refreshToken.expires_in else { return }
            let timestamp = NSDate().timeIntervalSince1970
            let expiredTimestamp = timestamp + tokenExpiredTime
            
            let userDefaults = UserDefaults.standard
            userDefaults.setValue(refreshToken.access_token, forKey: "access_token")
            userDefaults.setValue(expiredTimestamp, forKey: "token_expired_date")
            userDefaults.synchronize()

            success(true)
            
        }) { (err) in
            print("Failed to refresh token : \(err.localizedDescription)")
            success(false)
        }
        
    }
    
}
