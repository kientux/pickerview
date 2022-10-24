//
//  UIImage+Exts.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import Foundation

extension Bundle {
    private static let bundleName = "CZPickerView"
    
    static var resource: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        // Get the bundle containing the binary with the current class.
        // If frameworks are used, this is the frameworks bundle (.framework),
        // if static libraries are used, this is the main app bundle (.app).
        let myBundle = Bundle(for: CZPickerView.self)

        // Get the URL to the resource bundle within the bundle
        // of the current class.
        guard let resourceBundleURL = myBundle.url(
            forResource: bundleName, withExtension: "bundle") else {
            return myBundle
        }

        // Create a bundle object for the bundle found at that URL.
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            return myBundle
        }
        
        return resourceBundle
        #endif
    }
}
