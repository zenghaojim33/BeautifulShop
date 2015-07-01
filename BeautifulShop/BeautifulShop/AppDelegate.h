//
//  AppDelegate.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-9-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiPushSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,MiPushSDKDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

