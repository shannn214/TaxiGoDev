//
//  Ride.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/5.
//

import Foundation
import HandyJSON

extension TaxiGo.API {
    
    struct Ride: Codable {
        
        var id: String?
        
        var startLatitude: Double?
        
        var startLongitude: Double?
        
        var startAddress: String?
        
        var endLatitude: Double?
        
        var endLongitude: Double?
        
        var endAddress: String?
        
        var requestTime: Double?
        
        var status: String?
        
        var driver: Driver?
        
    }
    
    struct Driver {
        
        var driverId: Double?
        
        var driverLatitude: Double?
        
        var driverLongitude: Double?
        
        var eta: Double?
        
        var name: String?
        
        var plateNumber: String?
        
        var vehicle: String?
        
    }
    
    struct Rider {
        
        var name: String?
        
        var profileImg: String?
        
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
    
    struct RequestRideLocation {
        
        var startLatitude: Double?
        
        var startLongitude: Double?
        
        var startAddress: String?
        
        var endLatitude: Double?
        
        var endLongitude: Double?
        
        var endAddress: String?
        
    }

    
}
