//
//  AddPassengerCell.swift
//  Train
//
//  Created by 张昭 on 10/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

typealias SubmitQueryClosure = (_ sender: UIButton) -> Void

class AddPassengerCell: UITableViewCell {

    var mSubmitBtnClosure: SubmitQueryClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.selectionStyle = .none
    }
    
    @IBAction func clickedSubmitBtn(_ sender: UIButton) {
        mSubmitBtnClosure!(sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
