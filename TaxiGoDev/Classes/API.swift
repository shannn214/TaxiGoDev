//
//  API.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation

public class TaxiGo {
    
    class API {
        
        let auth = Auth()
        
        func call(_ method: SHHTTPMethod, path: String?, parameter: [String: Any], complete: ((Error?, [String: Any]?, [[String: Any]]?) -> Void)? = nil) -> URLSessionDataTask {
        
            let url = URL(string: "\(Constants.taxiGoUrl)" + "\(path ?? "")")
            let body = parameter
            let token = "Bearer \(auth.accessToken)"
            
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
    
    class Auth {
        
        var appID: String?
        
        var appSecret: String?
        
        var authCode: String?
        
        var redirectURL: String?
        
        var accessToken: String?
        
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
