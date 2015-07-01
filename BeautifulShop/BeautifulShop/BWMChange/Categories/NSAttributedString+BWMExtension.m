//
//  NSAttributedString+BWMExtension.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "NSAttributedString+BWMExtension.h"

@implementation NSAttributedString (BWMExtension)

+ (NSAttributedString *)attributedStringWithSourceText:(NSString *)sourceText willChangeTextArray:(NSArray *)textArray color:(UIColor *)color {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:sourceText];
    
    [textArray enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
        NSRange range = [sourceText rangeOfString:text options:NSBackwardsSearch];
        [result addAttribute:NSForegroundColorAttributeName value:color range:range];
    }];
    
    return result;
}

@end
