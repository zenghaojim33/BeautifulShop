//
//  UIColor+BWMExtension.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/12.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "UIColor+BWMExtension.h"

@implementation UIColor (BWMExtension)

+ (UIColor *)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha {
    assert(7 == [hex length]);
    assert('#' == [hex characterAtIndex:0]);
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [UIColor colorWithRed:(redInt/255.0) green:(greenInt/255.0) blue:(blueInt/255.0) alpha:alpha];
}

+ (NSArray *)p_randomColorArray {
    return @[
             [self colorWithHex:@"#e57373" alpha:1.0],
             [self colorWithHex:@"#f06292" alpha:1.0],
             [self colorWithHex:@"#ba68c8" alpha:1.0],
             [self colorWithHex:@"#9575cd" alpha:1.0],
             [self colorWithHex:@"#7986cb" alpha:1.0],
             [self colorWithHex:@"#64b5f6" alpha:1.0],
             [self colorWithHex:@"#4fc3f7" alpha:1.0],
             [self colorWithHex:@"#4dd0e1" alpha:1.0],
             [self colorWithHex:@"#4db6ac" alpha:1.0],
             [self colorWithHex:@"#81c784" alpha:1.0],
             [self colorWithHex:@"#aed581" alpha:1.0],
             [self colorWithHex:@"#ff8a65" alpha:1.0],
             [self colorWithHex:@"#d4e157" alpha:1.0],
             [self colorWithHex:@"#ffd54f" alpha:1.0],
             [self colorWithHex:@"#ffb74d" alpha:1.0],
             [self colorWithHex:@"#a1887f" alpha:1.0],
             [self colorWithHex:@"#90a4ae" alpha:1.0]
             ];
}

+ (UIColor *)colorWithCustomerPhone:(NSString *)phoneNumber {
    NSArray *colorsArray = [self p_randomColorArray];
    NSUInteger index =  [phoneNumber longLongValue] % colorsArray.count;
    return [colorsArray objectAtIndex:index];
}

@end
