//
//  OrderInfoStateFactory.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/3.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "OrderInfoDetailStatusFactory.h"

@implementation OrderInfoDetailStatusFactory

+ (NSString *)stringWithOrderDetailStatus:(OrderDetailStatus)orderDetailStatus {
    NSString *resultString = nil;
    switch (orderDetailStatus) {
        case OrderInfoDetailStatusNotPaying:
            resultString = kOrderInfoDetailStatusNotPayingString;
            break;
            
        case OrderInfoDetailStatusWaitSend:
            resultString = kOrderInfoDetailStatusWaitSendString;
            break;
            
        case OrderInfoDetailStatusWaitSignIn:
            resultString = kOrderInfoDetailStatusWaitSignInString;
            break;
            
        case OrderInfoDetailStatusArrived:
            resultString = kOrderInfoDetailStatusArrivedString;
            break;
            
        case OrderInfoDetailStatusApplyForReturn:
            resultString = kOrderInfoDetailStatusApplyForReturnString;
            break;
            
        case OrderInfoDetailStatusAgreeToReturn:
            resultString = kOrderInfoDetailStatusAgreeToReturnString;
            break;
            
        case OrderInfoDetailStatusDisagreenToReturn:
            resultString = kOrderInfoDetailStatusDisagreenToReturnString;
            break;
            
        case OrderInfoDetailStatusReturnSuccess:
            resultString = kOrderInfoDetailStatusReturnSuccessString;
            break;
            
        case OrderInfoDetailStatusCompletion:
            resultString = kOrderInfoDetailStatusCompletionString;
            break;
    }
    return resultString;
}

@end
