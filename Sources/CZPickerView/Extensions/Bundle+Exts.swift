//
//  UIImage+Exts.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import Foundation

extension Bundle {
    static var resource: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: CZPickerView.self)
        #endif
    }
}
