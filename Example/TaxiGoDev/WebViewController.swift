//
//  TestViewController.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/18.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView = WKWebView()
    var cancelBtn = UIBarButtonItem()
    var progBar = UIProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        setNavBar()
        setProgBar()
        
    }
    // NOTE: URL!!
    private func initialSetup() {
        
        guard let url = URL(string: "https://user.taxigo.com.tw/oauth/authorize?app_id=-LKPYysKDcIdNs7CLYa3&redirect_uri=https://dev-user.taxigo.com.tw/oauth/test") else { return }
        guard let navHeight = self.navigationController?.navigationBar.frame.height else { return }
        let statusHeight = UIApplication.shared.statusBarFrame.height
        webView = WKWebView(frame: CGRect(x: 0, y: statusHeight + navHeight, width: self.view.frame.width, height: self.view.frame.height))
        let request = URLRequest(url: url)
        webView.load(request)
        self.view.addSubview(webView)
        
        webView.navigationDelegate = self

    }
    
    private func setNavBar() {
        
        cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cancelBtn
    
    }
    
    @objc private func cancel() {
    
        dismiss(animated: true) {
        }
    
    }
    
    private func setProgBar() {
        
        progBar = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        progBar.progress = 0.0
        progBar.tintColor = UIColor.black
        webView.addSubview(progBar)
        webView.addObserver(self, forKeyPath: "estProgress", options: NSKeyValueObservingOptions.new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estProgress" {
            progBar.alpha = 1
            progBar.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1 {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: { [weak self] in
                    self?.progBar.alpha = 0
                }) { [weak self] (finished) in
                    self?.progBar.progress = 0
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: "estProgress")
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    // MARK: We use WebKit delegate to access the success callback url which includes the auth code.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.navigationItem.title = self.webView.title
                
        guard let url = webView.url,
              let code = NSURLComponents(string: "\(url)")?.queryItems?.filter({ $0.name == "code" }).first,
              let authCode = code.value else { return }
        
        // MARK: Using auth code to request access token. Note that the authorization code will be expired after 60 minutes.
        taxiGo.auth.authCode = authCode
        TaxiGoManager.shared.getAccessToken()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true, completion: {
                let delegate = UIApplication.shared.delegate as? AppDelegate
                delegate?.window?.rootViewController = UIStoryboard.mapStoryboard().instantiateInitialViewController()
            })
        }
        
    }
    
}
