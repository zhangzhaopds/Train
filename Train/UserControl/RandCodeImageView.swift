//
//  RandCodeImageView2.swift
//  SelectImageDemo
//
//  Created by fancymax on 16/3/8.
//  Copyright © 2016年 fancy. All rights reserved.
//

import UIKit

class RandCodeImageView2: UIImageView {
    
        
    struct ImageSection {
        var rowIndex: Int
        var colIndex: Int
        
        func isSameSection(_ section: ImageSection) -> Bool {
            if (section.rowIndex == rowIndex) && (section.colIndex == colIndex){
                return true
            }
            else{
                return false
            }
        }
    }
    
    fileprivate var imageSections = [ImageSection]()
    
    fileprivate func convertSectionToRandCode(_ section:ImageSection)->(Int,Int){
        var randX = 0
        var randY = 0
        if section.rowIndex == 0 {
            randY = 40
        }
        else{
            randY = 110
        }
        
        if section.colIndex == 0{
            randX = 40
        }
        else if section.colIndex == 1{
            randX = 110
        }
        else if section.colIndex == 2{
            randX = 180
        }
        else{
            randX = 255
        }
        return (randX,randY)
    }
    
    var randCodeStr:String?{
        get{
            if imageSections.count == 0{
                return nil
            }
            var (randX,randY) = convertSectionToRandCode(imageSections[0])
            var str = "\(randX),\(randY)"
            if imageSections.count >= 2{
                for i in 1...imageSections.count - 1 {
                    (randX, randY) = convertSectionToRandCode(imageSections[i])
                    str += ",\(randX),\(randY)"
                }
            }
            return str
        }
    }
    
    
    func clearRandCodes() {
        imageSections = [ImageSection]()
        drawSection(imageSections)
    }
    
    // 点击图标
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let point = touches.first?.preciseLocation(in: self) ?? CGPoint()
        let section = indentifySection(point)
        var shouldAdd = true
        if imageSections.count > 0{
            for i in 0...imageSections.count - 1 {
                if imageSections[i].isSameSection(section){
                    imageSections.remove(at: i)
                    shouldAdd = false
                    break
                }
            }
        }
        
        if shouldAdd {
            imageSections.append(section)
        }
        
        drawSection(imageSections)
    }
    
    //识别点击在哪个区域
    fileprivate func indentifySection(_ thePoint: CGPoint) ->ImageSection{
        var section = ImageSection(rowIndex: 1, colIndex: 1)

        
        if thePoint.y < 100 {
            section.rowIndex = 0
        }
        else{
            section.rowIndex = 1
        }
        
        if thePoint.x < 77 {
            section.colIndex = 0
        }
        else if thePoint.x < 154 {
            section.colIndex = 1
        }
        else if thePoint.x < 231 {
            section.colIndex = 2
        }
        else if thePoint.x < 308 {
            section.colIndex = 3
        }
        else{
            section.colIndex = 3
        }
        return section
    }
    
    
    //dama to section
//    fileprivate func damaPoint2Section(X pointX:Double,Y pointY:Double) -> ImageSection{
//        var section = ImageSection(rowIndex: 1, colIndex: 1)
//        
//        if pointY > 110 {
//            section.rowIndex = 0 //从下往上
//        }
//        else{
//            section.rowIndex = 1
//        }
//        
//        if pointX < 75 {
//            section.colIndex = 0
//        }
//        else if pointX < 146 {
//            section.colIndex = 1
//        }
//        else if pointX < 220 {
//            section.colIndex = 2
//        }
//        else{
//            section.colIndex = 3
//        }
//        return section
//    }
    
    //119,65|24,76
//    func drawDamaCodes(_ damaCodes:String){
//        let damaFrameStrs = damaCodes.components(separatedBy: "|")
//        for damaFrameStr in damaFrameStrs {
//            let damaFramePair = damaFrameStr.components(separatedBy: ",")
//            let pointX = Double(damaFramePair[0])
//            let pointY = Double(damaFramePair[1])
//            
//            imageSections.append(damaPoint2Section(X:pointX!, Y: pointY!))
//        }
//        needsDisplay = true
//    }
    
    //绘制特定正方形区域
    fileprivate func drawSection(_ sections:[ImageSection]){
        
        // 67 + 5
        
        if subviews.count > 0 {
            for vv in subviews {
                vv.removeFromSuperview()
            }
        }
        
        for section in sections {
            let point = CGPoint(x: 5 + section.colIndex * 72, y: section.rowIndex * 72 + 40)
            let size = CGSize(width: 67, height: 67)
            let vi = UIView(frame: CGRect(origin: point, size: size))
            addSubview(vi)
            vi.backgroundColor = .red
        }
        
    }
    
}
