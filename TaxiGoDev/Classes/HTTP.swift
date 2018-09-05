//
//  HTTP.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation

enum SHHTTPMethod: String {
    
    case post = "POST"
    
    case get = "GET"
    
    case delete = "DELETE"
    
}

enum SHHTTPHeader: String {
    
    case authorization = "Authorization"
    
    case contentType = "Content-Type"
    
}

enum SHHTTPContentType: String {
    
    case json = "application/x-www-form-urlencoded"
    
}

