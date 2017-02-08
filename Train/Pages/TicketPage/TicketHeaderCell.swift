//
//  TicketHeaderCell.swift
//  Train
//
//  Created by 张昭 on 13/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

class TicketHeaderCell: UITableViewCell {

    @IBOutlet var mXibieFourLabel: UILabel!
    @IBOutlet var mXibieThreeLabel: UILabel!
    @IBOutlet var mXibieTwoLabel: UILabel!
    @IBOutlet var mXibieOneLabel: UILabel!
    @IBOutlet var mEndStationLabel: UILabel!
    @IBOutlet var mEndTimeLabel: UILabel!
    @IBOutlet var mSpendTimeLabel: UILabel!
    @IBOutlet var mTrainCodeLabel: UILabel!
    @IBOutlet var mStartStationLabel: UILabel!
    @IBOutlet var mStartTimeLabel: UILabel!
    
    var mData: QueryLeftNewDTO? {
        
        didSet {
            
            mStartStationLabel.text = mData?.FromStationName
            mEndStationLabel.text = mData?.ToStationName
            
            mStartTimeLabel.text = mData?.start_time
            mEndTimeLabel.text = mData?.arrive_time
            
            mTrainCodeLabel.text = mData?.TrainCode
            mSpendTimeLabel.text = mData?.lishi

            if (mData?.seatTypePairDic.keys.count)! > 0 {
                
                mXibieOneLabel.text = mData?.seatTypePairDic.keys.reduce("", { (a, b) -> String in
                    a + " " + b
                })
            } else {
                mXibieOneLabel.textColor = .red
                mXibieOneLabel.text = "当前车次已无票可售"
                mXibieOneLabel.textAlignment = .right
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
