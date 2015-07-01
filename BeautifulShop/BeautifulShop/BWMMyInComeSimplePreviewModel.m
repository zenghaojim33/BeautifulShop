//
//  BWMMyInComeSimplePreviewModel.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/9.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyInComeSimplePreviewModel.h"

@implementation BWMMyInComeSimplePreviewModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        _sProfit = [dictionary[@"sProfit"] doubleValue];
        _rProfit = [dictionary[@"rProfit"] doubleValue];
        _rProfit_2 = [dictionary[@"rProfit_2"] doubleValue];
        _pProfit = [dictionary[@"pProfit"] doubleValue];
        _moneyOut = [dictionary[@"moneyOut"] doubleValue];
        _sumProfit = _sProfit + _rProfit + _rProfit_2 + _pProfit;
        _balance = _sumProfit - _moneyOut;
    }
    return self;
}

@end
