//
//  GoodsModel.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-13.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GoodsModel.h"
#import "FormatStringFactory.h"

@implementation GoodsModel

- (NSString *)finalPrice {
    return [FormatStringFactory priceStringWithFloat:[_finalPrice floatValue]];
}

- (NSString *)marketPrice {
    return [[FormatStringFactory priceStringWithFloat:[_marketPrice floatValue]] stringByAppendingString:@" "];
}

- (NSAttributedString *)marketPriceAttributeString {
    NSMutableAttributedString *marketPriceStr = [[NSMutableAttributedString alloc] initWithString:self.marketPrice];
    [marketPriceStr addAttributes:@{NSStrikethroughStyleAttributeName : @1} range:NSMakeRange(0, self.marketPrice.length)];
    return marketPriceStr;
}

@end
