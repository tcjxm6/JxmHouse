//
//  ChartView.swift
//  JxmHouse
//
//  Created by XFXB on 17/5/19.
//  Copyright © 2017年 tcjxm6. All rights reserved.
//

import UIKit

class ChartView: UIView {

    enum Direction {
        case rigth
        case down
    }
    
    enum LineStyle {
        case defaultStyle
    }
    
    enum XLineStyle {
        case dash,solid
    }
    
    //视图宽度及高度
    var width : CGFloat = 0.0
    var height :CGFloat = 0.0
    //y轴zero值和最大刻度
    
    //视图风格
    var style : LineStyle = .defaultStyle
    
    //y轴分几等分
    var _yPart : Int = 5
    var yPart : Int {
        get {
            let val = self.yValueArr.count - 1
            return val >= 0 ? val : 0
        }
        set {
            _yPart = newValue
        }
    }
    
    //y轴距离顶部偏移量
    var yTopOffset : CGFloat = 20.0
    //y轴距离底部偏移量
    var yBottomOffset : CGFloat = 20.0
    //x轴距离左边偏移量
    var xLeftOffset : CGFloat = 20.0
    //line的宽度
    var lineWidth : CGFloat = 1.0
    
    //y,x轴颜色
    var yLineColor : UIColor = HEXCOLOR(0xeeeeee,alpha: 1)
    var xLineColor : UIColor = HEXCOLOR(0xeeeeee,alpha: 1)
    
    
    //数据
    var dataDic : NSDictionary?
    //y轴lableArr
    var yLableArr : [UILabel] = []
    //y轴valueArr
    var _yValueArr : [Double] = Array()
    var yValueArr : [Double] {
        set {
            
            //去重
            let set1 = Set(newValue)
            //排序
            _yValueArr = Array(set1).sorted { (a, b) -> Bool in
                return a>b
            }
            
            self.setBackground()
        }
        
        get{
            return _yValueArr
        }
    }
    
    //x轴lableArr
    var xLableArr : [UILabel] = []
    //x轴valueArr
    var _xValueArr : [String] = []
    var xValueArr : [String] {
        get {
            return _xValueArr
        }
        set {
            _xValueArr = newValue
            self.setXValueLable()
        }
    }
    //底部竖线的layerArr
    var bottomLineArr : [CALayer] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(self.width != self.frame.size.width && self.height != self.frame.size.height) {
            self.width = self.frame.size.width
            self.height = self.frame.size.height
            self.setBackground()
        }
        
        
    }
    
    func setBackground() {
        //清空原先的子视图
        let subViewArr = self.subviews
        for view in subViewArr {
            view.removeFromSuperview()
        }
        let subLayerArr = self.layer.sublayers
        for layer in subLayerArr ?? [] {
            layer.removeFromSuperlayer()
        }
        
        
        
        
        switch self.style {
        case .defaultStyle:
            //画x,y zero轴
            let xLayer = self.getLine(direction: .rigth, origin: CGPoint.init(x: self.xLeftOffset, y: self.height - self.yBottomOffset), length: self.width - self.xLeftOffset, color: HEXCOLOR(0xcccccc,alpha: 1))
            self.layer.addSublayer(xLayer)

            
            let offset : CGFloat = (self.height - self.yBottomOffset - self.yTopOffset) / CGFloat(self.yPart)
            var y : CGFloat = self.yTopOffset
            for _ in 0..<self.yPart {
                let origin : CGPoint = CGPoint.init(x: self.xLeftOffset, y: y)
                let xLine : CAShapeLayer = self.getLine(direction: .rigth, origin: origin, length: self.width - self.xLeftOffset, color:HEXCOLOR(0xcccccc,alpha: 0))

                //设置虚线
                let shapeLayer = CAShapeLayer()
                shapeLayer.bounds = xLine.bounds
                shapeLayer.position = CGPoint.init(x: xLine.frame.size.width / 2, y: xLine.frame.size.height)
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = HEXCOLOR(0xcccccc).cgColor
                shapeLayer.lineWidth = xLine.frame.size.height
                shapeLayer.lineJoin = kCALineJoinRound
                shapeLayer.lineDashPattern = NSArray.init(objects: 2,1) as? [NSNumber]
                let path : CGMutablePath = CGMutablePath()
                path.move(to: CGPoint.init(x: 0, y: 0))
                path.addLine(to: CGPoint.init(x: self.width - self.xLeftOffset, y: 0))
                shapeLayer.path = path
                xLine .addSublayer(shapeLayer)
                
                self.layer.addSublayer(xLine)
                y += offset
            }
            
            
        }
        
        self.setYValueLable()
        self.setXValueLable()
        
        self.setData(self.dataDic ?? NSDictionary.init())
    }
    
    func setYValueLable(){
        
        for lable in self.yLableArr {
            lable.removeFromSuperview()
        }
        self.yLableArr.removeAll()
        var y = self.yTopOffset
        let offset : CGFloat = (self.height - self.yBottomOffset - self.yTopOffset) / CGFloat(self.yPart)
        
        for x in 0..<self.yValueArr.count {
            let lable = UILabel()
            lable.frame = CGRect.init(x: 0, y: y, width: 1, height: 1)
            lable.text = String.init(format: "%.0lf", arguments: [self.yValueArr[x]])
            lable.sizeToFit()
            var rect = lable.frame
            rect.origin.x = 0
            rect.origin.y = y - rect.size.height / 2
            rect.size.width = self.xLeftOffset
            lable.font = UIFont.systemFont(ofSize: 13)
            lable.textAlignment = .center
            lable.frame = rect
            lable.textColor = HEXCOLOR(0x333333)
            y += offset
            self.addSubview(lable)
            self.yLableArr.append(lable)
        }

    }
    
    func setXValueLable() {
        for lable in self.xLableArr {
            lable.removeFromSuperview()
        }
        self.xLableArr.removeAll()
        for layer in self.bottomLineArr {
            layer.removeFromSuperlayer()
        }
        self.bottomLineArr.removeAll()
        
        var xPoint : CGFloat = self.xLeftOffset
        let y : CGFloat = self.height - self.yBottomOffset
        let width : CGFloat = (self.width - self.xLeftOffset) / CGFloat(self.xValueArr.count)
        
        for x in 0..<self.xValueArr.count + 1 {
            
            let layer = CALayer()
            layer.frame = CGRect.init(x: xPoint - 1, y: y+1, width: 1, height: 4)
            if x == 0 {
                layer.frame = CGRect.init(x: xPoint, y: y+1, width: 1, height: 4)
            }
            
            layer.backgroundColor = HEXCOLOR(0xcccccc).cgColor
            self.layer.addSublayer(layer)
            self.bottomLineArr.append(layer)
            
            if x < self.xValueArr.count {
                let lable = UILabel()
                lable.frame = CGRect.init(x: xPoint, y: y+1, width: width, height: self.yBottomOffset)
                lable.text = self.xValueArr[x]
                lable.font = UIFont.systemFont(ofSize: 13)
                lable.textAlignment = .center
                lable.textColor = HEXCOLOR(0x333333)
                self.addSubview(lable)
                self.xLableArr.append(lable)
            }
            
            xPoint += width
        }
    }
    
    
    
    func getLine(direction:Direction , origin : CGPoint , length : CGFloat , color : UIColor) -> CAShapeLayer{
        let layer = CAShapeLayer()
        
        switch direction {
        case .down:
            layer.frame = CGRect.init(x: origin.x, y: origin.y, width: self.lineWidth, height: length)
        case .rigth:
            layer.frame = CGRect.init(x: origin.x, y: origin.y, width: length, height: self.lineWidth)
        }
        layer.backgroundColor = color.cgColor
        
        return layer
    }

    func setData(_ dic:NSDictionary) {
        self.dataDic = dic
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
