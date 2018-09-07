//
//  LoginViewController.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import TaxiGoDev

class LoginViewController: UIViewController {
    
    var taxiAPI = TaxiGo.API()
    
    var taxiAuth = TaxiGo.Auth()
    
    var taxi = TaxiGo()
    
    let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NjYzODE0OTMsImtleSI6IlUyRnNkR1ZrWDE5Ty9zdUZsTHR5WitENVIza1FTWjBoaGZ0ZmVVYW44blo1aWVaRmpLKytHbjdoUFMrZTl6M3crTk44dURJQ0RrWlkrRGFuT0xOOHd3PT0iLCJhcHBfaWQiOiItTEtQWXlzS0RjSWROczdDTFlhMyIsImlhdCI6MTUzNDg0NTQ5M30.zA7PfY4Q23_iBQ89M5n8VIpnA5ORqC8QXpuoVzDSBy8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taxiAuth.accessToken = accessToken
        
//        taxiAPI.getRidesHistory(withAccessToken: accessToken, success: {
//            print("success response of get rides history")
//        }) { (err) in
//            print(err.localizedDescription)
//        }
//

//        taxi.api.getSpecificRideHistory(withAccessToken: accessToken, id: "POyQHX", success: { (ride) in
//
//            guard let id = ride.id else { return }
//            print(id)
//            print(ride.driver?.driver_id)
//
//        }) { (err) in
//            print(err.localizedDescription)
//        }
        
//
//        taxiAPI.getRiderInfo(withAccessToken: accessToken, success: {
//            print("success access rider info")
//        }) { (err) in
//            print(err.localizedDescription)
//        }

//        taxiAPI.getNearbyDriver(withAccessToken: accessToken, lat: 25.0423, lng: 121.565, success: {
//            print("success access nearby driver")
//        }) { (err) in
//            print(err.localizedDescription)
//        }
        
        taxi.api.cancelARide(withAccessToken: accessToken, id: "jaKpva", success: { (ride) in
            print(ride.status)
            print(ride.id)
        }) { (err) in
            print(err.localizedDescription)
        }

//        taxiAPI.requestARide(withAccessToken: accessToken,
//                             startLatitude: 25.019946,
//                             startLongitude: 121.528717,
//                             startAddress: "台北市羅斯福路三段162號",
//                             success: { (ride) in
//            print("success")
//            print(ride.id)
//        }) { (err) in
//            print(err.localizedDescription)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
