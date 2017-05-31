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
import ReactiveSwift


class JxmHouseViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

//    NSArray *nibContents = [[MineFrameworkHelper frameworkBundle] loadNibNamed:@"TimeChooseHeadView" owner:nil options:nil];
//    TimeChooseHeadView *headView = [nibContents lastObject];
//    headView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 68);
//    [self.headTimeView addSubview:headView];
//    self.headTimeView = headView;
    
    let tableView : UITableView = UITableView()
    let headView : TimeChooseHeadView = Bundle.main.loadNibNamed("TimeChooseHeadView", owner: nil, options: nil)?.last as! TimeChooseHeadView
    var page : Int = 1
    //cellModelArr
    var dataArr : [HouseModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initOther()
        self.initView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func initView() {

        self.headView.callback = { [weak self](beginTime,endTime) in
            self?.refreshData()
        }
        self.tableView.frame = CGRect.init(x: 0, y: 0, width: DEVICE_WIDTH, height: DEVICE_HEIGHT)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.mj_header = MJRefreshStateHeader.init(refreshingBlock: {
            [weak self] in
            self?.refreshData()
            
        })
        
        self.tableView.mj_footer = MJRefreshAutoStateFooter.init(refreshingBlock: {
            [weak self] in
            self?.page += 1
            let page = self?.page ?? 1
            self?.downloadData(page: page)
        })
        self.tableView.mj_footer.isAutomaticallyHidden = true
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
        self.dataArr.removeAll()
        self.downloadData(page: self.page)
    }
    
    func downloadData(page:Int) {
        let parameters : Parameters = ["beginTime":self.headView.beginTime,
                                       "endTime":self.headView.endTime,
                                       "size":20,
                                       "page":page,
                                       "city":"深圳市",
                                       "sort":"regionalism_name",]
        
        
        weak var weakSelf = self
        Alamofire.request( "http://tcjxm6.xyz:8000/queryTop100/", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responds) in
            
            let val = responds.result.value as! NSDictionary?
            let data = val?.object(forKey: "data") as? NSArray ?? []

            for modelDic in data {
                let model : HouseModel = HouseModel.mj_object(withKeyValues: modelDic)
                let begin : NSDate = NSDate.init(string: weakSelf?.headView.beginTime, formatString: "yyyy-MM-dd HH:mm:ss")
                let end : NSDate = NSDate.init(string: weakSelf?.headView.endTime, formatString: "yyyy-MM-dd HH:mm:ss")
                model.setXTitle(beginTime: begin , endTime: end)
                weakSelf?.dataArr.append(model)

            }
            
            weakSelf?.tableView.reloadData()
            weakSelf?.tableView.mj_header.endRefreshing()
            weakSelf?.tableView.mj_footer.endRefreshing()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : JxmHouseCell = tableView.dequeueReusableCell(withIdentifier: "JxmHouseCell") as! JxmHouseCell
        let model : HouseModel = self.dataArr[indexPath.row]
        cell.setData(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
