//
//  CZPickerViewDataSource.swift
//
//  Created by Kien Nguyen on 05/06/2021.
//

import Foundation
import UIKit

public protocol CZPickerViewDataSource: AnyObject {

    /** number of items for picker */
    func numberOfRows(in pickerView: CZPickerView) -> Int

    /**
     Implement at least one of the following method,
     CZPickerView:(CZPickerView *)pickerView
     attributedTitleForRow:(NSInteger)row has higer priority
    */
    
    /** attributed picker item title for each row */
    func czpickerView(_ pickerView: CZPickerView, attributedTitleForRow row: Int) -> NSAttributedString?

    /** picker item title for each row */
    func czpickerView(_ pickerView: CZPickerView, titleForRow row: Int) -> String?

    /** picker item detail title for each row */
    func czpickerView(_ pickerView: CZPickerView, detailTitleForRow row: Int) -> String?
    func czpickerView(_ pickerView: CZPickerView, attributedDetailTitleForRow row: Int) -> NSAttributedString?

    /** picker item image for each row */
    func czpickerView(_ pickerView: CZPickerView, imageForRow row: Int) -> UIImage?

    /** picker item image URL for each row */
    func czpickerView(_ pickerView: CZPickerView, imageURLForRow row: Int) -> URL?
}

/** Default implementations */
public extension CZPickerViewDataSource {
    
    func czpickerView(_ pickerView: CZPickerView, attributedTitleForRow row: Int) -> NSAttributedString? {
        nil
    }
    
    func czpickerView(_ pickerView: CZPickerView, titleForRow row: Int) -> String? {
        nil
    }
    
    func czpickerView(_ pickerView: CZPickerView, detailTitleForRow row: Int) -> String? {
        nil
    }
    
    func czpickerView(_ pickerView: CZPickerView, attributedDetailTitleForRow row: Int) -> NSAttributedString? {
        nil
    }
    
    func czpickerView(_ pickerView: CZPickerView, imageForRow row: Int) -> UIImage? {
        nil
    }
    
    func czpickerView(_ pickerView: CZPickerView, imageURLForRow row: Int) -> URL? {
        nil
    }
}
