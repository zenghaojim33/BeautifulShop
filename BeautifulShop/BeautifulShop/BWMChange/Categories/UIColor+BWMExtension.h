//
//  UIColor+BWMExtension.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/12.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BWMExtension)

/** 输入例如#000000颜色值，和透明度，返回UIColor */
+ (UIColor *)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

/** 根据顾客的手机号码创建一个颜色 */
+ (UIColor *)colorWithCustomerPhone:(NSString *)phoneNumber;

@end
