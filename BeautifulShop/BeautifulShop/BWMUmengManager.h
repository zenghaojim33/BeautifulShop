//
//  BWMUmengManager.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/13.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocialControllerService.h"
#import "UMSocialSnsService.h"

/** 默认的店铺分享的标题 */
extern NSString * const kDefaultShareShopText;

/** 默认的店铺分享的详情文本 */
extern NSString * const kDefaultShareDetailText;

/** 默认的二维码的分享标题 */
extern NSString * const kDefaultShareQRCodeText;

/** 友盟分享管理者 */
@interface BWMUmengManager : NSObject

/** 初始化分享友盟组件 */
+ (void)initializeUMengShareComponent;

/**
 *  快速调用友盟分享
 *
 *  @param controller  促发的ViewController，通常为self
 *  @param shareTitle  分享的标题
 *  @param shareDetail 分享的详细内容
 *  @param shareImage  分享的图片或图片String、URL
 *  @param shareLink   分享的链接
 *  @param delegate    delegate
 */
+ (void)sharingWithController:(UIViewController *)controller
                   shareTitle:(NSString *)shareTitle
                  shareDetail:(NSString *)shareDetail
                   shareImage:(id)shareImage
                    shareLink:(NSString *)shareLink
                     delegate:(id <UMSocialUIDelegate>)delegate;

/** 设置微信分享类型为网页类型 */
+ (void)settingWXShareTypeWeb;

/** 设置微信分享类型为图像类型 */
+ (void)settingWXShareTypeImage;

/**
 *  @brief  集成微信登陆
 *
 *  @param targetController    触发的目标视图控制器
 *  @param completionCallBlock 授权完成回调的块
 */
+ (void)loginWeixinWithTargetViewController:(UIViewController *)targetController
                                 completion:(void(^)(NSDictionary *dataDict))completionCallBlock;

@end
