//
//  TicketQueryViewController.swift
//  Train
//
//  Created by 张昭 on 13/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit
import SVProgressHUD

class TicketQueryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var mQueryParam: LeftTicketParam?
    var mStartStationName: String?
    var mEndStationName: String?
    
    @IBOutlet var mTableView: UITableView!
    var mTrainData: [QueryLeftNewDTO]? = [QueryLeftNewDTO]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\(mStartStationName!)-\(mEndStationName!)"
       
        self.automaticallyAdjustsScrollViewInsets = true
        
        SVProgressHUD.show(withStatus: "正在查询...")
        Service.sharedInstance.queryTicketFlowWith(mQueryParam!, success: { (dto) in
            SVProgressHUD.dismiss()
            self.mTrainData = dto
            self.mTableView.reloadData()
        }) { (error) in
            logger.info(translate(error))
            SVProgressHUD.showError(withStatus: translate(error))
        }
       
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.register(UINib.init(nibName: "TicketHeaderCell", bundle: Bundle.main), forCellReuseIdentifier: "TicketHeaderCell")
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (mTrainData?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TicketHeaderCell") as! TicketHeaderCell
        cell.mData = mTrainData?[indexPath.section]
        return cell
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
