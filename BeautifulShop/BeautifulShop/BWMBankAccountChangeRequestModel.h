//
//  BWMBankAccountChangeRequestModel.h
//  BeautifulShop
//
//  Created by 伟明 毕 on 15/4/11.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestAPIModelProtocol.h"

/** 修改银行信息请求Post Model */
@interface BWMBankAccountChangeRequestModel : NSObject <RequestAPIModelProtocol>

/** 用户ID */
@property (strong, nonatomic, readonly) NSString *userid;

/** 银行名称 */
@property (strong, nonatomic, readwrite) NSString *bname;

/** 银行卡号码 */
@property (strong, nonatomic, readwrite) NSString *bcode;

/** 银行开户人名 */
@property (strong, nonatomic, readwrite) NSString *buser;

/** 银行编号（readonly） */
@property (strong, nonatomic, readonly) NSString *bankNumber;

/** create BWMBankAccountChangeRequestModel */
+ (instancetype)modelWithbname:(NSString *)bname bcode:(NSString *)bcode buser:(NSString *)buser;

@end
