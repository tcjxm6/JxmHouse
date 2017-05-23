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
    //x轴距离右边偏移量
    var xRightOffset : CGFloat = 0.0
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
    var _yValueArr : [CGFloat] = Array()
    var yValueArr : [CGFloat] {
        set {
            
            //去重
            let set1 = Set(newValue)
            //排序
            let arr = Array(set1).sorted { (a, b) -> Bool in
                return a>b
            }
            
            if _yValueArr.count == arr.count {
                _yValueArr = arr
                for x in 0..<_yValueArr.count {
                    let lable = self.yLableArr[x]
                    lable.text = String.init(format: "%.0f", _yValueArr[x])
                }
            }
            else {
                _yValueArr = arr
                self.setBackground()
            }
            
            
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
            if _xValueArr.count == newValue.count {
                _xValueArr = newValue
                for x in 0..<_xValueArr.count {
                    let lable = self.xLableArr[x]
                    lable.text = _xValueArr[x]
                }
            }
            else {
                _xValueArr = newValue
                self.setXValueLable()
                self.drawPath()
            }
        }
    }
    //x轴pointValueArr
    
    var _pointValueArr : Dictionary<String, Any> = Dictionary()
    var pointValueArr : Dictionary<String, Any> {
        set {
            _pointValueArr = newValue
//            self.setPointData()
//            self.drawPath()
        }
        get{return _pointValueArr}
    }
    
    //底部竖线的layerArr
    var bottomLineArr : [CALayer] = []
    
    //画线layer
    let drawPathLayer : CAShapeLayer = CAShapeLayer()
    //渐变色layer
    let gradientLayer : CAGradientLayer = CAGradientLayer()
    
    //画线点位置arr
    private var pointArr : [CGPoint] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.addSublayer(self.drawPathLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(self.width != self.frame.size.width && self.height != self.frame.size.height) {
            self.width = self.frame.size.width
            self.height = self.frame.size.height
            self.drawPathLayer.frame = CGRect.init(x: self.xLeftOffset, y: self.yTopOffset, width: self.width - self.xLeftOffset - self.xRightOffset, height: self.height - self.yTopOffset - self.yBottomOffset)
            self.drawPathLayer.fillColor = UIColor.clear.cgColor
            self.drawPathLayer.strokeColor = HEXCOLOR(0xcccccc).cgColor
            
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
        self.setPointData()
        self.drawPath()
        self.layer.addSublayer(self.drawPathLayer)
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
    
    func drawPath() {
        
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        let zero : CGFloat = self.height - self.yBottomOffset - self.yTopOffset
        var lastPoint : CGPoint = CGPoint()
        path.move(to: CGPoint.init(x: 0, y: zero))
        for point in self.pointArr {
            path.addLine(to: point)
            lastPoint = point
        }
        path.addLine(to: CGPoint.init(x: lastPoint.x, y: zero))
        path.move(to:  CGPoint.init(x: 0, y: zero))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        self.drawPathLayer.path = path.cgPath
//        self.drawPathLayer.fillColor = UIColor.blue.cgColor
        
        self.gradientLayer.removeFromSuperlayer()
        
        //增加渐变色
        self.gradientLayer.frame = self.drawPathLayer.frame
        self.gradientLayer.colors = [HEXCOLOR(0x867866).cgColor,UIColor.white.cgColor]
        self.gradientLayer.locations = [0.1,0.9]
        self.gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        self.gradientLayer.endPoint = CGPoint.init(x: 0, y: 1)
        self.layer.addSublayer(gradientLayer)
        self.gradientLayer.mask = maskLayer
        
    }
    
    func setPointData() {

        //如果没有x轴坐标值，则返回
        guard self.xValueArr.count > 0 else {
            return
        }
        
        self.pointArr.removeAll()
        
        //设置x轴屏幕y坐标
        let zero : CGFloat = self.height - self.yBottomOffset - self.yTopOffset + 1
        //设置每组数据对应的宽度
        let partWidth : CGFloat = (self.width - self.xLeftOffset - self.xRightOffset) / CGFloat(self.xValueArr.count)
        //y轴最大值和最小值
        var yMax : CGFloat = 0.0
        var yMin : CGFloat = 0.0
        if self.yValueArr.count > 1 {
            yMin = self.yValueArr[self.yValueArr.count - 1]
            yMax = self.yValueArr[0]
        }
        

        //遍历x轴的值，并将对应的值算出坐标点的信息
        for x in 0..<self.xValueArr.count {
            var xPoint : CGFloat = CGFloat(x) * partWidth
            let key = self.xValueArr[x]
            let valueArr  = self.pointValueArr[key] as? Array<Double>
            //遍历每个x段的值，并将每个值计算出point点保存
            if let valueArr = valueArr {
                
                let valuePartWidth = partWidth / CGFloat(valueArr.count)
                for value in valueArr {
                    let y : CGFloat = (1.0 - (CGFloat(value)-yMin) / (yMax - yMin)) * zero
                    self.pointArr.append(CGPoint.init(x: xPoint, y: y))
                    xPoint += valuePartWidth
                    if valueArr.count == 1 {
                        self.pointArr.append(CGPoint.init(x: xPoint, y: y))
                    }
                }
                
            }
            //解包失败则赋0值
            else{
                self.pointArr.append(CGPoint.init(x: xPoint, y: zero))
                xPoint += partWidth
                self.pointArr.append(CGPoint.init(x: xPoint, y: zero))
            }
            
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
