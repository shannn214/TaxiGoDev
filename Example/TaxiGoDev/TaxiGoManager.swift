//
//  TaxiGoManager.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/11.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import TaxiGoDev

class TaxiGoManager {
    
    static let shared = TaxiGoManager()
    
    var taxiGo = TaxiGo()
    var accessToken = Constants.token
    var appID = Constants.appID
    var appSecret = Constants.appSecret
    var redirectURL = Constants.redirectURL
    var authCode = Constants.authCode
    var callBackUrlScheme = Constants.callBackUrlScheme
    
    func requestARide(startLatitude: Double,
                      startLongitude: Double,
                      startAddress: String,
                      endLatitude: Double?,
                      endLongitude: Double?,
                      endAddress: String?,
                      completion: @escaping (Error?, Ride?) -> Void) {
        
        taxiGo.api.requestARide(withAccessToken: accessToken,
                                startLatitude: startLatitude,
                                startLongitude: startLongitude,
                                startAddress: startAddress,
                                endLatitude: endLatitude,
                                endLongitude: endLongitude,
                                endAddress: endAddress,
                                success: { (ride) in
            
                                    let rideData = Ride(id: ride.id, start_latitude: ride.start_latitude, start_longitude: ride.start_longitude, start_address: ride.start_address, end_latitude: ride.end_latitude, end_longitude: ride.end_longitude, end_address: ride.end_address, request_time: ride.request_time, status: ride.status, driver: Driver(driver_id: ride.driver?.driver_id, driver_latitude: ride.driver?.driver_latitude, driver_longitude: ride.driver?.driver_longitude, eta: ride.driver?.eta, name: ride.driver?.name, plate_number: ride.driver?.plate_number, vehicle: ride.driver?.vehicle))
                                    
                                    completion(nil, rideData)
                                    
                                    
        }) { (err) in
            completion(err, nil)
        }
        
    }
    
}
