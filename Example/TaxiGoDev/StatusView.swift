//
//  StatusView.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/13.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class StatusView: UIView {
    
    @IBOutlet var containView: UIView!
    
    @IBOutlet weak var StatusLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    private func initialSetup() {
        
        Bundle.main.loadNibNamed("StatusView", owner: self, options: nil)
        addSubview(containView)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    
    
}
