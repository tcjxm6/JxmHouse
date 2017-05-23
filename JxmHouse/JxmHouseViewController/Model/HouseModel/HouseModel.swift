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

    var xTitles : [String] = []
    var yTitles : [CGFloat] = []
    

}
