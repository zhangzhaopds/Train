//
//  StartEndTimeCell.swift
//  Train
//
//  Created by 张昭 on 10/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

enum BtnType {
    case date
    case time
    case xibie
    case student
}

typealias StartEndCellBtnClosure = (_ type: BtnType) -> Void


class StartEndTimeCell: UITableViewCell {

    @IBOutlet var dateBtn: UIButton!
    
    @IBOutlet var timeBtn: UIButton!
    
    @IBOutlet var xibieBtn: UIButton!
    
    var mBtnClickedClosure: StartEndCellBtnClosure?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        let str = format.string(from: Date().addingTimeInterval(8.00 * 3600))
        dateBtn.setTitle(str, for: .normal)
    

    }

    @IBAction func clickedDateBtn(_ sender: UIButton) {
        mBtnClickedClosure!(.date)
    }
    @IBAction func clickedTimeBtn(_ sender: UIButton) {
        mBtnClickedClosure!(.time)
    }
    @IBAction func clickedXibieBtn(_ sender: UIButton) {
        mBtnClickedClosure!(.xibie)
    }
    @IBAction func clickedStudentBtn(_ sender: UIButton) {
        mBtnClickedClosure!(.student)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
