//
//  SearchView.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/11.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

protocol SearchViewDelegate: class {
    func textFieldDidTap(sender: UITextField)
    
    func favBtnDidTap()
}

class SearchView: UIView {

    @IBOutlet var containView: UIView!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var favButton: UIButton!
    
    weak var searchViewDelegate: SearchViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    private func initialSetup() {
        
        Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)
        addSubview(containView)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        fromTextField.layer.cornerRadius = 3
        toTextField.layer.cornerRadius = 3
        fromTextField.addTarget(self, action: #selector(triggerSearchAction), for: .touchDown)
        toTextField.addTarget(self, action: #selector(triggerSearchAction), for: .touchDown)
        
    }
    
    @objc func triggerSearchAction(sender: UITextField) {
        
        self.searchViewDelegate?.textFieldDidTap(sender: sender)
        
    }
    
    @IBAction func favBtn(_ sender: Any) {
        
        self.searchViewDelegate?.favBtnDidTap()
        
    }
    
}
