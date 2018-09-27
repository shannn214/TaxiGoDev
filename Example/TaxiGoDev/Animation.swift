//
//  Animation.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

func fadeInAnimation(view: UIView) {
    
    UIView.animate(withDuration: 0.35) {
        view.alpha = 1
    }
    
}

func fadeOutAnimation(view: UIView) {
    
    UIView.animate(withDuration: 0.35) {
        view.alpha = 0
    }
    
}


