//
//  UIStoryboard.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static func mapStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Map", bundle: nil)
    }
    
    static func webStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Web", bundle: nil)
    }
    
    static func loginStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
}
