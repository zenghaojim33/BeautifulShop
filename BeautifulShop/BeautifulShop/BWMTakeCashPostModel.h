//
//  BWMTakeCashPostModel.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/21.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestAPIModelProtocol.h"

/** 提现 Post Model */
@interface BWMTakeCashPostModel : NSObject <RequestAPIModelProtocol>

/** 会员编号 */
@property (strong, nonatomic, readonly) NSString *userID;

/** 提现金额字符串格式(0.00) */
@property (strong, nonatomic, readwrite) NSString *totalString;

/** 用户密码 */
@property (strong, nonatomic, readonly) NSString *password;

/** 提现金额(0.00元) */
@property (assign, nonatomic, readonly) double total;

/** 创建提现 Post Model */
+ (instancetype)modelWithTotalString:(NSString *)totalString;

@end
