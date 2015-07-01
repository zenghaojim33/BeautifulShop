//
//  BWMPgyerManager.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/30.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    Framework依赖：
        PgySDK.framwork (drag)
        OpenGLES.framework
        SceneKit.framework (Optional)
        CoreMotion.framework
        AudioToolbox.framework
        AvFoundation.framework
        SystemConfiguration.framework
*/

/** 蒲公英管理器 */
@interface BWMPgyerManager : NSObject

/** 开始使用,需要在application:didFinishLaunchingWithOptions 中调用 */
+ (void)start;

/** 开启用户反馈功能 */
+ (void)openFeedBack;

/** 关闭用户反馈功能 */
+ (void)closeFeedBack;

/** 
 检查更新
 开发者如果在蒲公英上提交了新版本，则老的版本中，可以弹出更新提示，来提示用户更新到最新版本。
 */
+ (void)checkUpdate;

/** 自定义检查更新 */
+ (void)checkUpdateWithCustomBlock:(void(^)(NSDictionary *result))callBlock;

/** 设置用户反馈界面激活方式为三指拖动 */
+ (void)setFeedbackActiveTypeThreeFingersPan;

/** 设置用户反馈界面激活方式为摇一摇 */
+ (void)setFeedbackActiveTypeShake;

/** 配置默认运行，需要在application:didFinishLaunchingWithOptions 中调用 */
+ (void)defaultRun;

@property (copy, nonatomic, readwrite) void(^resultCallBlock)(NSDictionary *resultDict);

@end
