//
//  Request.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation
import HandyJSON
import SafariServices

public protocol TaxiGoAPIDelegate: class {
    func rideDidUpdate(status: String, ride: TaxiGo.API.Ride)
}

extension TaxiGo.API {
        
    public func requestARide(withAccessToken: String,
                             startLatitude: Double,
                             startLongitude: Double,
                             startAddress: String,
                             endLatitude: Double? = nil,
                             endLongitude: Double? = nil,
                             endAddress: String? = nil,
                             success: @escaping (Ride, Int) -> Void, failure: @escaping (Error, Int) -> Void) {
        
        let param: [String: Any] = ["start_latitude": startLatitude,
                                    "start_longitude": startLongitude,
                                    "start_address": startAddress,
                                    "end_latitude": endLatitude ?? "",
                                    "end_longitude": endLongitude ?? "",
                                    "end_address": endAddress ?? ""]
        
        call(withAccessToken: withAccessToken, .post, path: "/ride", parameter: param) { [weak self] (err, dic, array, response) in
           
            if err == nil {

                guard let self = self else { return }
                guard let model = Ride.deserialize(from: dic) else { return }
                self.id = model.id
                success(model, response)
                
                self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.tripUpdate), userInfo: nil, repeats: true)

            } else if let err = err {
                failure(err, response)
                print("Failed to request a ride.")
                
            }
        }
        
    }
    
    public func cancelARide(withAccessToken: String,
                            id: String,
                            success: @escaping (Ride, Int) -> Void,
                            failure: @escaping (Error, Int) -> Void) {
        
        call(withAccessToken: withAccessToken, .delete, path: "/ride/\(id)", parameter: [:]) { (err, dic, array, response) in
            
            if err == nil {
                
                guard let model = Ride.deserialize(from: dic) else { return }
                success(model, response)
                print(model)
                
            } else if let err = err {
                
                failure(err, response)
                print("Failed to delete.")
                
            }
            
        }
        
    }
 
    public func getRidesHistory(withAccessToken: String,
                                success: @escaping (Ride, Int) -> Void,
                                failure: @escaping (Error, Int) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/ride", parameter: [:]) { (err, dic, array, response) in
            
            if err == nil {
                
                guard let model = Ride.deserialize(from: dic) else { return }
                success(model, response)

            } else if let err = err {
                
                failure(err, response)
                print("Failed to get the history.")
                
            }
            
        }
        
    }
    
    public func getSpecificRideHistory(withAccessToken: String,
                                       id: String,
                                       success: @escaping (Ride, Int) -> Void,
                                       failure: @escaping (Error, Int) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/ride/\(id)", parameter: [:]) { (err, dic, array, response) in
            
            if err == nil {
                
                guard let model = Ride.deserialize(from: dic) else { return }
                success(model, response)
                
            } else if let err = err {
                
                failure(err, response)
                print("Failed to get the specific ride history.")
            
            }
            
        }
        
    }
    
    // NOTE: for observe status
    @objc func tripUpdate() {
        
        guard let rideID = id, let token = TaxiGo.shared.auth.accessToken else { return }
        
        getSpecificRideHistory(withAccessToken: token, id: rideID, success: { [weak self] (ride, response) in
            
            guard let self = self, let status = ride.status else { return }

            if ride.status == "TRIP_CANCELED" || ride.status == "TRIP_FINISHED" || ride.status == "TRIP_PAYMENT_PROCESSED" {
                self.taxiGoDelegate?.rideDidUpdate(status: status, ride: ride)
                self.timer.invalidate()
                self.id = nil
            } else {
                self.taxiGoDelegate?.rideDidUpdate(status: status, ride: ride)
            }
            
        }) { (err, response) in
            print("Failed to get the ride status.")
        }

    }
    
    public func getRiderInfo(withAccessToken: String,
                             success: @escaping (Rider, Int) -> Void,
                             failure: @escaping (Error, Int) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/me", parameter: [:]) { (err, dic, array, response) in
            
            if err == nil {
                
                guard let model = Rider.deserialize(from: dic) else { return }
                success(model, response)
                
            } else if let err = err {
                
                failure(err, response)
                print("Failed to get the history.")
                
            }

            
        }
        
    }
    
    public func getNearbyDriver(withAccessToken: String,
                                lat: Double,
                                lng: Double,
                                success: @escaping ([NearbyDrivers?], Int) -> Void,
                                failure: @escaping (Error, Int) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/driver?lat=\(lat)&lng=\(lng)", parameter: [:]) { (err, dic, array, response) in
            
            if err == nil {
                
                if let driver = [NearbyDrivers].deserialize(from: array) {
                    
                    success(driver, response)
                    
                } else if let err = err {
                    
                    failure(err, response)
                    print("Failed to get nearby drivers. Error: \(err.localizedDescription)")
                    
                }
                
            }
            
        }
        
    }
    
}

extension TaxiGo.Auth {
    
    public func getUserToken(success: @escaping (Oauth) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        if appID == nil || appSecret == nil || authCode == nil {
            let msg = "Request token API should be provided your app_id, app_secret and auth_code in TaxiGoDev properties."
            fatalError(msg)
        }
        
        let params = ["app_id": appID,
                      "app_secret": appSecret,
                      "code": authCode]
        
        call(path: "", parameter: params) { [weak self] (err, dic) in
            
            if err == nil {
                
                guard let auth = Oauth.deserialize(from: dic), let self = self else { return }
                self.accessToken = auth.access_token
                success(auth)
                
            } else if let err = err {
                failure(err)
            }
            
        }
        
    }
    
    public func refreshToken(success: @escaping (RefreshToken) -> Void,
                             failure: @escaping (Error) -> Void) {
        
        let params = ["app_id": appID,
                      "app_secret": appSecret,
                      "refresh_token": refreshToken]
        
        call(path: "/refresh_token", parameter: params) { [weak self] (err, dic) in
            
            if err == nil {
                
                guard let refreshToken = RefreshToken.deserialize(from: dic), let self = self else { return }
                self.accessToken = refreshToken.access_token
                success(refreshToken)
                
            } else if let err = err {
                failure(err)
            }
            
        }
        
    }
    
}
