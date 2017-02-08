//
//  DateViewController.swift
//  Train
//
//  Created by 张昭 on 12/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

class DateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var mTableView: UITableView!
    var mSeletedDate: DateSelectedClosure?
    var mStudentCellArr: [StudentTimeCell]? = [StudentTimeCell]()
    var mPresellDays: Int? = 30
    var mDeselectRow: IndexPath?
    deinit {
        mTableView.delegate = nil
        mTableView.dataSource = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择出发日期"
        
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.register(UINib.init(nibName: "DateListCell", bundle: Bundle.main), forCellReuseIdentifier: "DateListCell")
        mTableView.register(UINib.init(nibName: "StudentTimeCell", bundle: Bundle.main), forCellReuseIdentifier: "StudentTimeCell")
        mTableView.selectRow(at: IndexPath.init(row: 1, section: 0), animated: false, scrollPosition: .none)
        
        
        
    }

    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateListCell") as! DateListCell
            cell.mPresell = mPresellDays!
            cell.mDateSelectedClosure = { date in
                self.mSeletedDate!(date)
                _ = self.navigationController?.popViewController(animated: true)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTimeCell") as! StudentTimeCell
            
            if indexPath.row == 2 {
                cell.mTitleLabel.text = "学生"
                cell.mContentLabel.text = "46天预售期：仅学生票"
            }

            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            tableView.selectRow(at: mDeselectRow, animated: false, scrollPosition: .none)
        }
        if indexPath.row == 1 {
            mPresellDays = 30
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        } else if indexPath.row == 2 {
            mPresellDays = 46
            tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        mDeselectRow = indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 310.0
        } else {
            return 55.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
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
