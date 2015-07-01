//
//  BWMMyInComeSimplePreviewModel.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/9.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

/** 我的收入预览 */
@interface BWMMyInComeSimplePreviewModel : NSObject <ModelProtocol>

/** 本店收入 */
@property (assign, nonatomic, readonly) double sProfit;

/** 一级分店收入 */
@property (assign, nonatomic, readonly) double rProfit;

/** 二级分店收入 */
@property (assign, nonatomic, readonly) double rProfit_2;

/** 员工提成 */
@property (assign, nonatomic, readonly) double pProfit;

/** 总收入 */
@property (assign, nonatomic, readonly) double sumProfit;

/** 余额 */
@property (assign, nonatomic, readonly) double balance;

/** 已提现 */
@property (assign, nonatomic, readonly) double moneyOut;

@end
