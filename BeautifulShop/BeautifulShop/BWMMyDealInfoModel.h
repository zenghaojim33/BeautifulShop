//
//  BWMMyDealInfoModel.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/10.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

/**
 *  我的交易信息类型
 */
typedef NS_ENUM(NSUInteger, BWMMyDealInfoType){
    /**
     *  收入和提现（全部）
     */
    BWMMyDealInfoTypeAll = 0,
    /**
     *  收入
     */
    BWMMyDealInfoTypeIncome = 1,
    /**
     *  提现
     */
    BWMMyDealInfoTypeTakeOut =2
};

/** 我的交易信息：提现、收入model */
@interface BWMMyDealInfoModel : NSObject <ModelProtocol>

/** 订单号 */
@property (strong, nonatomic, readonly) NSString *orderCode;

/** 钱 */
@property (assign, nonatomic, readonly) double money;

/** 钱，字符串格式 */
@property (strong, nonatomic, readonly) NSString *moneyString;

/** 交易类型 */
@property (assign, nonatomic, readonly) BWMMyDealInfoType type;

/** 交易类型，字符串格式 */
@property (assign, nonatomic, readonly) NSString *typeString;

/** remark */
@property (strong, nonatomic, readonly) NSString *remark;

/** 交易日期 */
@property (strong, nonatomic, readonly) NSString *date;



/** 传入数组返回包含BWMMyDealInfoModel的数组 */
+ (NSArray *)arrayWithArray:(NSArray *)array;

@end
