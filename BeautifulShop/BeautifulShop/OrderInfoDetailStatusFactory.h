//
//  OrderInfoStateFactory.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/3.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kOrderInfoDetailStatusNotPayingString = @"未付款";
static NSString * const kOrderInfoDetailStatusWaitSendString = @"待发货";
static NSString * const kOrderInfoDetailStatusWaitSignInString = @"待签收";
static NSString * const kOrderInfoDetailStatusArrivedString = @"已到货";
static NSString * const kOrderInfoDetailStatusApplyForReturnString = @"申请退货";
static NSString * const kOrderInfoDetailStatusAgreeToReturnString = @"同意退货";
static NSString * const kOrderInfoDetailStatusDisagreenToReturnString = @"不同意退货";
static NSString * const kOrderInfoDetailStatusReturnSuccessString = @"退货成功";
static NSString * const kOrderInfoDetailStatusCompletionString = @"完成订单";

/**
 *  订单明细的状态Enum
 */
typedef NS_ENUM(NSInteger, OrderDetailStatus){
    /**
     *  未付款
     */
    OrderInfoDetailStatusNotPaying = 0,
    /**
     *  待发货
     */
    OrderInfoDetailStatusWaitSend = 1,
    /**
     *  待签收
     */
    OrderInfoDetailStatusWaitSignIn = 2,
    /**
     *  已到货
     */
    OrderInfoDetailStatusArrived  = 3,
    /**
     *  申请退货
     */
    OrderInfoDetailStatusApplyForReturn = 4,
    /**
     *  同意退货
     */
    OrderInfoDetailStatusAgreeToReturn = 5,
    /**
     *  不同意退货
     */
    OrderInfoDetailStatusDisagreenToReturn = 6,
    /**
     *  退货成功
     */
    OrderInfoDetailStatusReturnSuccess = 7,
    /**
     *  完成订单
     */
    OrderInfoDetailStatusCompletion = 8
};

/**
 *  订单明细的状态
 */
@interface OrderInfoDetailStatusFactory : NSObject

/**
 *  获得OrderDetailStatus枚举值对应的字符串
 *
 *  @param orderDetailStatus OrderDetailStatus枚举值
 *
 *  @return 获得OrderDetailStatus枚举值对应的字符串
 */
+ (NSString *)stringWithOrderDetailStatus:(OrderDetailStatus)orderDetailStatus;

@end
