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
    
    let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NjYzODE0OTMsImtleSI6IlUyRnNkR1ZrWDE5Ty9zdUZsTHR5WitENVIza1FTWjBoaGZ0ZmVVYW44blo1aWVaRmpLKytHbjdoUFMrZTl6M3crTk44dURJQ0RrWlkrRGFuT0xOOHd3PT0iLCJhcHBfaWQiOiItTEtQWXlzS0RjSWROczdDTFlhMyIsImlhdCI6MTUzNDg0NTQ5M30.zA7PfY4Q23_iBQ89M5n8VIpnA5ORqC8QXpuoVzDSBy8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taxiAuth.accessToken = accessToken
        fakeSendLocationBtn(startLatitude: 25.019946, startLongitude: 121.528717, startAddress: "台北市羅斯福路三段162號")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fakeSendLocationBtn(startLatitude: Double,
                             startLongitude: Double,
                             startAddress: String,
                             endLatitude: Double? = nil,
                             endLongitude: Double? = nil,
                             endAddress: String? = nil) {
        
        let param: [String: Any] = ["start_latitude": startLatitude,
                                    "start_longitude": startLongitude,
                                    "start_address": startAddress,
                                    "end_latitude": endLatitude,
                                    "end_longitude": endLongitude,
                                    "end_address": endAddress]
        
        taxiAPI.requestARide(param: param, success: { (ride) in
            print(ride)
            print("success")
        }) { (err) in
            print(err.localizedDescription)
        }
        
    }

}
