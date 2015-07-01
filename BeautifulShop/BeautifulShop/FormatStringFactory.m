//
//  FormatStringFactory.m
//  BeautifulShop
//
//  Created by btw on 15/3/19.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "FormatStringFactory.h"

@implementation FormatStringFactory

+ (NSString *)priceStringWithFloat:(double)price {
    return [NSString stringWithFormat:@"￥%.2f", price];
}

+ (NSString *)priceStringNotSymbolWithFloat:(double)price {
    return [NSString stringWithFormat:@"%.2f", price];
}

@end
