//
//  JxmHouseCell.swift
//  JxmHouse
//
//  Created by XFXB on 17/5/18.
//  Copyright © 2017年 tcjxm6. All rights reserved.
//

import UIKit

class JxmHouseCell: UITableViewCell {
    
    @IBOutlet weak var chartView: ChartView!

    @IBOutlet weak var minPriceLable: UILabel!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.parentView.layer.cornerRadius = 4
//        self.parentView.layer.masksToBounds = true
        
        self.backView.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        self.backView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.backView.layer.shadowOpacity = 1
        self.backView.layer.shadowRadius = 4
        self.chartView.yValueArr = [2.0,2.0,3.0,1.0,4.0,5.0]
//        self.chartView.xValueArr = ["05-17","05-18","05-19","05-20"]
//        self.chartView.pointValueArr = ["05-17":[3.0],"05-18":[3.0],"05-19":[3.0],"05-20":[3.0]]
        
    }

    func setData(model : HouseModel) {
        self.chartView.yValueArr = model.yTitles
        self.chartView.xValueArr = model.xTitles
        self.chartView.pointValueArr = model.avg_prices as! Dictionary<String, Any>
        self.nameLable.text =  String.init(format: "%@[%@]", model.house_name,model.regionalism_name)
        self.minPriceLable.text = String.init(format: "最低价:%.0lf/元", model.minPrice)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
