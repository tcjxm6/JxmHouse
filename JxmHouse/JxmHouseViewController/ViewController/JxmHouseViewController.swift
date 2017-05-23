//
//  JxmHouseViewController.swift
//  JxmHouse
//
//  Created by XFXB on 17/5/17.
//  Copyright © 2017年 tcjxm6. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking
import MJRefresh
import MJExtension


class JxmHouseViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

//    NSArray *nibContents = [[MineFrameworkHelper frameworkBundle] loadNibNamed:@"TimeChooseHeadView" owner:nil options:nil];
//    TimeChooseHeadView *headView = [nibContents lastObject];
//    headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 68);
//    [self.headTimeView addSubview:headView];
//    self.headTimeView = headView;
    
    let tableView : UITableView = UITableView()
    let headView : TimeChooseHeadView = Bundle.main.loadNibNamed("TimeChooseHeadView", owner: nil, options: nil)?.last as! TimeChooseHeadView
    var page : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initOther()
        self.initView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func initView() {

        self.tableView.frame = CGRect.init(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.mj_header = MJRefreshStateHeader.init(refreshingBlock: { 
            [weak self] in
            self?.refreshData()
            self?.tableView.mj_header.endRefreshing()
        })
        self.headView.frame = CGRect.init(x: 0, y: 0, width: DEVICE_WIDTH, height: 68)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableHeaderView = self.headView
        self.tableView.register(UINib.init(nibName: "JxmHouseCell", bundle: nil), forCellReuseIdentifier: "JxmHouseCell")
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
        
    }
    
    func initOther() {
        
        self.title = "深圳·楼盘"
        self.refreshData()
    }
    
    func refreshData() {
        self.page = 1
        self.downloadData(page: self.page)
    }
    
    func downloadData(page:Int) {
        let parameters : Parameters = ["beginTime":"2017-05-10 00:00:00",
                                       "endTime":"2017-05-22 23:59:59",
                                       "size":20,
                                       "page":1,
                                       "city":"深圳市",
                                       "sort":"price",]
        
        
        Alamofire.request( "http://tcjxm6.xyz:8000/queryTop100/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responds) in
            let val = responds.result.value as! NSDictionary?
            let data = val?.object(forKey: "data") as? NSArray ?? []

            for modelDic in data {
                let model : HouseModel = HouseModel.mj_object(withKeyValues: modelDic)
                var dateArr = model.avg_prices.allKeys

                dateArr.sort(by: { (a , b) -> Bool in

                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date : Date! = dateformatter.date(from: a as! String)
                    let date2 : Date! = dateformatter.date(from: b as! String)
                    let result : Bool = date.compare(date2) == .orderedAscending
                    return result
                })

            }

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : JxmHouseCell = tableView.dequeueReusableCell(withIdentifier: "JxmHouseCell") as! JxmHouseCell
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
}
