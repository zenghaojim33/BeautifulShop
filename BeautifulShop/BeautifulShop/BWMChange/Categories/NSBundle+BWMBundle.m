//
//  NSBundle+BWM_Bundle.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "NSBundle+BWMBundle.h"

@implementation NSBundle (BWMBundle)

+ (id)loadViewWithNibNamed:(NSString *)nibNamed {
    return [[[NSBundle mainBundle] loadNibNamed:nibNamed owner:nil options:nil] lastObject];
}

@end
