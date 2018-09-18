//
//  DriverView.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/14.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

class DriverView: UIView {

    @IBOutlet var containView: UIView!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var driverInfoView: UIView!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var plateNumber: UILabel!
    @IBOutlet weak var eta: UILabel!
    @IBOutlet weak var vehicle: UILabel!
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    private func initialSetup() {
        
        Bundle.main.loadNibNamed("DriverView", owner: self, options: nil)
        addSubview(containView)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func initDriverView() {
        
        statusView.alpha = 1
        driverInfoView.alpha = 0
        status.text = "---"
        name.text = "---"
        plateNumber.text = "---"
        vehicle.text = "---"
        eta.text = "約 -- 分鐘後抵達"
        
    }

}
