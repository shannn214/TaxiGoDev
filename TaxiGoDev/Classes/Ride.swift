//
//  Ride.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/5.
//

import Foundation
import HandyJSON

extension TaxiGo.API {
    
    class Ride: HandyJSON {
        
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
        
        required init() {}
        
    }
    
    class Driver: HandyJSON {
        
        var driverId: Double?
        
        var driverLatitude: Double?
        
        var driverLongitude: Double?
        
        var eta: Double?
        
        var name: String?
        
        var plateNumber: String?
        
        var vehicle: String?
        
        required init() {}
        
    }
    
    class Rider: HandyJSON {
        
        var name: String?
        
        var profileImg: String?
        
        var favorite: [Favorite]?
        
        required init() {}
        
    }
    
    class Favorite: HandyJSON {
        
        var address: String?
        
        var lat: Double?
        
        var lng: Double?
        
        required init() {}

    }
    
    class NearbyDrivers: HandyJSON {
        
        var lat: Double?
        
        var lng: Double?
        
        required init() {}

    }
    
    class RequestRideLocation: HandyJSON {
        
        var startLatitude: Double?
        
        var startLongitude: Double?
        
        var startAddress: String?
        
        var endLatitude: Double?
        
        var endLongitude: Double?
        
        var endAddress: String?
        
        required init() {}

    }

    
}
