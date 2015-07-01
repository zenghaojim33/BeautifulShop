//
//  OrderModel.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-13.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderModel.h"
#import "productModel.h"

@implementation OrderModel

- (NSString *)statusString {
    return [OrderStatusFactory stringWithOrderStatus:_status];
}

- (NSString *)productsName {
    NSMutableArray *names = [NSMutableArray new];
    [self.products enumerateObjectsUsingBlock:^(productModel *model, NSUInteger idx, BOOL *stop) {
        [names addObject:model.productName];
    }];
    return [names componentsJoinedByString:@", "];
}

@end
