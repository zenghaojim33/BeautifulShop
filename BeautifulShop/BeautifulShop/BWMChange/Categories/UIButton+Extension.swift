//
//  UIButton+Extension.swift
//  TransferToAnimation
//
//  Created by Bi Weiming on 15/5/12.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

import UIKit

extension UIButton {
    /*** 添加移动到指定Point的动画 */
    func bwm_transferToPoint(targetPoint:CGPoint) -> Void {
        var window:UIWindow = UIApplication.sharedApplication().keyWindow!
        let rootFrame:CGRect = window.convertRect(self.frame, fromView: self.superview)
        
        var newButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        newButton.frame = rootFrame
        newButton.backgroundColor = self.backgroundColor
        newButton.layer.cornerRadius = self.layer.cornerRadius
        newButton.layer.masksToBounds = self.layer.masksToBounds
        newButton.setImage(self.imageForState(UIControlState.Normal), forState: UIControlState.Normal)
        newButton.setTitle(self.titleForState(UIControlState.Normal), forState: UIControlState.Normal)
        UIApplication.sharedApplication().keyWindow?.addSubview(newButton)
        
        UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            newButton.center = targetPoint
            newButton.alpha = 0.0
            newButton.transform = CGAffineTransformScale(newButton.transform, 0.2, 0.2)
            }) { (finish:Bool) -> Void in
                if finish {
                    newButton.removeFromSuperview()
                }
        }
    }
}