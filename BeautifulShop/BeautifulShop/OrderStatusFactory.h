//
//  OrderStatus.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/2.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kOrderStatusNotPayingString = @"订单未付款";
static NSString * const kOrderStatusUnderwayString = @"订单进行中";
static NSString * const kOrderStatusReturnString = @"订单交易完成";
static NSString * const kOrderStatusOverString = @"订单已完成";

/**
 *  订单的状态
 */
typedef NS_ENUM(NSInteger, OrderStatus) {
    /**
     *  订单未付款
     */
    OrderStatusNotPaying = 0,
    /**
     *  订单进行中包含已发货未收货、已收货（已收货未到七天）
     */
    OrderStatusUnderway = 1,
    /**
     *  订单退货中交易完成（已收货超过7天）
     */
    OrderStatusReturn = 2,
    /**
     *  订单已完成：包含退货的订单
     */
    OrderStatusOver = 3
};

@interface OrderStatusFactory : NSObject

/**
 *  获得OrderStatus枚举值对应的字符串
 *
 *  @param orderStatus OrderStatus枚举值
 *
 *  @return OrderStatus枚举值对应的字符串
 */
+ (NSString *)stringWithOrderStatus:(OrderStatus)orderStatus;

@end

