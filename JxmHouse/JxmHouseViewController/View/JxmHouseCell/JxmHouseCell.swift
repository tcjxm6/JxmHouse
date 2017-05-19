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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.parentView.layer.cornerRadius = 4
//        self.parentView.layer.masksToBounds = true
        
        self.chartView.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        self.chartView.layer.shadowOffset = CGSize.init(width: 0, height: 1)
        self.chartView.layer.shadowOpacity = 1
        self.chartView.layer.shadowRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
