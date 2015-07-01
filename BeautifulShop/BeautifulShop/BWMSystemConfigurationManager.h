//
//  BWMSystemConfiguration.h
//  BeautifulShop
//
//  Created by btw on 15/3/10.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 管理系统配置的类 */
@interface BWMSystemConfigurationManager : NSObject

/** 是否第一次启动 */
- (BOOL)isFirstLaunching;

/** 设置成非第一次启动 */
- (void)setNotFirstLaunching;

/**
 *  @brief  是否已经登陆
 *
 *  @return 返回YES就为已经登陆
 */
- (BOOL)isLogin;

/**
 *  @brief  设置登录状态
 */
- (void)setSignInState;

/**
 *  @brief  设置退出登录状态
 */
- (void)setLogOutState;

/** 访问BWMSystemConfigurationManager */
+ (BWMSystemConfigurationManager *)sharedSystemConfigurationManager;

@end
