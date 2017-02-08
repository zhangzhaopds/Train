//
//  StationsViewController.swift
//  Train
//
//  Created by 张昭 on 11/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

typealias SelectedStationClosure = (_ station: String) -> Void

class StationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    var mSelectedStationClosure: SelectedStationClosure?
    var stationType: StationType?
    var mData: [String: [String]]?
    var mStations: [Station]?
    var mSearchVC: UISearchController?
    var firstSpell: [String]?
    var filterResult: [String]? = [String]()

    @IBOutlet var mTableView: UITableView!
    
    deinit {
        mSearchVC?.searchResultsUpdater = nil
        mTableView.delegate = nil
        mTableView.dataSource = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if stationType! == StationType.start {
            self.title = "出发站"
        }
        if stationType! == StationType.end {
            self.title = "终点站"
        }
        
        mData = [String: [String]]()
        mStations = [Station]()
        firstSpell = [String]()
        
        let allStation = StationNameData.sharedInstance.allStation
        let dd = allStation.sorted { (a, b) -> Bool in
            a.spell < b.spell
        }
        mStations = dd
        
        for station in dd {
            let sub = (station.spell as NSString).substring(to: 1)
            if !(firstSpell?.contains(sub))! {
                firstSpell?.append(sub)
            }
        }
        for i in 0..<(firstSpell?.count)! {
            var vals = [String]()
            let arr = dd.filter { (a) -> Bool in
                let sub = (a.spell as NSString).substring(to: 1)
                return sub == firstSpell![i]
            }
            for station in arr {
                vals.append(station.name)
            }
            mData?[firstSpell![i]] = vals
        }

        
        
        mSearchVC = UISearchController.init(searchResultsController: nil)
        mSearchVC?.searchResultsUpdater = self
        mSearchVC?.dimsBackgroundDuringPresentation = false
        mSearchVC?.searchBar.sizeToFit()
        mSearchVC?.searchBar.searchBarStyle = .minimal
        mSearchVC?.searchBar.backgroundColor = UIColor.white
        mSearchVC?.searchBar.placeholder = "搜索"
        mTableView.tableHeaderView = mSearchVC?.searchBar
    
        mTableView.delegate = self
        mTableView.dataSource = self
        mTableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuse")
        
//        mSearchVC?.isActive = true
        
    }

    //MARK: Search
    func updateSearchResults(for searchController: UISearchController) {
        
        filterResult?.removeAll()

        let arr = mStations?.filter({ (station) -> Bool in
            return station.name.contains(searchController.searchBar.text!) || station.spell.contains(searchController.searchBar.text!) || station.firstLetter.contains(searchController.searchBar.text!)
        }).sorted(by: { (a, b) -> Bool in
            a.spell < b.spell
        })
        for station in arr! {
            filterResult?.append(station.name)
        }
        
        mTableView.reloadData()
    }
    
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        } else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (mSearchVC?.isActive)! {
            return 1
        } else {
            return (firstSpell?.count)!
 
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (mSearchVC?.isActive)! {
            return (filterResult?.count)!
        } else {
            let arr = mData?[firstSpell![section]]
            return (arr?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse")
        if (mSearchVC?.isActive)! {
            cell?.textLabel?.text = filterResult?[indexPath.row]
        } else {
            let content = mData?[firstSpell![indexPath.section]]
            cell?.textLabel?.text = content?[indexPath.row]
        }
        
        return cell!
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return ["a", "b", "c"]
//    }
//    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return index
//    }
//    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (mSearchVC?.isActive)! {
            return "搜索结果"
        } else {
            return firstSpell![section]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (mSearchVC?.isActive)! {
            let str = filterResult?[indexPath.row]
            mSelectedStationClosure!(str!)
            mSearchVC?.isActive = false
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            let content = mData?[firstSpell![indexPath.section]]
            let str = content?[indexPath.row]
            mSelectedStationClosure!(str!)
             _ = self.navigationController?.popViewController(animated: true)
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
