//
//  SquircleRoundedView.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

class SquircleRoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        } else {
            // Create a mask layer.
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            // Define our path, capitalizing on UIKit's corner rounding magic.
            let newPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius)
            maskLayer.path = newPath.cgPath
            // Apply the mask.
            self.layer.mask = maskLayer
        }
    }
}
