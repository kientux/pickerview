//
//  UIImage+Exts.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

extension UIImage {
    static func from(color: UIColor,
                     size: CGSize = CGSize(width: 1, height: 1),
                     cornerRadius: CGFloat = 0.0) -> UIImage? {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setFillColor(color.cgColor)
        
        if cornerRadius > 0 {
            UIBezierPath(roundedRect: rect,
                         cornerRadius: cornerRadius)
                .fill()
        } else {
            context.fill(rect)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
