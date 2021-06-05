//
//  UIColor+Exts.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
}

extension UIColor {
    
    static let primary = UIColor(r: 0, g: 136, b: 255)
    static let error = UIColor(r: 241, g: 64, b: 75)
    
    static let tableSeparator = UIColor(r: 228, g: 230, b: 239)
    static var text = UIColor(r: 52, g: 55, b: 65)
    static var grayText = UIColor(r: 143, g: 144, b: 150)
    
    static var buttonHighlight = UIColor(white: 0, alpha: 0.065)
}
