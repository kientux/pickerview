//
//  CZTableView.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

class CZTableView: UITableView {
    var reloadEmptyStateCallback: (() -> Void)?
    
    override func reloadData() {
        super.reloadData()
        
        reloadEmptyStateCallback?()
    }
    
    override func endUpdates() {
        super.endUpdates()
        
        reloadEmptyStateCallback?()
    }
}
