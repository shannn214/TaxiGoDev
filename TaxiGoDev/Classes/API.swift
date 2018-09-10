//
//  API.swift
//  Pods-TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/4.
//

import Foundation
import HandyJSON
import SafariServices

public class TaxiGo {
    
    public var api = API()
    
    public var auth = Auth()
    
    public init() {}
    
    public class API {
        
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
        
        public var authSession: SFAuthenticationSession?
        
//        private var redirectUri = "https://dev-user.taxigo.com.tw/oauth/test"
        
        public init() {}
        
        func call(path: String, parameter: [String: Any], complete: ((Error? ,[String: Any]?) -> Void)? = nil) -> URLSessionDataTask {
            
            let url = URL(string: "\(Constants.oauthURL)" + "\(path)")
            let body = parameter
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                print("request error")
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
        
        public func startLoginFlow(callBackUrlScheme: String, success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
            
            guard let authURL = URL(string: "https://user.taxigo.com.tw/oauth/authorize?app_id=" + "\(appID)" + "&redirect_uri=" + "\(redirectURL)") else { return }
            
            self.authSession = SFAuthenticationSession(url: authURL, callbackURLScheme: callBackUrlScheme, completionHandler: { (callBack: URL?, error: Error?) in
                
                guard error == nil, let successURL = callBack else {
                    print(error!)
                    print("=======")
                    return }
                
                let callBackRedirect = NSURLComponents(string: successURL.absoluteString)?.queryItems?.filter({ $0.name == "code" }).first
                
                print(callBackRedirect)
                
            })
            self.authSession?.start()
            
        }
        
    }
    
    
    
}