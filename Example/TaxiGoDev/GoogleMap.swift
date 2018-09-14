//
//  GoogleMap.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

extension GMSMapView {
    
    func mapStyle(withFileName name: String, andType type: String) {
        
        do {
            
            if let styleUrl = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleUrl)
            } else {
                NSLog("Unable to find style.json")
            }
            
        } catch {
            
            NSLog("One or more of the map styles failed to load.")
            
        }
        
    }
    
}
