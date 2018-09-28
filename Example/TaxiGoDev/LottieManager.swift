//
//  LottieManager.swift
//  TaxiGoDev_Example
//
//  Created by 尚靖 on 2018/9/28.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import Lottie

struct LottieManager {
    
    let animationView = LOTAnimationView(name: "scaling_loader")

    func playLottieAnimation(view: UIView) {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        
        view.addSubview(animationView)
        
        animationView.play()
        
    }
    
    func stopLottieAnimation() {
        animationView.stop()
    }
    
    
}
