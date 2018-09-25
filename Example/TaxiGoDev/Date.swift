//
//  Date.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

func updateTime(timeStemp: Double) -> String {
    
    let time = timeStemp / 60
    
    let mins = Int(time)
    
    return "\(mins)"
    
}
