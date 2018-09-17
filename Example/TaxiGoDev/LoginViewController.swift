//
//  LoginViewController.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import TaxiGoDev
import SafariServices

class LoginViewController: UIViewController {

    var taxiGo = TaxiGo()

    @IBOutlet weak var loginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taxiGo.auth.appID = Constants.appID
        taxiGo.auth.appSecret = Constants.appSecret
        taxiGo.auth.redirectURL = Constants.redirectURL
        taxiGo.auth.authCode = Constants.authCode
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        
//        taxiGo.auth.startLoginFlow(success: { (url) in
//            print(url)
//        }) { (err) in
//            print("ffff")
//        }
        
//        taxiGo.auth.getUserToken(success: { (auth) in
//
//            print("The last layer response: ")
//            print(auth.access_token)
//            print(auth.token_expiry_date)
//            print(auth.refresh_token)
//        }) { (err) in
//            print("get token failed. \(err.localizedDescription)")
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
