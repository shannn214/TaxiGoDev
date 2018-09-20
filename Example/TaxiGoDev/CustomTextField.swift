//
//  CustomTextField.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/10.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

protocol CustomTextFieldDelegate: class {
    func textFieldDidTap(_ controller: CustomTextField)
}

class CustomTextField: UITextField, UITextFieldDelegate {
    
    weak var tapDelegate: CustomTextFieldDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialSetup() {
        
        self.backgroundColor = UIColor.white
        self.alpha = 0.9
        self.borderStyle = .none
        self.font = UIFont(name: "HelveticaNeue", size: 14)
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.delegate = self
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.layer.cornerRadius = 5
        
        self.addTarget(self, action: #selector(triggerSearchAction), for: .touchDown)
        
    }
    
    @objc func triggerSearchAction() {
        self.tapDelegate?.textFieldDidTap(self)
    }
    
}
