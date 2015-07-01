//
//  UIColorFactory.m
//  BeautifulShop
//
//  Created by btw on 15/3/12.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "UIColorFactory.h"

@implementation UIColorFactory

+ (UIColor *)createColorWithType:(UIColorFactoryColorType)colorType {
    UIColor *color = nil;
    switch (colorType) {
        case UIColorFactoryColorTypeRed:
            color = [UIColor colorWithRed:202/255.0 green:67/255.0 blue:65/255.0 alpha:1.0];
            break;
        case UIColorFactoryCOlorTypeBlue:
            color = [UIColor colorWithRed:0.0 green:162/255.0 blue:233/255.0 alpha:1];
            break;
        case UIColorFactoryColorTypePurple:
            color = [UIColor colorWithRed:248/255.0 green:32/255.0 blue:129/255.0 alpha:1.0];
            break;
        case UIColorFactoryColorTypeDisable:
            color = [UIColor lightGrayColor];
            break;
    }
    return color;
}

@end
