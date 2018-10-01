//
//  NewSearch.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/10/1.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class NewSearch: UIView {

    @IBOutlet var containView: UIView!
    @IBOutlet weak var topSearch: UISearchBar!
    @IBOutlet weak var bottomSearch: UISearchBar!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    func initialSetup() {
        
        Bundle.main.loadNibNamed("NewSearch", owner: self, options: nil)
        addSubview(containView)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    

}
