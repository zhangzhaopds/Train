//
//  SwiftyRegex.swift
//  Train
//
//  Created by 张昭 on 06/01/2017.
//  Copyright © 2017 Jmsp. All rights reserved.
//

import UIKit

class Regex: NSObject {
    let internalExpression: NSRegularExpression?
    let pattern: String
    init(_ pattern: String) {
        self.pattern = pattern
        do {
            self.internalExpression =
            try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        } catch _ as NSError {
            self.internalExpression = nil
        }
    }
    
    func getMatches(_ input: String) -> [[String]]? {
        var res = [[String]]()
        let myRange = NSMakeRange(0, input.characters.count)
        if let matches = self.internalExpression?.matches(in: input, options: [], range: myRange) {
            for match in matches {
                var groupMatch = [String]()
                for i in 1..<match.numberOfRanges {
                    let rangeText = (input as NSString).substring(with: match.rangeAt(i))
                    groupMatch.append(rangeText)
                }
                res.append(groupMatch)
            }
        }
        if res.count > 0 {
            return res
        } else {
            return nil
        }
    }
}
