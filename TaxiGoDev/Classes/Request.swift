//
//  Request.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation

extension TaxiGo.API {
    
    func requestARide(param: [String: Any], success: @escaping (Ride) -> Void, failure: @escaping (Error) -> Void) {
        
        call(.post, path: "/ride", parameter: param) { (err, dic, array) in
           
            if err == nil {

                // TODO: transfer dic and pass out
//                success(rideData(data: data))
                

                
            } else if let err = err {
                
                failure(err)
                print("QQ failed.")
                
            }
        }
        
    }
    
    func cancelARide(success: @escaping () -> Void, failure: @escaping () -> Void) {
        
    }
 
    func getRideHistory(success: @escaping () -> Void, failure: @escaping () -> Void) {
        
    }
    
    func getRiderInfo(success: @escaping () -> Void, failure: @escaping () -> Void) {
        
    }
    
    func getNearbyDriver(success: @escaping () -> Void, failure: @escaping () -> Void) {
        
    }
    
}
