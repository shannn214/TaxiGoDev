//
//  Date.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

//func updateTime(timeStamp: Double) -> String {
//
//    let time = timeStamp
//
//    let interval = TimeInterval(time)
//
//    let date = Date(timeIntervalSince1970: interval)
//
//    let dateFormatter = DateFormatter()
//
//    dateFormatter.dateFormat = "mm"
//
//    let nowDate = dateFormatter.string(from: date)
//
//    return nowDate
//
//}

func updateTime(timeStemp: Double) -> String {
    
    let time = timeStemp / 60
    
    let mins = Int(time)
    
    return "\(mins)"
    
}