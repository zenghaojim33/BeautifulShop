//
//  BWMSystemConfiguration.m
//  BeautifulShop
//
//  Created by btw on 15/3/10.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMSystemConfigurationManager.h"

static NSString *kIsFirstLaunchingKey = @"kIsFirstLaunchingKey";
static NSString *kIsLoginKey = @"kIsLoginKey";
static BWMSystemConfigurationManager *_systemConfigurationManager = nil;

@interface BWMSystemConfigurationManager()
{
    NSUserDefaults *_userDefaults;
}

@end

@implementation BWMSystemConfigurationManager

- (instancetype)init {
    if (self = [super init]) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (BWMSystemConfigurationManager *)sharedSystemConfigurationManager {
    if (_systemConfigurationManager == nil) {
         @synchronized(self) {
             if (_systemConfigurationManager == nil) {
                 _systemConfigurationManager = [[BWMSystemConfigurationManager alloc] init];
             }
         }
    }
    return _systemConfigurationManager;
}

- (BOOL)isFirstLaunching {
    return [_userDefaults objectForKey:kIsFirstLaunchingKey] == nil;
}

- (void)setNotFirstLaunching {
    if ([self isFirstLaunching]) {
        [_userDefaults setObject:@"NOT" forKey:kIsFirstLaunchingKey];
        [_userDefaults synchronize];
    }
}

- (BOOL)isLogin {
    if (![_userDefaults objectForKey:kIsLoginKey]) {
        [_userDefaults setBool:NO forKey:kIsLoginKey];
    }
    return [_userDefaults boolForKey:kIsLoginKey];
}

- (void)setSignInState {
    [_userDefaults setBool:YES forKey:kIsLoginKey];
}

- (void)setLogOutState {
    [_userDefaults setBool:NO forKey:kIsLoginKey];
}

@end