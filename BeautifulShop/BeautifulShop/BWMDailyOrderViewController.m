//
//  BWMDailyOrderViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMDailyOrderViewController.h"
#import "UIColor+BWMExtension.h"

@interface BWMDailyOrderViewController ()

@end

@implementation BWMDailyOrderViewController

- (UIColor *)color {
    return [UIColor colorWithHex:@"#B04B87" alpha:1.0f];
}

- (BOOL)hasFloat {
    return NO;
}

- (NSString *)theTitle {
    return @"每日订单";
}

- (NSString *)aimString {
    return @"getordercount";
}

- (NSString *)apiReturnKey {
    return @"dailyOrders";
}

- (NSString *)sectionHeaderRightText {
    return @"订单个数";
}

@end
