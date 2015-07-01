//
//  BWMTakeCashInfoModel.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/21.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

@interface BWMTakeCashInfoModel : NSObject <ModelProtocol>

/** 银行名称 */
@property (strong, nonatomic, readonly) NSString *bankName;

/** 银行持卡人姓名 */
@property (strong, nonatomic, readonly) NSString *bankUserName;

/** 银行卡号码 */
@property (strong, nonatomic, readonly) NSString *bankCardNumber;

/** 返回卡号和持卡人拼接的字符串 */
- (NSString *)bankCardNumberAndPersonName;

/** BWMTakeCashInfoModel请求的API */
+ (NSString *)API;

/** 是否完整地包含银行名称、持卡人姓名、银行卡号 */
- (BOOL)isCompletion;

@end
