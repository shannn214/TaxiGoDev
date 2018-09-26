//
//  GeocodingManager.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/26.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import CoreLocation

struct GeocodingManager {
    
    func getAddressFromGeo(lat: Double, lng: Double, completion: @escaping (String?) -> Void) {
        
        let geo = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lng)
        
        geo.reverseGeocodeLocation(location) { (placemarks, err) in
            
            if err != nil {
                print("Reverse geocode failed: \(err?.localizedDescription)")
            }
            
            guard let pm = placemarks else { return }
            
            if pm.count > 0 {
                
                guard let pm = placemarks?[0],
                    let locality = pm.locality,
                    let subAdm = pm.subAdministrativeArea,
                    let name = pm.name else { return }
                
                completion("\(subAdm)\(locality)\(name)")
            }
            
            
        }
        
    }
    
}
