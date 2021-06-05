//
//  RoundedShadowView.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

class RoundedShadowView: UIView {
    private var shadowLayer: CAShapeLayer?
    
    var cornerRadius: CGFloat = 6.0
    var shadowColor: UIColor?
    var shadowOpacity: Float = 0.15
    var shadowRadius: CGFloat = 4
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            let shadowLayer = CAShapeLayer()
            self.shadowLayer = shadowLayer
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds,
                                            cornerRadius: cornerRadius).cgPath
            
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = shadowColor?.cgColor ?? UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = .zero
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowRadius = shadowRadius
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
