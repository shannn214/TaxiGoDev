//
//  GeocoderManager.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/26.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation

struct GeocoderManager {
    
    func requestAddress(lat: Double, lng: Double, completion: @escaping (String?) -> Void) {
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(lng)&key=AIzaSyAsTGKqYqUFXmAyAGFkj3Xr8AHyQI75U1E") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, err) in
            
            guard let response = response else { return }
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Address response: \(statusCode)")
            
            do {
                if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
                    print(json)
                    
                }
                
                completion("mmmmmm")
            } catch {
                print(err)
            }
            
            
        }
        task.resume()
    }
    
}
