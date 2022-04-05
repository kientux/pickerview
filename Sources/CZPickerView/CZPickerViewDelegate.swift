//
//  CZPickerViewDelegate.swift
//  Sapo
//
//  Created by Kien Nguyen on 05/06/2021.
//  Copyright © 2021 Sapo Technology JSC. All rights reserved.
//

import Foundation
import UIKit

public protocol CZPickerViewDelegate: AnyObject {

    /** delegate method for picking one item */
    func czpickerView(_ pickerView: CZPickerView, didConfirmWithItemAtRow row: Int)

    /**
     delegate method for picking multiple items,
     implement this method if `allowMultipleSelection` is true
     */
    func czpickerView(_ pickerView: CZPickerView, didConfirmWithItemsAtRows rows: [Int])

    /** delegate method for clicking confirm button */
    func czpickerViewDidClickConfirmButton(_ pickerView: CZPickerView)

    /** delegate method for canceling */
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView)

    /** delegate method for searching from search field */
    func czpickerView(_ pickerView: CZPickerView, searching searchText: String)

    func czpickerViewDidDismissWhenTappingOutSide()

}

/** Default implementations */
public extension CZPickerViewDelegate {
    
    func czpickerView(_ pickerView: CZPickerView, didConfirmWithItemAtRow row: Int) {}
    
    func czpickerView(_ pickerView: CZPickerView, didConfirmWithItemsAtRows rows: [Int]) {}
    
    func czpickerViewDidClickConfirmButton(_ pickerView: CZPickerView) {}
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView) {}
    
    func czpickerView(_ pickerView: CZPickerView, searching searchText: String) {}
    
    func czpickerViewDidDismissWhenTappingOutSide() {}
}
