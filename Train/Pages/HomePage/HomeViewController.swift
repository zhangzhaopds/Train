//
//  HomeViewController.swift
//  Train
//
//  Created by 张昭 on 06/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var mTableView: UITableView!
    var mPickerView: UIPickerView?
    var mPickerBgView: UIView?
    var isTimePicker: Bool? = false
    var mStartEndTimeCell: StartEndTimeCell?
    var mStartEndStationCell: StartEndStationCell?
    
    var mStartStationName: String? = "平顶山西"
    var mEndStationName: String? = "成都"
    var mStartDateString: String? = "2017-01-01"
    
    let mTimesArr: [String]? = ["00:00--24:00",
                                "00:00--06:00",
                                "06:00--12:00",
                                "12:00--18:00",
                                "18:00--24:00"]
    let mXibieArr: [String]? = ["不限",
                                "商务座",
                                "特等座",
                                "一等座",
                                "二等座",
                                "高级软卧",
                                "软卧",
                                "硬卧",
                                "软座",
                                "硬座"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\(MainModel.realName)，欢迎您"
        // Do any additional setup after loading the view.
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        mStartDateString = format.string(from: Date().addingTimeInterval(8.00 * 3600))
        

        mTableView.register(UINib.init(nibName: "StartEndStationCell", bundle: Bundle.main), forCellReuseIdentifier: "StartEndStationCell")
        mTableView.register(UINib.init(nibName: "StartEndTimeCell", bundle: Bundle.main), forCellReuseIdentifier: "StartEndTimeCell")
        mTableView.register(UINib.init(nibName: "TrainTypeCell", bundle: Bundle.main), forCellReuseIdentifier: "TrainTypeCell")
        mTableView.register(UINib.init(nibName: "AddPassengerCell", bundle: Bundle.main), forCellReuseIdentifier: "AddPassengerCell")
        mTableView.register(UINib.init(nibName: "RecentPathCell", bundle: Bundle.main), forCellReuseIdentifier: "RecentPathCell")
        
        
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if (touches.first?.view?.tag)! <= 104 && (touches.first?.view?.tag)! >= 101   {
            SVProgressHUD.showInfo(withStatus: "暂未开通，敬请期待!")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65.0
        } else if indexPath.row == 1 {
            return 155.0
        } else if indexPath.row == 2 {
            return 45.0
        } else if indexPath.row == 3 {
            return 130.0
        } else {
            return 40.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: StartEndStationCell = tableView.dequeueReusableCell(withIdentifier: "StartEndStationCell") as! StartEndStationCell
            mStartEndStationCell = cell
            cell.mClosure = {(station: StationType) in
                self.handleStartEndStationCell(cell, type: station)
            }
            return cell
        } else if indexPath.row == 1 {
            let cell: StartEndTimeCell = tableView.dequeueReusableCell(withIdentifier: "StartEndTimeCell") as! StartEndTimeCell
            mStartEndTimeCell = cell
            cell.mBtnClickedClosure = { type in
                self.handleStartEndDateCell(cell, type: type)
            }
            return cell
        } else if indexPath.row == 2 {
            let cell: TrainTypeCell = tableView.dequeueReusableCell(withIdentifier: "TrainTypeCell") as! TrainTypeCell
            return cell
        } else if indexPath.row == 3 {
            let cell: AddPassengerCell = tableView.dequeueReusableCell(withIdentifier: "AddPassengerCell") as! AddPassengerCell
            cell.mSubmitBtnClosure = { sender in
                self.handleSubmitQuery(cell)
            }
            return cell
        } else {
            let cell: RecentPathCell = tableView.dequeueReusableCell(withIdentifier: "RecentPathCell") as! RecentPathCell
            return cell
        }
        
    }
    
    // 提交查询CELL
    func handleSubmitQuery(_ cell: AddPassengerCell) {

        mStartStationName = mStartEndStationCell?.startStationBtn.titleLabel?.text
        mEndStationName = mStartEndStationCell?.endStationBtn.titleLabel?.text
        mStartDateString = mStartEndTimeCell?.dateBtn.titleLabel?.text
        
        // 查询参数
        let startStation: Station = StationNameData.sharedInstance.allStationMap[mStartStationName!]!
        let endStation: Station = StationNameData.sharedInstance.allStationMap[mEndStationName!]!
        let param = LeftTicketParam(train_date: mStartDateString!, from_stationCode: startStation.code, to_stationCode: endStation.code, purpose_codes: TicketType.Normal.rawValue)
        
        let ticket = TicketQueryViewController()
        ticket.mQueryParam = param
        ticket.mStartStationName = mStartStationName!
        ticket.mEndStationName = mEndStationName!
        self.navigationController?.pushViewController(ticket, animated: true)
        
    }
    
    // 选择起始站CELL
    func handleStartEndStationCell(_ cell: StartEndStationCell, type: StationType) {
        let stationVC = StationsViewController()
        stationVC.stationType = type
        stationVC.mSelectedStationClosure = { stationName in
            if type == .start {
//                self.mStartStationName = stationName
                cell.startStationBtn.setTitle(stationName, for: .normal)
            } else {
//                self.mEndStationName = stationName
                cell.endStationBtn.setTitle(stationName, for: .normal)
            }
        }
        self.navigationController?.pushViewController(stationVC, animated: true)
    }
    
    // 查询日期CELL
    func handleStartEndDateCell(_ cell: StartEndTimeCell, type: BtnType) {
        
        switch type {
        case .date:
            print("日期")
            let dateVC = DateViewController()
            dateVC.mSeletedDate = { date in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dd = formatter.date(from: date)
                let title = formatter.string(from: dd!)
                cell.dateBtn.setTitle(title, for: .normal)
            }
            self.navigationController?.pushViewController(dateVC, animated: true)
            break
        case .time:
            print("时间")
            isTimePicker = true
            dateTimePicker(cell)
            break
        case .xibie:
            print("席别")
            isTimePicker = false
            dateTimePicker(cell)
            break
        case .student:
            print("学生")
            break
        }
    }
    
    // 日期时间选择器
    func dateTimePicker(_  cell: StartEndTimeCell) {
        
        self.tabBarController?.tabBar.isHidden = true
        mPickerBgView?.removeFromSuperview()
        
        mPickerBgView = UIView.init(frame: CGRect.init(x: 0, y: kScreenHeight - 240, width: kScreenWidth, height: 240))
        mPickerView = UIPickerView.init(frame: CGRect.init(x: 0, y: 40, width: kScreenWidth, height: 200))
        mPickerBgView?.addSubview(mPickerView!)
        self.view.addSubview(mPickerBgView!)
        
        mPickerView?.delegate = self
        mPickerView?.dataSource = self
        mPickerView?.backgroundColor = UIColor.white
        mPickerBgView?.backgroundColor = UIColor.orange
        
        // 取消
        let cancelBtn = UIButton.init(type: .custom)
        cancelBtn.frame = CGRect.init(x: 0, y: 0, width: 80, height: 40)
        cancelBtn.setTitle("取消", for: .normal)
        mPickerBgView?.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(clickedCancelBtn(_:cell:)), for: .touchUpInside)
        
        
        // 确定
        let okBtn = UIButton.init(type: .custom)
        okBtn.frame = CGRect.init(x: kScreenWidth - 80, y: 0, width: 80, height: 40)
        okBtn.setTitle("确定", for: .normal)
        mPickerBgView?.addSubview(okBtn)
        okBtn.addTarget(self, action: #selector(clickedOkBtn(_:cell:)), for: .touchUpInside)
        
    }
    
    func clickedCancelBtn(_ sender: UIButton, cell: StartEndTimeCell) {
        self.tabBarController?.tabBar.isHidden = false
        mPickerBgView?.removeFromSuperview()
    }
    
    func clickedOkBtn(_ sender: UIButton, cell: StartEndTimeCell) {
        self.tabBarController?.tabBar.isHidden = false
        let row = mPickerView?.selectedRow(inComponent: 0)
        if isTimePicker! {
            mStartEndTimeCell?.timeBtn.setTitle(mTimesArr?[row!], for: .normal)
        } else {
            mStartEndTimeCell?.xibieBtn.setTitle(mXibieArr?[row!], for: .normal)
        }
        mPickerBgView?.removeFromSuperview()
    }
    
    // picker代理相关
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if isTimePicker! {
            return (mTimesArr?.count)!
        } else {
            return (mXibieArr?.count)!
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isTimePicker! {
            return mTimesArr?[row]
        } else {
            return mXibieArr?[row]
        }
    }
    
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
