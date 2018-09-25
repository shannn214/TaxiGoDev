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
    @IBOutlet weak var hamburger: UIButton!
    
    weak var searchViewDelegate: SearchViewDelegate?
    
    private var shadowLayer: CAShapeLayer!
    
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
        fromTextField.addTarget(self, action: #selector(triggerSearchAction), for: .touchDown)
        toTextField.addTarget(self, action: #selector(triggerSearchAction), for: .touchDown)
        fromTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: fromTextField.frame.height))
        fromTextField.leftViewMode = .always
        toTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: toTextField.frame.height))
        toTextField.leftViewMode = .always

        fromTextField.attributedPlaceholder = NSAttributedString(string: "Current place", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 253/255, green: 184/255, blue: 44/255, alpha: 0.5)])
        
        toTextField.attributedPlaceholder = NSAttributedString(string: "Where to?", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 253/255, green: 184/255, blue: 44/255, alpha: 0.5)])
            
        fromTextField.setBottomBorder()
        toTextField.setBottomBorder()

    }
    
    override func layoutSubviews() {
        
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: -1, height: 2)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 2
        self.layer.insertSublayer(shadowLayer, at: 0)
        
    }
    
    @objc func triggerSearchAction(sender: UITextField) {
        
        self.searchViewDelegate?.textFieldDidTap(sender: sender)
        
    }
    
    @IBAction func favBtn(_ sender: Any) {
        
        self.searchViewDelegate?.favBtnDidTap()
        
    }
    
    @IBAction func hamburgerAction(_ sender: Any) {
    
    }
    
}

