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


