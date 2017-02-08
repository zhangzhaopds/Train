//
//  StationData.swift
//  Train
//
//  Created by 张昭 on 11/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

struct Station {
    var firstLetter: String // 首字母
    var name: String        // 站名
    var code: String        // 电报码
    var spell: String       // 全拼
}

// "https://kyfw.12306.cn/otn/resources/js/framework/station_name.js"
class StationNameData: NSObject {
    fileprivate static let shareManager = StationNameData()
    class var sharedInstance: StationNameData {
        return shareManager
    }
    
    var allStation: [Station]
    var allStationMap: [String: Station]
    
    fileprivate override init() {
        allStation = [Station]()
        allStationMap = [String: Station]()
        
        let path = Bundle.main.path(forResource: "station_name", ofType: "js")

        do {
            let stationInfo =
            try NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) as String
            if let matches = Regex("@[a-z]+\\|([^\\|]+)\\|([a-z]+)\\|([a-z]+)\\|([a-z]+)\\|").getMatches(stationInfo) {
            
                for match in matches {
                    let oneStation = Station(firstLetter: match[3], name: match[0], code: match[1], spell: match[2])
                    self.allStation.append(oneStation)
                    self.allStationMap[oneStation.name] = oneStation
                }
            }
        } catch {
            logger.info("火车站站点数据读取失败：station_name.js")
        }
    }
}
