//
//  UIButton+Exts.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        if let color = color {
            setBackgroundImage(UIImage.from(color: color), for: state)
        } else {
            setBackgroundImage(nil, for: state)
        }
    }
}
