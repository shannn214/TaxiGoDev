//
//  UIViewController.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/25.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
