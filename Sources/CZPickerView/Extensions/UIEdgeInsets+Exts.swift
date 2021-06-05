//
//  UIEdgeInsets+Exts.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

extension UIEdgeInsets {
    
    static func left(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
    }
    
    static func right(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
    }
    
    static func top(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
    }
    
    static func bottom(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: inset, right: 0)
    }
    
    static func all(_ inset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
