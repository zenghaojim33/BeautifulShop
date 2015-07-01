//
//  OrderInfoModel.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderInfoModel.h"
#import "OrderInfoDetailStatusFactory.h"

@implementation OrderInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary[@"orderId"]) {
            _orderId = dictionary[@"orderId"];
        }
        
        if (dictionary[@"createDate"]) {
            _createDate = dictionary[@"createDate"];
        }
        
        if (dictionary[@"expressNo"]) {
            _expressNo = dictionary[@"expressNo"];
        }
        
        if (dictionary[@"expressName"]) {
            _expressName = dictionary[@"expressName"];
        }
        
        if (dictionary[@"expressPrice"]) {
            _expressPrice = [dictionary[@"expressPrice"] floatValue];
        }
        
        if (dictionary[@"status"]) {
            _status = [dictionary[@"status"] intValue];
            _statusString = [OrderInfoDetailStatusFactory stringWithOrderDetailStatus:_status];
        }
        
        if (dictionary[@"postAddress"]) {
            _postAddressModel = [[OrderInfoPostAddressModel alloc] initWithDictionary:dictionary[@"postAddress"]];
        }
        
        if (dictionary[@"products"] && [dictionary[@"products"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *productArray = [NSMutableArray new];
            [dictionary[@"products"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                OrderInfoProductsModel *model = [[OrderInfoProductsModel alloc] initWithDictionary:obj];
                [productArray addObject:model];
            }];
            _productArray = productArray;
        }
        
        
    }
    return self;
}

@end
