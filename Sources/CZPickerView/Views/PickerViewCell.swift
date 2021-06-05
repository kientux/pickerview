//
//  PickerViewCell.swift
//  
//
//  Created by Kien Nguyen on 05/06/2021.
//

import UIKit

class PickerViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailLabel.isHidden = true
        imgView.isHidden = true
        
        label.font = .systemFont(ofSize: 16)
        detailLabel.font = .systemFont(ofSize: 15)
        
        label.textColor = .text
        detailLabel.textColor = .primary
        
        label.numberOfLines = 2
        detailLabel.numberOfLines = 2
        
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        detailLabel.text = nil
        imgView.image = nil
    }
}
