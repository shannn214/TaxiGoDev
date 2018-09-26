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
    
    func presentAlert(title: String, message: String?, cancel: Bool, handler: ((UIAlertAction) -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: handler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            return
        })
        alertController.addAction(OKAction)
        if cancel {
            alertController.addAction(cancelAction)
        }
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
