//
//  BWMCrashTempManager.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/15.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMCrashTempManager.h"

static BWMCrashTempManager *_manager = nil;

static NSString *kCheckCrashURLStr = @"http://server.mallteem.com/JsonData/isCrash.json";
static NSString *kAppleStoreURLStr = @"https://itunes.apple.com/app/id914430432";
static NSString *kBandleIdentifier = @"Com.Dulian.BeautifulShop"; // 适用的Bandle Identifier

@interface BWMCrashTempManager() <UIAlertViewDelegate> {
    UIAlertView *_alertView;
}

@end

@implementation BWMCrashTempManager

+ (void)check {
    if (_manager == nil) {
        _manager = [[BWMCrashTempManager alloc] init];
    }
    [_manager startCheck];
}

- (void)startCheck {
    if (![[NSBundle mainBundle].bundleIdentifier isEqualToString:kBandleIdentifier]) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:kCheckCrashURLStr]];
        NSError *err = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err == nil) {
            BOOL isCrash = [dict[@"status"] boolValue];
            if (!isCrash) {
                [self p_showMsg];
                
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
                });
            }
        }
    });
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
//    [self p_showMsg];
}

- (void)p_showMsg {
    if (_alertView == nil) {
        _alertView = [[UIAlertView alloc] initWithTitle:@"版本报废"
                                                message:@"亲，此版本为内部专用版，已经报废，请前往Apple Store下载正版，更多精彩丰富的功能等着亲！下载后，可将此版本删除。"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"前往下载", nil];
    }
    
    if (!_alertView.isVisible) {
        [_alertView show];
    }
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppleStoreURLStr]];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
