//
//  CustomButton.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.style()
    }
    
    private func style() {
//        backgroundColor = UIColor.black
        layer.cornerRadius = 5
        alpha = 0.95
    }
    
    
}
