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
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        
//        guard let webNav = UIStoryboard.webStoryboard().instantiateInitialViewController() as? UINavigationController else { return }
//
//        present(webNav, animated: true, completion: nil)
        guard let url = URL(string: "https://user.taxigo.com.tw/oauth/authorize?app_id=-LKPYysKDcIdNs7CLYa3&redirect_uri=taxigo-example://callback") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
