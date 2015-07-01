//
//  UIColorFactory.h
//  BeautifulShop
//
//  Created by btw on 15/3/12.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UIColorFactoryColorType) {
    UIColorFactoryColorTypeRed = 0,
    UIColorFactoryCOlorTypeBlue,
    UIColorFactoryColorTypePurple,
    UIColorFactoryColorTypeDisable
};

/**
 *  颜色简单工厂
 */
@interface UIColorFactory : NSObject

/** 创建不同的颜色 */
+ (UIColor *)createColorWithType:(UIColorFactoryColorType)colorType;



@end
