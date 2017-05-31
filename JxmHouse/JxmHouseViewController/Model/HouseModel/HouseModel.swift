//
//  HouseModel.swift
//  JxmHouse
//
//  Created by XFXB on 17/5/23.
//  Copyright © 2017年 tcjxm6. All rights reserved.
//

import UIKit


class HouseModel: NSObject {
    
//    "house_name": "保利金町湾",
//    "house_href": "http://baolijindingwan.fang.com/",
//    "regionalism_name": "其他",
//    "source": "www.fang.com",
//    "address": "汕尾市金町湾旅游度假区（深汕高速长沙湾出口）",
//    "city_name": "深圳市",
//    "house_type": "住宅",
//    "province_name": "广东省"
    
    var avg_prices : NSDictionary = NSDictionary()
    var house_rent : NSString = ""
    var house_name : NSString = ""
    var house_href : NSString = ""
    var regionalism_name : NSString = ""
    var source : NSString = ""
    var address : NSString = ""
    var city_name : NSString = ""
    var house_type : NSString = ""
    var province_name : NSString = ""
    var start_time : NSString = ""
    var end_time : NSString = ""

    var xTitles : [String] = []
    var yTitles : [CGFloat] = []
    var minPrice : CGFloat = 0.0

    
    override func mj_keyValuesDidFinishConvertingToObject() {
        
        guard self.avg_prices.allKeys.count > 0 else {
            return
        }
        
        var dateArr = self.avg_prices.allKeys as! [String]
        //排序日期
        dateArr.sort(by: { (a , b) -> Bool in
            
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date : Date! = dateformatter.date(from: a)
            let date2 : Date! = dateformatter.date(from: b)
            let result : Bool = date.compare(date2) == .orderedAscending
            return result
        })
        
        self.xTitles.removeAll()
        let newDic = NSMutableDictionary()
        var maxPrice : NSNumber = self.avg_prices.object(forKey: self.avg_prices.allKeys[0]) as! NSNumber
        var minPrice : NSNumber = maxPrice
        
        for key in dateArr {
            
            guard key.characters.count >= 10 else {
                continue
            }
            
            let value = self.avg_prices.object(forKey: key) as! NSNumber
            //重新定义x轴值
            switch dateArr.count {
            case 0..<8:
                let startIndex = key.index(key.startIndex, offsetBy: 5)
                let myRange: Range = startIndex..<key.index(startIndex, offsetBy: 5)
                let newKey = key.substring(with: myRange)
                self.xTitles.append(newKey)
                //金额除以1w
                newDic.setObject([NSNumber.init(value: value.floatValue / 10000)], forKey: newKey as NSCopying)
            //剩余的日期重新调用setXTitle处理，两个月的
            default:
                let endIndex = key.index(key.startIndex, offsetBy: 10)
                let myRange: Range = key.startIndex..<endIndex
                let newKey = key.substring(with: myRange)
                self.xTitles.append(newKey)
                newDic.setObject([NSNumber.init(value: value.floatValue / 10000)], forKey: newKey as NSCopying)
            }

            if value.floatValue > maxPrice.floatValue{
                maxPrice = value
            }
            else if value.floatValue <= minPrice.floatValue{
                minPrice = value
            }
        }
        self.avg_prices = NSDictionary.init(dictionary: newDic)
        self.minPrice = CGFloat(minPrice.doubleValue)
        //设置y轴值
        switch minPrice.floatValue {
        case 0..<10000:
            self.setYValue(0, maxValue: self.getMaxPrice(unit: 1000.0, min: 0, max: CGFloat(maxPrice.floatValue)))
        case 10000..<100000:
            self.setYValue(0, maxValue: self.getMaxPrice(unit: 10000.0, min: 0, max: CGFloat(maxPrice.floatValue)))
        case 100000..<1000000:
            self.setYValue(0, maxValue: self.getMaxPrice(unit: 100000.0, min: 0, max: CGFloat(maxPrice.floatValue)))
        default:
            break
        }
        
    }
    
    func getMaxPrice(unit:CGFloat,min:CGFloat,max:CGFloat) ->CGFloat {
        
        guard max > min else {
            return 0.0
        }
        var i : CGFloat = 1.0
        var value : CGFloat = 0.0
        while unit * i < max{
            i += 1
            value = unit * i
        }
        if Int(i) % 2 == 1 {
            i += 1
            value = unit * i
        }
        return value
    }
    
    func setYValue(_ minValue : CGFloat,maxValue : CGFloat) {
        let partValue = (maxValue - minValue) / 4.0
        var yArr : [CGFloat] = []
        for i in 0..<5 {
            let value : CGFloat = (CGFloat(i) * partValue + minValue) / 10000
            yArr.append(value)
        }
        
        if maxValue == 0.0 {
            yArr = [0.0,1.0,2.0,3.0,4.0]
        }
        self.yTitles = yArr
        
    }
    
    func setXTitle(beginTime : NSDate,endTime : NSDate) {
        let dateArr = self.avg_prices.allKeys as! [String]
//        guard dateArr.count > 7 else {
////            return
//        }
        
//        let days = beginTime.daysEarlierThan(endTime as Date)
        var months = 0
        if endTime.year() - beginTime.year() == 0 {
            months = endTime.month() - beginTime.month()
        }
        else {
            months = (12 - beginTime.month() + 1) + endTime.month()
            months = months + (endTime.year() - beginTime.year() - 1) * 12
        }
        
        var xTitleArr : [String] = []
        var partMonth : Int = 1
        if months <= 7 {
            partMonth = months
        }
        else {
            if months % 7 == 0 {
                partMonth = 7
            }
            else if months % 5 == 0 {
                partMonth = 5
            }
            else if months % 4 == 0 {
                partMonth = 4
            }
            else if months % 3 == 0 {
                partMonth = 3
            }
            else if months % 2 == 0 {
                partMonth = 2
            }
        }
        
        let newDic : NSMutableDictionary = NSMutableDictionary()
        if endTime.month() != beginTime.month() || endTime.year() != beginTime.year(){
            var begin = beginTime
            var key : String = begin.formattedDate(withFormat: "MM月")
            var nowPart : Int = 0
            
            xTitleArr.append(key)
            while begin.isEarlierThan(endTime as Date) {
                let time = begin.copy() as! NSDate
                
                let valueKey : String = begin.formattedDate(withFormat: "yyyy-MM-dd") ?? ""
                let valueArr : [NSNumber] = self.avg_prices.value(forKey: valueKey) as! [NSNumber]? ?? [NSNumber.init(value: 0.0)]
                var arr : [NSNumber] = newDic.value(forKey: key) as! [NSNumber]? ?? NSArray() as! [NSNumber]
                arr.append(valueArr[0])
                newDic.setValue(arr, forKey: key)
                
                begin = begin.addingDays(1) as NSDate
                if begin.month() != time.month() {
                    nowPart += 1
                    if nowPart == partMonth && begin.isEarlierThan(endTime as Date){
                        key = begin.formattedDate(withFormat: "MM月")
                        xTitleArr.append(key)
                        nowPart = 0
                    }
                    
                    
                }
            }
            self.avg_prices = NSDictionary.init(dictionary: newDic)
            self.xTitles = xTitleArr
        }
    }
}
