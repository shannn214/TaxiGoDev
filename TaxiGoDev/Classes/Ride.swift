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
        
        public var name: String?
        
        public var profile_img: String?
        
        public var favorite: [Favorite]?
        
        public required init() {}
        
    }
    
    public class Favorite: HandyJSON {
        
        public var address: String?
        
        public var lat: Double?
        
        public var lng: Double?
        
        public required init() {}

    }
    
    public class NearbyDrivers: HandyJSON {
        
        public var lat: Double?
        
        public var lng: Double?
        
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

extension TaxiGo.Auth {

    public class Oauth: HandyJSON {
        
        public var access_token: String?
        
        public var token_expiry_date: String?
        
        public var refresh_token: String?
        
        public var refresh_token_expiry_date: String?
        
        public required init() {}
        
    }
    
    public class RefreshToken: HandyJSON {
        
        public var access_token: String?
        
        public var expires_in: String?
        
        public required init() {}
        
    }
    
}
