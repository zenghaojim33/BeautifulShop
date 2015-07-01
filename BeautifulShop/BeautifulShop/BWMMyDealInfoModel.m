//
//  BWMMyDealInfoModel.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/10.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyDealInfoModel.h"
#import "FormatStringFactory.h"

@implementation BWMMyDealInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _orderCode =  dictionary[@"orderCode"];
        _money = [dictionary[@"money"] doubleValue];
        _type = [dictionary[@"type"] unsignedIntegerValue];
        _remark = dictionary[@"remark"];
        _date = dictionary[@"date"];
        
        if (_type == BWMMyDealInfoTypeIncome) {
            _moneyString = [@"+" stringByAppendingString:[FormatStringFactory priceStringWithFloat:_money]];
            _typeString = @"收入";
        } else {
            _moneyString = [@"-" stringByAppendingString:[FormatStringFactory priceStringWithFloat:_money]];
            _typeString = @"提现";
        }
    }
    return self;
}

+ (NSArray *)arrayWithArray:(NSArray *)array {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        BWMMyDealInfoModel *model = [[BWMMyDealInfoModel alloc] initWithDictionary:dict];
        [resultArray addObject:model];
    }];
    return resultArray;
}

@end
