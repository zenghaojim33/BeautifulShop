//
//  BWMDailyTurnoverViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMDailyTurnoverViewController.h"
#import "UIColor+BWMExtension.h"

@interface BWMDailyTurnoverViewController ()

@end

@implementation BWMDailyTurnoverViewController

- (UIColor *)color {
    return [UIColor colorWithHex:@"#566892" alpha:1.0f];
}

- (BOOL)hasFloat {
    return YES;
}

- (NSString *)theTitle {
    return @"成交金额";
}

- (NSString *)aimString {
    return @"getorderallpric";
}

- (NSString *)apiReturnKey {
    return @"dailyTurnover";
}

- (NSString *)sectionHeaderRightText {
    return @"总金额";
}

@end
