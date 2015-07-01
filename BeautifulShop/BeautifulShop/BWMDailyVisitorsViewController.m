//
//  BWMDailyVisitorsViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMDailyVisitorsViewController.h"
#import "UIColor+BWMExtension.h"

@interface BWMDailyVisitorsViewController ()

@end

@implementation BWMDailyVisitorsViewController

- (UIColor *)color {
    return [UIColor colorWithHex:@"#E95A6F" alpha:1.0f];
}

- (BOOL)hasFloat {
    return NO;
}

- (NSString *)theTitle {
    return @"每日访客";
}

- (NSString *)aimString {
    return @"getvisitercount";
}

- (NSString *)apiReturnKey {
    return @"dailyVisitors";
}

- (NSString *)sectionHeaderRightText {
    return @"访客个数";
}

@end
