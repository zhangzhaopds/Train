//
//  StudentTimeCell.swift
//  Train
//
//  Created by 张昭 on 12/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

class StudentTimeCell: UITableViewCell {

    @IBOutlet var mContentLabel: UILabel!
    @IBOutlet var mTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        if selected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
    
}
