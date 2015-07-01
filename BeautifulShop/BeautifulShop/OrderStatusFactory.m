//
//  OrderStatus.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/2.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "OrderStatusFactory.h"



@implementation OrderStatusFactory

+ (NSString *)stringWithOrderStatus:(OrderStatus)orderStatus {
    NSString *resultString = nil;
    switch (orderStatus) {
        case OrderStatusNotPaying:
            resultString = kOrderStatusNotPayingString;
            break;
        case OrderStatusUnderway:
            resultString = kOrderStatusUnderwayString;
            break;
        case OrderStatusReturn:
            resultString = kOrderStatusReturnString;
            break;
        case OrderStatusOver:
            resultString = kOrderStatusOverString;
            break;
        default:
            break;
    }
    
    return resultString;
}


@end
