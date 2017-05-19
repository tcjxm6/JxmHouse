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
    
    //视图风格
    var style : LineStyle = .defaultStyle
    
    //y轴分几等分
    var _yPart : Int = 3
    var yPart : Int {
        get {return _yPart}
        set {
            _yPart = newValue
            self.setBackground()
        }
    }
    
    //y轴距离底部偏移量
    var yBottomOffset : CGFloat = 20.0
    //x轴距离左边偏移量
    var xLeftOffset : CGFloat = 20.0
    //line的宽度
    var lineWidth : CGFloat = 1.0
    
    //y,x轴颜色
    var yLineColor : UIColor = HEXCOLOR(0xeeeeee,alpha: 1)
    var xLineColor : UIColor = HEXCOLOR(0xeeeeee,alpha: 1)
    
    var dataDic : NSDictionary?
 
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
//        let subViewArr = self.subviews
//        for view in subViewArr {
//            view.removeFromSuperview()
//        }
//        let subLayerArr = self.layer.sublayers
//        for layer in subLayerArr! {
//            layer.removeFromSuperlayer()
//        }
        
        
        
        
        switch self.style {
        case .defaultStyle:
            //画x,y zero轴
            let xLayer = self.getLine(direction: .rigth, origin: CGPoint.init(x: 0, y: self.height - self.yBottomOffset), length: self.width, color: UIColor.black)
            self.layer.addSublayer(xLayer)

            
            let offset : CGFloat = (self.height - self.yBottomOffset) / CGFloat(self.yPart)
            var y : CGFloat = 0.0
            for _ in 0..<self.yPart {
                let origin : CGPoint = CGPoint.init(x: 0, y: y)
                let xLine : CAShapeLayer = self.getLine(direction: .rigth, origin: origin, length: self.width, color:HEXCOLOR(0xcccccc,alpha: 0))

                //设置虚线
                let shapeLayer = CAShapeLayer()
                shapeLayer.bounds = xLine.bounds
                shapeLayer.position = CGPoint.init(x: xLine.frame.size.width / 2, y: xLine.frame.size.height)
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = HEXCOLOR(0xcccccc).cgColor
                shapeLayer.lineWidth = xLine.frame.size.height
                shapeLayer.lineJoin = kCALineJoinRound
                shapeLayer.lineDashPattern = NSArray.init(objects: NSNumber.init(value: 2),NSNumber.init(value: 1)) as? [NSNumber]
                let path : CGMutablePath = CGMutablePath()
                path.move(to: CGPoint.init(x: 0, y: 0))
                path.addLine(to: CGPoint.init(x: self.width, y: 0))
                shapeLayer.path = path
                xLine .addSublayer(shapeLayer)
                
                self.layer.addSublayer(xLine)
                y += offset
            }
        
        }
        
        
        self.setData(self.dataDic ?? NSDictionary.init())
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
