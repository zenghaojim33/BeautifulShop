//
//  ShareInfo.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "O2OUserModel.h"
@interface ShareInfo : NSObject
@property(nonatomic, strong ) O2OUserModel * userModel;
+ (ShareInfo *)shareInstance;

/**
 *  @brief  从微信创建ShareInfo
 *
 *  @param respCode respCode
 */
+ (void)fromWXCreateUserModelWithRespCode:(NSString *)respCode;

/**
 *  @brief  刷新用户Model
 */
+ (void)refreshUserModel;

+ (BOOL)recoverUserModel;

+ (BOOL)saveUserModel;

@end
