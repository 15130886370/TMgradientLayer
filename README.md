# TMgradientLayer
渐变色动画
最近在搞这样一个动画：

![动效.gif](http://upload-images.jianshu.io/upload_images/1526313-8f0136e72143801b.gif?imageMogr2/auto-orient/strip)
> 介绍：
最近项目需求做了这样一个动效，其中涉及到的技术点做个总结，好留个笔记。此篇文章旨在实现卡通人物的眼镜和脖子上戴的金牌上面那一道白光闪过的效果。至于动效上其他关于CAShapeLayer + UIBezierPath 画渐变色圆和线的动画放在下一章去谈。

可能你感觉，这不就是一个简单的位移动画吗，给白光图片做一个位移效果不就好了吗，那实现起来简直low逼透了。位置把控不好先不谈，白光闪过去的丝滑效果也远不及使用渐变色CAGradientLayer。用渐变色来实现这个效果的灵感来源于  iOS_Animations_by_Tutorials 这本书。

开始代码之前，先来了解下CAGradientLayer:
 ```
CAGradientLayer的属性

colors: 存放颜色的数组。
locations: 对应数组中颜色的位置。
startPoint, endPoint: 渐变色的起始位置和结束位置。
type: 渐变的类型，可以是颜色像素均匀变化，只有一个默认选择axial
```
好了，上代码

```Swift
//首先自定义一个UIImageView
class LeftGlassesImage: UIImageView {
}
```

```Swift
//然后在LeftGlassesImage中定义一个渐变色layer实例
    let gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        //渐变色起始和结束位置如果是（x: 0,y: 0.5）-> (x: 1,y: 0.5)
        //代表水平方向渐变，这里我设置的是让他有一个偏转角度的
        // 下面有详细的关于渐变方向的图解
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.6)
        
        //颜色数组，两头透明色，中间白色，这样可以凸显出白光
        let colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.colors = colors
        
        //初始位置是关键所在，locations的位置元素对应着colors数组
        //中的颜色元素。这个location是所有的颜色点占整个渐变layer
        //宽度的比例。-0.4的值代表着clearColor的X值在
        // - layer.width * 0.4 这个位置。-0.39 -> -0.24 说明白色区域的
        //  宽度是 layer.width 的0.25倍。
        let locations: [NSNumber] = [
             -0.4,
             -0.39,
             -0.24,
             -0.23
        ]
        gradientLayer.locations = locations
        
        return gradientLayer
    }()
```
  
![渐变方向示意图.png](http://upload-images.jianshu.io/upload_images/1526313-6758d13128dfaf2c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/310)



下面重写layoutSubviews，设置gradientLayer 的frame,并把他添加到self上。

```Swift
    override func layoutSubviews() {
        layer.borderColor = UIColor.green.cgColor
        gradientLayer.frame = CGRect(
            x: -5,
            y: 0,
            width: bounds.size.width ,
            height: bounds.size.height)
        
        layer.addSublayer(gradientLayer)
        
    }
```
剩下的就是添加动画了：

```Swift
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        //动画的keyPath选择locations属性，说明我们要动画的对象
        //是locations数组。
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        //有了上面对于locations的解释，想让渐变色动起来
        //我们的动画起始位置和结束位置这样设置，也并不难理解了
        gradientAnimation.fromValue = [-0.8,-0.79,-0.64,-0.63]
        gradientAnimation.toValue = [1.5,1.51,1.76,1.77]
        gradientAnimation.duration = 1.0
        gradientAnimation.repeatCount = 2
        
        gradientLayer.add(gradientAnimation, forKey: nil)
    }

```
