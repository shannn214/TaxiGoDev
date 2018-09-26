//
//  UserView.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/25.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class UserView: UIView {

    @IBOutlet var containView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var bgUserImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    func initialSetup() {
        
        Bundle.main.loadNibNamed("UserView", owner: self, options: nil)
        addSubview(containView)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panUserView(panGesture:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        
    }
    
    @objc func panUserView(panGesture: UIPanGestureRecognizer) {
        
        let trans = panGesture.translation(in: self.window)
        
        switch panGesture.state {
            
        case .changed:
            
            if trans.x < 0 {
                
                self.frame = CGRect(x: trans.x,
                                    y: 0,
                                    width: self.frame.size.width,
                                    height: self.frame.size.height)
                
            }
            
        case .cancelled, .ended:

            if self.frame.origin.x < -(self.frame.size.width / 4) {
            
                UIView.animate(withDuration: 0.3) {
                    self.frame = CGRect(x: -(self.frame.size.width),
                                        y: 0,
                                        width: self.frame.size.width,
                                        height: self.frame.size.height)
                }
                
            } else {

                UIView.animate(withDuration: 0.3) {
                    self.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.frame.size.width,
                                        height: self.frame.size.height)
                }

            }
        
        default:
            break
        }
        
    }
    
}
