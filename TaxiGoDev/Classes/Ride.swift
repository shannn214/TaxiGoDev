//
//  Ride.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/5.
//

import Foundation
import HandyJSON

extension TaxiGo.API {
    
    public class Ride: HandyJSON {
        
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
        
        public required init() {}
        
    }
    
    public class Driver: HandyJSON {
        
        var driver_id: Double?
        
        var driver_latitude: Double?
        
        var driver_longitude: Double?
        
        var eta: Double?
        
        var name: String?
        
        var plate_number: String?
        
        var vehicle: String?
        
        public required init() {}
        
    }
    
    public class Rider: HandyJSON {
        
        var name: String?
        
        var profile_img: String?
        
        var favorite: [Favorite]?
        
        public required init() {}
        
    }
    
    public class Favorite: HandyJSON {
        
        var address: String?
        
        var lat: Double?
        
        var lng: Double?
        
        public required init() {}

    }
    
    public class NearbyDrivers: HandyJSON {
        
        var lat: Double?
        
        var lng: Double?
        
        public required init() {}

    }
    
    public class RequestRideLocation: HandyJSON {
        
        var start_latitude: Double?
        
        var start_longitude: Double?
        
        var start_address: String?
        
        var end_latitude: Double?
        
        var end_longitude: Double?
        
        var end_address: String?
        
        public required init() {}

    }

    
}
