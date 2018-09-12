//
//  Request.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation
import HandyJSON

public protocol TaxiGoAPIDelegate: class {
    func tripDidUpdate(status: String)
}

extension TaxiGo.API {
        
    public func requestARide(withAccessToken: String,
                             startLatitude: Double,
                             startLongitude: Double,
                             startAddress: String,
                             endLatitude: Double? = nil,
                             endLongitude: Double? = nil,
                             endAddress: String? = nil,
                             success: @escaping (Ride) -> Void, failure: @escaping (Error) -> Void) {
        
        let param: [String: Any] = ["start_latitude": startLatitude,
                                    "start_longitude": startLongitude,
                                    "start_address": startAddress,
                                    "end_latitude": endLatitude ?? "",
                                    "end_longitude": endLongitude ?? "",
                                    "end_address": endAddress ?? ""]
        
        call(withAccessToken: withAccessToken, .post, path: "/ride", parameter: param) { (err, dic, array) in
           
            if err == nil {

                if let ride = JSONDeserializer<Ride>.deserializeFrom(dict: dic) {
                    
//                    print(ride.toJSONString(prettyPrint: true))
                    guard let model = Ride.deserialize(from: dic) else { return }
                    self.id = model.id
                    success(model)
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.tripUpdate), userInfo: nil, repeats: true)


                }

            } else if let err = err {
                failure(err)
                print("QQ failed.")
                
            }
        }
        
    }
    
    public func cancelARide(withAccessToken: String, id: String, success: @escaping (Ride) -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .delete, path: "/ride/\(id)", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                print("Delete")
                guard let model = Ride.deserialize(from: dic) else { return }
                success(model)
                print(model)
                
            } else if let err = err {
                
                failure(err)
                print("Failed to delete.")
                
            }
            
        }
        
    }
 
    public func getRidesHistory(withAccessToken: String, success: @escaping (Ride) -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/ride", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                guard let model = Ride.deserialize(from: dic) else { return }
                success(model)

            } else if let err = err {
                failure(err)
                print("get history failed")
            }
            
        }
        
    }
    
    public func getSpecificRideHistory(withAccessToken: String, id: String, success: @escaping (Ride) -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/ride/\(id)", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                guard let model = Ride.deserialize(from: dic) else { return }
                success(model)
                
            } else if let err = err {
                failure(err)
                print("get specific ride history failed")
            }
            
        }
        
    }
    
    // NOTE: for observe status
    @objc func tripUpdate() {
        
        guard id != nil else { return }
        
        getSpecificRideHistory(withAccessToken: token, id: id!, success: { (ride) in
            
            // NOTE: can pass all the data outside
            self.taxiGoDelegate?.tripDidUpdate(status: ride.status!)
            
        }) { (err) in
            print("Can't get ride status")
        }

    }
    
    public func getRiderInfo(withAccessToken: String, success: @escaping (Rider) -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/me", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                guard let model = Rider.deserialize(from: dic) else { return }
                success(model)
                
            } else if let err = err {
                failure(err)
                print("get history failed")
            }

            
        }
        
    }
    
    public func getNearbyDriver(withAccessToken: String, lat: Double, lng: Double, success: @escaping ([NearbyDrivers?]) -> Void, failure: @escaping (Error) -> Void) {
        
        call(withAccessToken: withAccessToken, .get, path: "/driver?lat=\(lat)&lng=\(lng)", parameter: [:]) { (err, dic, array) in
            
            if err == nil {
                
                if let driver = [NearbyDrivers].deserialize(from: array) {
                    
                    driver.forEach({ (info) in
                        print(info?.lat)
                        print(info?.lng)
                    })
                    
                    success(driver)
                    
                }
                
            }
            
        }
        
    }
    
}

extension TaxiGo.Auth {
    
    public func ddgetUserToken(appID: String, appSecret: String, authCode: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
        
        let params = ["app_id": appID,
                      "app_secret": appSecret,
                      "code": authCode]
        
        call(path: "", parameter: params) { (err, dic) in
            
            if err == nil {
                
                // TODO: it will return access token, expire time, refesh token
                
            }
            
        }
        
    }
    
    public func ddrefreshToken(appID: String, appSecret: String, refreshToken: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
        
        let params = ["app_id": appID,
                      "app_secret": appSecret,
                      "refresh_token": refreshToken]
        
        call(path: "/refresh_token", parameter: params) { (err, dic) in
            
            if err == nil {
                
                // TODO: it will return access token, expire time
                
            }
            
        }
        
    }
    
}
