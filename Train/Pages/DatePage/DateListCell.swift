//
//  DateListCell.swift
//  Train
//
//  Created by 张昭 on 12/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

enum MonthSelect {
    case current
    case next
}



typealias DateSelectedClosure = (_ date: String) -> Void

class DateListCell: UITableViewCell {
    
    @IBOutlet var backPageBtn: UIButton!
    @IBOutlet var nextPageBtn: UIButton!
    @IBOutlet var dateBgView: UIView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    
    var mDateSelectedClosure: DateSelectedClosure?
    var mPresell: Int? {
        didSet {
            mPresellData = handlePresell(mPresell!)
            mData = handleDate(.current)
        }
    }
    var mPresellData: [DateComponents]? = [DateComponents]()
    var mDateBtnArr: [UIButton]? = [UIButton]()
    var mData: [DateComponents]? {
        didSet {
            if mData?.count == 42 && mDateBtnArr?.count == 42 {
                for button in mDateBtnArr! {
                    let comp = mData?[button.tag]
                    button.setTitle("\((comp?.day!)!)", for: .normal)
                    if !(mPresellData?.contains(comp!))! {
                        button.isEnabled = false
                        button.setTitleColor(.gray, for: .normal)
                    } else {
                        button.isEnabled = true
                        button.setTitleColor(.black, for: .normal)
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
//        isSelected = false
        
        mDateBtnArr = dateBgView.subviews.sorted(by: { (a, b) -> Bool in
            return a.tag < b.tag
        }) as? [UIButton]
        
        mPresellData = handlePresell(30)
        mData = handleDate(.current)
    
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(pan)
    }
    
    func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        let point = panGesture.translation(in: self)
        if point.x < -20.0 {
            clickedNextPageBtn(UIButton())
        }
        if point.x > 20.0 {
            clickedBackPageBtn(UIButton())
        }
    }
    
    // 预售期
    func handlePresell(_ presellDays: Int) -> [DateComponents] {
        let currentDate = Date().addingTimeInterval(8.00 * 3600)
        // MARK: 困惑
        /**
            日期为：2017-01-12 16:21:16 +0000
            但dateComponents之后， 居然.day = 13；而16点之前的日期 .day = 12
        */
        var comps: [DateComponents]? = [DateComponents]()
        print(currentDate)
        for k in 0..<presellDays {
            let interval: Double = 24.00 * 3600 * Double(k)
            comps?.append(Calendar.current.dateComponents([.year, .month, .day, .weekday], from: currentDate.addingTimeInterval(interval)))
        }
        
        return comps!
    }
    
    //
    func handleDate(_ monthType: MonthSelect) -> [DateComponents] {
        var mDate: Date?
        switch monthType {
        case .next:
            let date = Date().addingTimeInterval(8.00 * 3600)
            let comps = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
            let days: Range = Calendar.current.range(of: .day, in: .month, for: date)!
            let add: Double = 24.00 * 3600 * Double((days.count - comps.day! + 1))
            mDate = date.addingTimeInterval(add)
            break
        case .current:
            mDate = Date().addingTimeInterval(8.00 * 3600)
            break
        }
        
        let date = mDate!
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(date)
        
        // 当前日期
        let comps = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: date)
        let days: Range = Calendar.current.range(of: .day, in: .month, for: date)!

        yearLabel.text = "\(comps.year!)年"
        monthLabel.text = "\(comps.month!)月"
        
        // 当月一号
        let dayOne: Double = 24.00 * 3600 * Double(-comps.day! + 1)
        let currentMonthFirstDay = date.addingTimeInterval(dayOne)
        
        let compsBaseDayone = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: currentMonthFirstDay)
        let dayoneWeekday = compsBaseDayone.weekday! - 1 > 0 ? compsBaseDayone.weekday! - 1 : 7
    
        
        // 下月一号
        let add: Double = 24.00 * 3600 * Double((days.count - comps.day! + 1))
        let nextMonthFirstDay = date.addingTimeInterval(add)
        
        var dateArr: [DateComponents]? = [DateComponents]()
        
        // 上月
        if dayoneWeekday > 1 {
            for k in 0..<dayoneWeekday - 1 {
                let reduce: Double = 24.00 * 3600 * Double(-comps.day! - (dayoneWeekday - 2 - k))
                let lastMonth = date.addingTimeInterval(reduce)
                dateArr?.append(Calendar.current.dateComponents([.year, .month, .day, .weekday], from: lastMonth))
            }
        }
        
        // 当月
        for k in 0..<days.count {
            let add: Double = 24.00 * 3600 * Double(k)
            let current = currentMonthFirstDay.addingTimeInterval(add)
            dateArr?.append(Calendar.current.dateComponents([.year, .month, .day, .weekday], from: current))
        }
        
        // 下月
        let nextDays = 42 - (dateArr?.count)!
        for k in 0..<nextDays {
            let add: Double = 24.00 * 3600 * Double(k)
            let next = nextMonthFirstDay.addingTimeInterval(add)
            dateArr?.append(Calendar.current.dateComponents([.year, .month, .day, .weekday], from: next))
        }
        
        return dateArr!
    }

    @IBAction func clickedBackPageBtn(_ sender: UIButton) {
        
        mData = handleDate(.current)
        
    }
    
    @IBAction func clickedNextPageBtn(_ sender: UIButton) {
        
        mData = handleDate(.next)

    }
    
    @IBAction func clickedDateBtn(_ sender: UIButton) {
        let comps: DateComponents = (mData?[sender.tag])!
        let str = "\(comps.year!)-\(comps.month!)-\(comps.day!)"
        mDateSelectedClosure!(str)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
