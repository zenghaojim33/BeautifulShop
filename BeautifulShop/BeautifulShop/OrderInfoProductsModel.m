//
//  OrderInfoProductsModel.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderInfoProductsModel.h"

@implementation OrderInfoProductsModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if(dictionary[@"count"]) {
            _count = [dictionary[@"count"] intValue];
        }
        
        if (dictionary[@"price"]) {
            _price = [dictionary[@"price"] floatValue];
        }
        
        if (dictionary[@"detailsId"]) {
            _detailsId = dictionary[@"detailsId"];
        }
        
        if (dictionary[@"productId"]) {
            _productId = dictionary[@"productId"];
        }
        
        if (dictionary[@"productImg"]) {
            _productImg = dictionary[@"productImg"];
        }
        
        if (dictionary[@"productName"]) {
            _productName = dictionary[@"productName"];
        }
        
        if (dictionary[@"size"]) {
            _size = dictionary[@"size"];
        }
        
        if (dictionary[@"status"]) {
            _status = [dictionary[@"status"] integerValue];
            _statusString = [OrderInfoDetailStatusFactory stringWithOrderDetailStatus:_status];
        }
    }
    return self;
}

@end
