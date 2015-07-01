//
//  NSString+BWMExtension.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/28.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BWMExtension)

/** 生成对应的银行卡号码字符串（每四位数字添加一个空格） */
- (NSString *)bwm_bankCardNumberString;

/** 生成对应的无空白字符的字符串 */
- (NSString *)bwm_clearAllWhiteSpaceCharacters;

/**
 *  @brief  把当前字符串进行MD5加密
 *
 *  @return 返回MD5加密后的字符串
 */
- (NSString *)bwm_MD5String;

/**
 *  @brief  分享的时候把URL转换为微信的
*
 *  @return 微信的专用分享URL
 */
- (NSString *)bwm_wechatURLString;

/**
 *  @brief  获取设备的UDID
 *
 *  @return 设备的UDID
 */
+ (NSString *)bwm_deviceUDID;

- (NSString *)bwm_URLEncodeString;

+ (NSString *)bwm_phoneEncodeString;

@end
