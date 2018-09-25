//
//  TaxiGo.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/11.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

struct Ride {
    
    var id: String?
    
    var start_latitude: Double?
    
    var start_longitude: Double?
    
    var start_address: String?
    
    var end_latitude: Double?
    
    var end_longitude: Double?
    
    var end_address: String?
    
    var request_time: Double?
    
    var status: String?
    
    var driver: Driver?
    
}

struct Driver {
    
    var driver_id: Double?
    
    var driver_latitude: Double?
    
    var driver_longitude: Double?
    
    var eta: Double?
    
    var name: String?
    
    var plate_number: String?
    
    var vehicle: String?
    
}

struct Rider {
    
    var name: String?
    
    var profile_img: String?
    
    var favorite: [Favorite]?
    
}

struct Favorite {
    
    var address: String?
    
    var lat: Double?
    
    var lng: Double?
    
}

struct NearbyDrivers {
    
    var lat: Double?
    
    var lng: Double?
    
}

enum Status: String, CaseIterable {
    
    case waitingSpecify = "WAITING_SPECIFY"
    case requestingDriver = "REQUESTING_DRIVER"
    case pendingResponseDriver = "PENDING_RESPONSE_DRIVER"
    case driverReserved = "DRIVER_RESERVED"
    case driverEnroute = "DRIVER_ENROUTE"
    case driverArrived = "DRIVER_ARRIVED"
    case tripStarted = "TRIP_STARTED"
    case tripFinished = "TRIP_FINISHED"
    case tripPaymentProcessed = "TRIP_PAYMENT_PROCESSED"
    case tripCanceled = "TRIP_CANCELED"
    
    var status: String {
        switch self {
        case .driverArrived:
            return "司機已抵達"
        case .driverEnroute:
            return "司機前往中"
        case .tripCanceled:
            return "行程已取消"
        case .tripStarted:
            return "行程已開始"
        case .tripFinished:
            return "行程已完成"
        case .pendingResponseDriver, .waitingSpecify, .requestingDriver:
            return "等候司機接單"
        case .driverReserved:
            return "司機已接單"
        case .tripPaymentProcessed:
            return "支付款項中"
        }
    }
    
}


