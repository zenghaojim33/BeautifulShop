//
//  BWMPgyerManager.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/30.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMPgyerManager.h"
#import <PgySDK/PgyManager.h>

// kPGY_APP_ID即在蒲公英上获取的App Id。
static NSString * const kPGY_APP_ID = @"9adf9c0d3f9b538858f9c20acbf4755c";

// 需要开启的Bundle Identity
static NSString * const kBUNDLE_IDENTIFIER = @"Com.Dulian.BeautifulShop";

@implementation BWMPgyerManager

- (void)p_addCustomCheckUpdateAction {
    [[PgyManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];
}

// updateMethod为检查更新的回调方法。如果有新版本，则包含新版本信息的字典会被回传，否则字典为nil。
- (void)updateMethod:(NSDictionary *)resultDict {
    if (_resultCallBlock) {
        _resultCallBlock(resultDict);
    }
    
    [[PgyManager sharedPgyManager] updateLocalBuildNumber];
}

+ (void)start {
    [[PgyManager sharedPgyManager] startManagerWithAppId:kPGY_APP_ID];
}

+ (void)closeFeedBack {
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
}

+ (void)openFeedBack {
    [[PgyManager sharedPgyManager] setEnableFeedback:YES];
}

+ (void)checkUpdate {
    [[PgyManager sharedPgyManager] checkUpdate];
}

+ (void)checkUpdateWithCustomBlock:(void (^)(NSDictionary *))callBlock {
    BWMPgyerManager *manager = [[BWMPgyerManager alloc] init];
    manager.resultCallBlock = callBlock;
    [manager p_addCustomCheckUpdateAction];
}

+ (void)setFeedbackActiveTypeThreeFingersPan {
    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeThreeFingersPan];
}

+ (void)setFeedbackActiveTypeShake {
    //设置用户反馈界面激活方式为摇一摇
    [[PgyManager sharedPgyManager] setFeedbackActiveType:kPGYFeedbackActiveTypeShake];
}

+ (void)defaultRun {
    [self start];
    [self closeFeedBack]; // 关闭反馈功能
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([bundleIdentifier isEqualToString:kBUNDLE_IDENTIFIER]) {
        [self checkUpdate];
    }
}

@end
