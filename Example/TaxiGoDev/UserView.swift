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
        
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        
    }
    
}
