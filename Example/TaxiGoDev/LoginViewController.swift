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
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        
        guard let webNav = UIStoryboard.webStoryboard().instantiateInitialViewController() as? UINavigationController else { return }
        
        present(webNav, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
