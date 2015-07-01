//
//  FormatStringFactory.h
//  BeautifulShop
//
//  Created by btw on 15/3/19.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatStringFactory : NSObject

/** 价格字符串，包含人民币符号 */
+ (NSString *)priceStringWithFloat:(double)price;

/** 返回价格不需要人民币符号 */
+ (NSString *)priceStringNotSymbolWithFloat:(double)price;

@end
