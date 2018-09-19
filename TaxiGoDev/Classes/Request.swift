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
    func rideDidUpdate(status: String)
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
                
                // NOTE: timer stop too early, need to update status in another way (in order to update the text status on UI)
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
        
        getSpecificRideHistory(withAccessToken: parent.auth.accessToken!, id: id!, success: { (ride) in
            
            // NOTE: can pass all the data outside
            if ride.status == "TRIP_CANCELED" {
                self.taxiGoDelegate?.rideDidUpdate(status: ride.status!)
                self.timer.invalidate()
                self.id = nil
            } else {
                self.taxiGoDelegate?.rideDidUpdate(status: ride.status!)
            }
            
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
    
    public func startLoginFlow(success: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        
        guard let url = URL(string: "https://user.taxigo.com.tw/oauth/authorize?app_id=-LKPYysKDcIdNs7CLYa3&redirect_uri=https://dev-user.taxigo.com.tw/oauth/test") else { return }
        
        self.authSession = SFAuthenticationSession(url: url, callbackURLScheme: nil, completionHandler: { (url, err) in
            
//            guard err == nil else { return }
            
            print(url)
            print("-------")
            
            success("\(url)")
            
        })
        self.authSession?.start()
        
    }
    
    public func getUserToken(success: @escaping (Oauth) -> Void, failure: @escaping (Error) -> Void) {
        
        let params = ["app_id": appID,
                      "app_secret": appSecret,
                      "code": authCode]
        
        call(path: "", parameter: params) { (err, dic) in
            
            if err == nil {
                
                guard let auth = Oauth.deserialize(from: dic) else { return }
                self.accessToken = auth.access_token
                success(auth)
                
            }
            
        }
        
    }
    
    public func refreshToken(appID: String, appSecret: String, refreshToken: String, success: @escaping (Oauth) -> Void, failure: @escaping (Error) -> Void) {
        
        let params = ["app_id": appID,
                      "app_secret": appSecret,
                      "refresh_token": refreshToken]
        
        call(path: "/refresh_token", parameter: params) { (err, dic) in
            
            if err == nil {
                
                guard let refreshToken = Oauth.deserialize(from: dic) else { return }
                self.accessToken = refreshToken.access_token
                success(refreshToken)
                
            }
            
        }
        
    }
    
}
