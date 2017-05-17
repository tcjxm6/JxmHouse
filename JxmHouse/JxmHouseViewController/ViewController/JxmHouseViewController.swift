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


class JxmHouseViewController: UIViewController {

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
        self.tableView.tableHeaderView = self.headView
        self.view.addSubview(self.tableView)
        
        
    }
    
    func initOther() {
        
        self.title = "深圳·楼盘"
        
    }
    
    func refreshData() {
        self.page = 1
        
    }



}
