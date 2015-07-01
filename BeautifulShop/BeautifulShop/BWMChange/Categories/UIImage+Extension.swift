//
//  UIImage+Extension.swift
//  BeautifulShop
//
//  Created by Bi Weiming on 15/5/21.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

import UIKit

extension UIImage {
    /**
    为Image设置一个圆角
    
    :param: cornerRadius 圆角半径
    
    :returns: 返回一个圆角化的副本Image
    */
    func bwm_imageWithRoundedCornersSize(cornerRadius:CGFloat) -> UIImage {
        var frame:CGRect = CGRectMake(0, 0, self.size.width, self.size.height);
        // Begin a new image that will be the new image with the rounded corners
        // (here with the size of an UIImageView)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1.0);
        // Add a clip before drawing anything, in the shape of an rounded rect
        UIBezierPath(roundedRect: frame, cornerRadius: cornerRadius).addClip()
        // Draw your image
        self.drawInRect(frame)
        // Retrieve and return the new image
        var imageResult:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return imageResult
    }
}