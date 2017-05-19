//
//  header.swift
//  JxmHouse
//
//  Created by XFXB on 17/5/17.
//  Copyright © 2017年 tcjxm6. All rights reserved.
//

import Foundation
import Alamofire

let DEVICE_WIDTH = UIScreen.main.bounds.size.width
let DEVICE_HEIGHT = UIScreen.main.bounds.size.height


func HEXCOLOR(_ hex3: UInt32, alpha: CGFloat = 1) -> UIColor{
    let divisor = CGFloat(15)
    let red     = CGFloat((hex3 & 0xF00) >> 8) / divisor
    let green   = CGFloat((hex3 & 0x0F0) >> 4) / divisor
    let blue    = CGFloat( hex3 & 0x00F      ) / divisor
    
    return UIColor.init(red: red, green: green, blue: blue, alpha: alpha)
}
