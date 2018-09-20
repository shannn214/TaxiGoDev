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
    
    public static let shared: TaxiGo = {
        let instance = TaxiGo()
        return instance
    }()
    
    public class API {
        
        public weak var taxiGoDelegate: TaxiGoAPIDelegate?
        
        public var id: String?
        
        weak var parent: TaxiGo! = nil

        var timer = Timer()
        
        var token: String?
                        
        public init() {}
        
        func call(withAccessToken: String, _ method: SHHTTPMethod, path: String, parameter: [String: Any], complete: ((Error?, [String: Any]?, [[String: Any]]?) -> Void)? = nil) -> URLSessionDataTask {
        
            let url = URL(string: "\(Constants.taxiGoUrl)" + "\(path)")
            let body = parameter
            let token = "Bearer \(withAccessToken)"
            
            var request = URLRequest(url: url!)
            request.httpMethod = method.rawValue
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.addValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
            
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
                print("=====")
                print("Status Code: \(statusCode)")
                
                DispatchQueue.main.async {
                
                    do {

                        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                            complete?(nil, json, nil)
                            
                        } else if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                            print(json)
                            complete?(nil, nil, json)
                        }

                    } catch {
                        
                        print(error)
                        complete?(error, nil, nil)
                        
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
        
        public init() {}
        
        func call(path: String, parameter: [String: Any], complete: ((Error? ,[String: Any]?) -> Void)? = nil) -> URLSessionDataTask {
            
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
                print("Status Code: \(statusCode)")
                print("=====")
                
                DispatchQueue.main.async {
                    
                    do {
                        
                        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
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
