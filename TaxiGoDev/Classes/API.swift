//
//  API.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation
import HandyJSON

public class TaxiGo {
    
    public var api = API()
    
    public var auth = Auth()
    
    public init() {
        
        api.parent = self
        auth.parent = self
        
    }
    
    public static let shared = TaxiGo()
    
    public class API {
        
        public weak var taxiGoDelegate: TaxiGoAPIDelegate?
        
        public var id: String?

        public var url: String?
        
        public var apiKey: String?
        
        var startObserving: Bool = false
        
        weak var parent: TaxiGo! = nil

        var timer = Timer()
        
        var token: String?
        
        public init() {}
        
        func call(withAccessToken: String,
                  _ method: SHHTTPMethod,
                  path: String,
                  parameter: [String: Any],
                  complete: ((Error?, [String: Any]?, [[String: Any]]?, Int) -> Void)? = nil) -> URLSessionDataTask {
        
            guard let endPoint = self.url else { return URLSessionDataTask() }
            let url = URL(string: endPoint + "\(path)")
            let body = parameter
            let token = "Bearer \(withAccessToken)"
            
            var request = URLRequest(url: url!)
            request.httpMethod = method.rawValue
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.addValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
            guard let key = self.apiKey else { return URLSessionDataTask() }
            request.addValue(key, forHTTPHeaderField: "x-api-key")
            
            //send body
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                print("API request error")
            }
            
            //callback
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in

                guard let response = response else { return }
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                DispatchQueue.main.async {
                
                    do {

                        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                            if statusCode != 200 {
                                print(json) // NOTE: Only print error message.
                            }
                            complete?(nil, json, nil, statusCode)
                            
                        } else if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                            if statusCode != 200 {
                                print(json)
                            }
                            complete?(nil, nil, json, statusCode)
                        }

                    } catch {
                        
                        print(error)
                        complete?(error, nil, nil, statusCode)
                        
                    }
                
                }
                
            }
            task.resume()
            
            return task
            
        }
        
    }
    
    public class Auth {
        
        weak var parent: TaxiGo! = nil
        
        public var appID: String?
        
        public var appSecret: String?
        
        public var authCode: String?
        
        public var redirectURL: String?
        
        public var accessToken: String?
        
        public var refreshToken: String?
        
        public init() {}
        
        func call(path: String,
                  parameter: [String: Any],
                  complete: ((Error? ,[String: Any]?) -> Void)? = nil) -> URLSessionDataTask {
            
            let url = URL(string: "\(Constants.oauthURL)" + "\(path)")
            let body = parameter
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                print("Auth request error")
            }
            
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let response = response else { return }
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Auth Status Code: \(statusCode)")
                print("=====")
                
                DispatchQueue.main.async {
                    
                    do {
                        
                        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            if statusCode != 200 {
                                print(json) // NOTE: Only print error message.
                            }
                            complete?(nil, json)
                        }
                        
                    } catch {
                        
                        complete?(error, nil)
                        
                    }
                    
                }
                
            }
            task.resume()
            
            return task
            
        }
        
    }
    
}
