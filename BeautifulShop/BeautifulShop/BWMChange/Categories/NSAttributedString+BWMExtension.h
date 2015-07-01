//
//  NSAttributedString+BWMExtension.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (BWMExtension)

/**
 *  将指定的字符串修改为特定的颜色
 *
 *  @param sourceText 原字符串
 *  @param textArray  需修改的字符串数组
 *  @param color      目标颜色
 *
 *  @return NSAttributedString
 */
+ (NSAttributedString *)attributedStringWithSourceText:(NSString *)sourceText
                                   willChangeTextArray:(NSArray *)textArray
                                                 color:(UIColor *)color;

@end
