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
        
        public var id: String?
        
        public var start_latitude: Double?
        
        public var start_longitude: Double?
        
        public var start_address: String?
        
        public var end_latitude: Double?
        
        public var end_longitude: Double?
        
        public var end_address: String?
        
        public var request_time: Double?
        
        public var status: String?
        
        public var driver: Driver?
        
        public required init() {}
        
    }
    
    public class Driver: HandyJSON {
        
        public var driver_id: Double?
        
        public var driver_latitude: Double?
        
        public var driver_longitude: Double?
        
        public var eta: Double?
        
        public var name: String?
        
        public var plate_number: String?
        
        public var vehicle: String?
        
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

    public class Oauth: HandyJSON {
    
        var accessToken: String?
        
        var expireIn: String?
        
        var refreshToken: String?
        
        public required init() {}
    
    }
    
}
