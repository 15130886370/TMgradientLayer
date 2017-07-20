//
//  ViewController.swift
//  TMGradientLayer
//
//  Created by ittmomWang on 2017/7/20.
//  Copyright © 2017年 ittmomProject. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backCircle: UIImageView!
    var circle: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        renderCircle()
    }
    
    func renderCircle() {
        let startAngle: CGFloat = .pi * 0.25
        let endAngle: CGFloat = .pi * 2
        let centerX = self.backCircle.width/2
        let centerY = self.backCircle.height/2
        let center = CGPoint(x: centerX,y: centerY)
        let lineWidth: CGFloat = 16.0

        circle = CAShapeLayer()
        //绘制圆
        let circlePath = UIBezierPath.init(arcCenter: center, radius: 240/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        circle.path = circlePath.cgPath
        //中间透明
        circle.fillColor = UIColor.clear.cgColor
        //临时颜色，下面会用到渐变色来渲染圆环颜色
        circle.strokeColor = UIColor.green.cgColor
        //设置线宽
        circle.lineWidth = lineWidth
        //设置圆环头部样式
        circle.lineCap = kCALineCapRound
        //把自己定义的circle 添加到 背景圆环的layer上
        backCircle.layer.addSublayer(circle)
        
        //下面设置画圆弧的动画
        let circleAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circleAnimation.duration = 2
        circleAnimation.fromValue = 0.0
        circleAnimation.toValue = 1.0
        //动画节奏，淡出
        circleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        //把动画添加到layer上
        circle.add(circleAnimation, forKey: nil)
        
        //下面重点来了:
        //1. 之所以能实现圆环的渐变色，并不是我们可以直接在layer上添加一个圆环形状的渐变色，而是
        //创建一个通用的正方形渐变色区域，用我们的circle 作为这个渐变区域的mask来截取一个圆环形状的渐变色
        //区域。
        //2. 为了制造圆环的渐变色效果，只创建一块渐变区域，那是不够的，因为那样画出来的圆左右方向的圆弧颜色
        //是对称的，那样就太丑了，不符合整体渐变的要求。所以，我把这个正方形渐变区域垂直切分成两块渐变区域，
        //左右区域的颜色顺序相反，起始和结束位置也相反,就出来圆环渐变的效果了。
        
        let gradientLayer = CALayer()
        
        //创建第一个gradientLayer
        let colors1 = [
            UIColor.RGBA(red: 49, green: 240, blue: 233, alpha: 1.0).cgColor,
            UIColor.RGBA(red: 69, green: 240, blue: 210, alpha: 1.0).cgColor,
            UIColor.RGBA(red: 143, green: 238, blue: 147, alpha: 1.0).cgColor,
            UIColor.RGBA(red: 220, green: 237, blue: 92, alpha: 1.0).cgColor,
            UIColor.RGBA(red: 253, green: 237, blue: 74, alpha: 1.0).cgColor
        ]
        let frame1 = CGRect(x: 0, y: 0, width: backCircle.width/2, height: backCircle.height)
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.startPoint = CGPoint(x: 0.5,y: 0)
        gradientLayer1.endPoint = CGPoint(x: 0.5,y: 1)
        gradientLayer1.frame = frame1
        gradientLayer1.colors = colors1
        
        //创建第二个gradientLayer
        let colors2 = [
            UIColor.RGBA(red: 253, green: 237, blue: 74, alpha: 1.0).cgColor,
            UIColor.RGBA(red: 224, green: 238, blue: 59, alpha: 1.0).cgColor,
            UIColor.RGBA(red: 148, green: 238, blue: 146, alpha: 1.0).cgColor,
            UIColor.RGBA(red: 49, green: 240, blue: 233, alpha: 1.0).cgColor,
            ]
        let frame2 = CGRect(x: backCircle.width/2, y: 0, width: backCircle.width/2, height: backCircle.height)

        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.startPoint = CGPoint(x: 0.5,y: 1)
        gradientLayer2.endPoint = CGPoint(x: 0.5,y: 0)
        gradientLayer2.frame = frame2
        gradientLayer2.colors = colors2
        
        //用一个gradientLayer来承接这两个渐变区域
        gradientLayer.addSublayer(gradientLayer1)
        gradientLayer.addSublayer(gradientLayer2)
        //用circle的path形状来截取渐变区域
        gradientLayer.mask = circle
        
        backCircle.layer.addSublayer(gradientLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

extension UIColor {
    class func RGBA(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}


