//
//  UIView+BWMExtension.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/12.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "UIView+BWMExtension.h"

@implementation UIView (BWMExtension)

- (void)drawingDefaultStyleShadow {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.layer.shadowOpacity = 0.15f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)bwm_setCircleRadius {
    self.layer.cornerRadius = self.bounds.size.width / 2.0;
    self.layer.masksToBounds = YES;
}

@end
