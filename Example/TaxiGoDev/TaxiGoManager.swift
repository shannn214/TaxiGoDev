//
//  TaxiGoManager.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import TaxiGoDev

class TaxiGoManager {
    
    static let shared = TaxiGoManager()
    
    var taxiGo = TaxiGo()
    
    var authCode: String?
    
    func setup() {
        
        taxiGo.auth.appID = Constants.appID
        taxiGo.auth.appSecret = Constants.appSecret
        taxiGo.auth.redirectURL = Constants.redirectURL
        
    }
    
    func getAccessToken() {
        
        taxiGo.auth.getUserToken(success: { (auth) in
            
            let userDefaults = UserDefaults.standard
            
            userDefaults.setValue(auth.access_token, forKey: "access_token")
            userDefaults.setValue(auth.refresh_token, forKey: "refresh_token")
            userDefaults.synchronize()
            
        }) { (err) in
            print("Failed to get token: \(err.localizedDescription)")
        }
        
    }
    
    
    
}
