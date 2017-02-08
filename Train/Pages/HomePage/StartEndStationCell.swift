//
//  StartEndStationCell.swift
//  Train
//
//  Created by 张昭 on 10/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

enum StationType {
    case start
    case end
}

typealias StartBtnClosure = (_ stationType: StationType)->Void

class StartEndStationCell: UITableViewCell {

    @IBOutlet var startStationBtn: UIButton!
    @IBOutlet var endStationBtn: UIButton!
    @IBOutlet var changeStationImageView: UIImageView!
    
    var mClosure: StartBtnClosure?

    override func awakeFromNib() {
                super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

               // Configure the view for the selected state
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if touches.first?.view == changeStationImageView {
            startStationBtn.setTitle(endStationBtn.titleLabel?.text, for: .normal)
            endStationBtn.setTitle(startStationBtn.titleLabel?.text, for: .normal)
        }
    }
    
    @IBAction func clickedStartBtn(_ sender: UIButton) {
        mClosure!(.start)
    }
    @IBAction func clickedEndBtn(_ sender: UIButton) {
        mClosure!(.end)
    }
    
}
