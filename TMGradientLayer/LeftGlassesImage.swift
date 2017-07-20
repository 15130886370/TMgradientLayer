//
//  LeftGlassesImage.swift
//  TMGradientLayer
//
//  Created by ittmomWang on 2017/7/20.
//  Copyright © 2017年 ittmomProject. All rights reserved.
//

import UIKit

class LeftGlassesImage: UIImageView {

    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.6)
        
        let colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.colors = colors
        
        let locations: [NSNumber] = [
            -0.4,
            -0.39,
            -0.24,
            -0.23
        ]
        gradientLayer.locations = locations
        
        return gradientLayer
    }()
    
    
    override func layoutSubviews() {
        gradientLayer.frame = CGRect(
            x: -5,
            y: 0,
            width:  bounds.size.width ,
            height: bounds.size.height)
        
        layer.addSublayer(gradientLayer)
        
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = [ -0.8,
                                        -0.79,
                                        -0.64,
                                        -0.63]
        gradientAnimation.toValue = [1.5,1.51,1.76,1.77]
        gradientAnimation.duration = 1.0
        gradientAnimation.repeatCount = 2
        
        
        gradientLayer.add(gradientAnimation, forKey: nil)
    }

}
