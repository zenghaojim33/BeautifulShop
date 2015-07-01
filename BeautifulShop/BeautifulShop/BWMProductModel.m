//
//  BWMProductModel.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMProductModel.h"
#import "FormatStringFactory.h"

@implementation BWMProductModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        self.productID = dict[@"id"];
        if (dict[@"mainImgUrl"]) {
            NSString *imageURLString = [WEB_API stringByAppendingPathComponent:dict[@"mainImgUrl"]];
            self.imageURL = [NSURL URLWithString:imageURLString];
        }
        self.productName = dict[@"productName"];
        self.size = dict[@"_size"];
        if (dict[@"_number"]) {
            self.storeCount = [dict[@"_number"] integerValue];
        }
        self.weiPrice = [dict[@"_finalPrice"] doubleValue];
        self.marketPrice = [dict[@"_marketPrice"] doubleValue];
        self.saleNum = [dict[@"saleNum"] integerValue];
        self.onSaleDate = dict[@"onSaleDate"];
        NSLog(@"%@", _onSaleDate);
        self.desc = dict[@"desc"];
        self.sizeDesc = dict[@"size"];
    }
    return self;
}

- (NSString *)weiPriceString {
    return [FormatStringFactory priceStringWithFloat:_weiPrice];
}

- (NSString *)marketPriceString {
    return [[FormatStringFactory priceStringWithFloat:_marketPrice] stringByAppendingString:@" "];
}

- (NSString *)storeCountString {
    return [NSString stringWithFormat:@"%ld", _storeCount];
}

- (NSAttributedString *)marketPriceAttributeString {
    NSMutableAttributedString *marketPriceStr = [[NSMutableAttributedString alloc] initWithString:self.marketPriceString];
    [marketPriceStr addAttributes:@{NSStrikethroughStyleAttributeName : @1} range:NSMakeRange(0, self.marketPriceString.length)];
    return marketPriceStr;
}

- (NSDate *)realOnSaleDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    return [formatter dateFromString:self.onSaleDate];
}

+ (NSArray *)modelsWithDictArray:(NSArray *)dictArray {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [dictArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        BWMProductModel *model = [[BWMProductModel alloc] initWithDictionary:obj];
        [result addObject:model];
    }];
    return result;
}

+ (NSString *)APIWithPutaway:(BOOL)putaway
                       brand:(NSString *)brand
                    category:(NSString *)category
                         key:(NSString *)key
                        size:(NSInteger)size
                       index:(NSInteger)index
                     orderBy:(BWMProductModelOrderBy)orderBy
{
    brand = brand ? brand : @"";
    category = category ? category : @"";
    key = key ? [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] : @"";
    NSString *userid = @"";
    NSString *saller = [ShareInfo shareInstance].userModel.userID;
    NSString *use = putaway ? @"1" : @"0";
    
    NSString *orderByStr = nil;
    switch (orderBy) {
        case BWMProductModelOrderByUseTime:
            orderByStr = @"usetime desc";
            break;
        case BWMProductModelOrderBySellNumber:
            orderByStr = @"sellnumber desc";
            break;
    }
    
    orderByStr = [orderByStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=getproduct&userid=%@&seller=%@&use=%@&brand=%@&category=%@&key=%@&size=%ld&index=%ld&orderBy=%@", userid, saller, use, brand, category, key, size, index, orderByStr];
}

+ (NSString *)APIWithPutaway:(BOOL)putaway brand:(NSString *)brand category:(NSString *)category key:(NSString *)key size:(NSInteger)size index:(NSInteger)index orderBy:(BWMProductModelOrderBy)orderBy type:(BWMProductModelType)type {
    NSString *api = [self APIWithPutaway:putaway brand:brand category:category key:key size:size index:index orderBy:orderBy];
    api = [api stringByAppendingFormat:@"&class=%d", (int)type];
    return api;
}

+ (NSMutableArray *)orderBy:(BWMProductModelOrderBy)orderBy models:(NSMutableArray *)models {
    if (orderBy == BWMProductModelOrderBySellNumber) {
        [models sortedArrayUsingComparator:^NSComparisonResult(BWMProductModel *obj1, BWMProductModel *obj2) {
            if(obj1.saleNum < obj2.saleNum) return NSOrderedAscending;
            if(obj1.saleNum == obj2.saleNum) return NSOrderedSame;
            return NSOrderedDescending;
        }];
    } else {
        
        [models sortedArrayUsingComparator:^NSComparisonResult(BWMProductModel *obj1, BWMProductModel *obj2) {
            NSDate *ear = [obj1.realOnSaleDate earlierDate:obj2.realOnSaleDate];
            if([ear isEqualToDate:obj1.realOnSaleDate]) return NSOrderedAscending;
            return NSOrderedDescending;
        }];
    }

    return models;
}

@end
