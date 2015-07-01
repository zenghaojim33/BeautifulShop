//
//  UIView+Extension.swift
//  TransferToAnimation
//
//  Created by Bi Weiming on 15/5/12.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

import UIKit

extension UIImageView {
    /*** 添加移动到指定Point的动画 */
    func bwm_transferToPoint(targetPoint:CGPoint) -> Void {
        var window:UIWindow = UIApplication.sharedApplication().keyWindow!
        let rootFrame:CGRect = window.convertRect(self.frame, fromView: self.superview)
        
        var newImage:UIImageView = UIImageView(image: self.image)
        newImage.frame = rootFrame
        newImage.backgroundColor = self.backgroundColor
        newImage.layer.cornerRadius = self.layer.cornerRadius
        newImage.layer.masksToBounds = self.layer.masksToBounds
        UIApplication.sharedApplication().keyWindow?.addSubview(newImage)
        
        UIView.animateWithDuration(1.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            newImage.center = targetPoint
            newImage.alpha = 0.0            
            newImage.transform = CGAffineTransformScale(newImage.transform, 0.2, 0.2)
            }) { (finish:Bool) -> Void in
                if finish {
                    newImage.removeFromSuperview()
                }
        }
    }
    
    func bwm_setImageWithURL(url:String, placeholderImage placeholder:String) -> Void {
        self.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: placeholder), options: SDWebImageOptions.RefreshCached) { (image:UIImage!, err:NSError!, cacheType:SDImageCacheType, url:NSURL!) -> Void in
            self.alpha = 0.0
            if err != nil {
                self.image = UIImage(named: "product_nonpic_placeholder")
            }
            
            UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.alpha = 1.0
            }, completion: nil)
        }
    }
    
    /**
    设置圆角（高性能）
    
    :param: cornerRadius 圆角半径
    */
    func bwm_setRoundedCornersSize(cornerRadius:CGFloat) -> Void {
        self.image = self.image?.bwm_imageWithRoundedCornersSize(cornerRadius)
    }
    
}

