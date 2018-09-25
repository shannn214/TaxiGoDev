//
//  UITextField.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/23.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setBottomBorder() {
        
        self.borderStyle = .none
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(displayP3Red: 253/255, green: 184/255, blue: 44/255, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        
    }
}
