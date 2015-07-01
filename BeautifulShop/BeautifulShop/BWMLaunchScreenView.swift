//
//  BWMLaunchScreenView.swift
//  BeautifulShop
//
//  Created by Bi Weiming on 15/5/15.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

import UIKit

/**
*  一个自定义启动页的动画过渡视图
*/
@objc class BWMLaunchScreenView : UIView {
    // < 在此配置常量
    private let 过渡风格常量:String = "rippleEffect"  // CAAnimation.type = ...
    private let 动画持续时间:Double = 2.0
    private let iPhone4启动图片名称:String = "login_bg"
    private let iPhone5启动图片名称:String = "login_bg"
    private let iPhone6启动图片名称:String = "login_bg"
    private let iPhone6Plus启动图片名称:String = "login_bg"
    // 配置常量结束 >
    
    private var 启动底图:UIImageView!
    
    /**
    在AppDelegate里面调用此API，适用BWMLaunchScreenView
    */
    static func launch() -> Void {
        self.启动()
    }
    
    private static func 启动() -> Void {
        var theView:BWMLaunchScreenView = BWMLaunchScreenView()
        var window:UIWindow? = UIApplication.sharedApplication().windows.last as? UIWindow
        if window != nil {
            window!.rootViewController?.view.addSubview(theView)
        }
    }
    
    private func 创建UI() -> Void {
        self.启动底图 = UIImageView(frame: self.bounds)
        self.启动底图.contentMode = UIViewContentMode.Top
        switch UIScreen.mainScreen().bounds.height {
        case 480:
            self.启动底图.image = UIImage(named: iPhone4启动图片名称)
        case 568:
            self.启动底图.image = UIImage(named: iPhone5启动图片名称)
        case 667:
            self.启动底图.image = UIImage(named: iPhone6启动图片名称)
        case 736:
            self.启动底图.image = UIImage(named: iPhone6Plus启动图片名称)
        default:
            break
        }
        self.addSubview(self.启动底图)
    }
    
    func 启动动画效果() -> Void {
        var transition:CATransition = CATransition()
        transition.duration = 动画持续时间
        transition.type = 过渡风格常量
        self.layer.addAnimation(transition, forKey: "transition")
        
        UIView.animateWithDuration(动画持续时间, animations: { () -> Void in
            self.alpha = 0.0
            }) { (finish:Bool) -> Void in
                if finish {
                    self.removeFromSuperview()
                }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.创建UI()
        NSTimer.scheduledTimerWithTimeInterval(0.001, target: self, selector: "启动动画效果", userInfo: nil, repeats: false)
    }
    
    convenience init() {
        self.init(frame: UIScreen.mainScreen().bounds)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
