//
//  API.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation
import HandyJSON

public class TaxiGo {
    
    public init() {}
    
    public class API {
        
        let auth = Auth()
        
        public init() {}
        
        func call(_ method: SHHTTPMethod, path: String?, parameter: [String: Any], complete: ((Error?, [String: Any]?, [[String: Any]]?) -> Void)? = nil) -> URLSessionDataTask {
        
            let url = URL(string: "\(Constants.taxiGoUrl)" + "\(path ?? "")")
            let body = parameter
            let token = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NjYzODE0OTMsImtleSI6IlUyRnNkR1ZrWDE5Ty9zdUZsTHR5WitENVIza1FTWjBoaGZ0ZmVVYW44blo1aWVaRmpLKytHbjdoUFMrZTl6M3crTk44dURJQ0RrWlkrRGFuT0xOOHd3PT0iLCJhcHBfaWQiOiItTEtQWXlzS0RjSWROczdDTFlhMyIsImlhdCI6MTUzNDg0NTQ5M30.zA7PfY4Q23_iBQ89M5n8VIpnA5ORqC8QXpuoVzDSBy8"
            
            var request = URLRequest(url: url!)
            request.httpMethod = method.rawValue
            request.setValue(token, forHTTPHeaderField: "Authorization")
            request.addValue("application/json; charset=utf-8",
                             forHTTPHeaderField: "Content-Type")
            
            //send body
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                print("request error")
            }
            
            //callback
            let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let response = response else { return }
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("Status Code: \(statusCode)")
                print("=====")
                
                DispatchQueue.main.async {
                
                    do {

                        if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            complete?(nil, json, nil)
                        } else if let data = data, let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String: Any]] {
                            print(json)
                            print("====")
                            complete?(nil, nil, json)
                        }

                    } catch {

                        complete?(error, nil, nil)

                    }
                
                }
                
            }
            task.resume()
            
            return task
            
        }
        
    }
    
    public class Auth {
        
        public var appID: String?
        
        public var appSecret: String?
        
        public var authCode: String?
        
        public var redirectURL: String?
        
        public var accessToken: String?
        
        public init() {}
        
        func getUserToken(success: @escaping () -> Void, failure: @escaping () -> Void) {
            
            guard let url = URL(string: Constants.oauthURL) else { return }
            let session = URLSession.shared
            let parasDictionary = ["app_id": appID,
                                   "app_secret": appSecret,
                                   "code": authCode]
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parasDictionary, options: []) else { return }
            
            request.httpBody = httpBody
            
            session.dataTask(with: request) { (data, response, error) in
                
                guard let response = response else { return }
                
                print(response)
                print("========")
                
                guard let data = data else { return }
                
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    // TODO: success() pass data
                    
                } catch {
                    
                    print(error)
                    // TODO: handle error
                    
                }
                }.resume()
            
        }
        
    }
    
    
    
}
