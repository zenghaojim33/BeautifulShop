//
//  AppDelegate.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-9-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

/*
 《美店》苹果版
     应用类型： iOS
     创建时间： 2014-10-17 16:22:14
     Bundle ID： com.AppStore.BeautifulShop.BeautifulShop
     AppID： 2882303761517264656
     AppKey： 5821726444656
     AppSecret： WRDvNKH2HvP6s5UtpbXmAg==
 
 《美店》企业版
     应用类型： iOS
     创建时间： 2015-06-03 18:27:25
     Bundle ID： Com.Dulian.BeautifulShop
     AppID： 2882303761517342760
     AppKey： 5211734241760
     AppSecret： nAyEdxKPGa0s0m0A1ZbcVw==
 
 */
#import "AppDelegate.h"
#import "StartViewController.h"
//二维码扫描
#import "ZBarSDK.h"
#import "GuestMessageModel.h"
#import "GuestMessageModelViewController.h"
#import "WXApi.h"
#import "BWMUmengManager.h"

#import "BWMPgyerManager.h"
#import "BWMAlertViewFactory.h"
#import "NSString+BWMExtension.h"
#import "BWMRequestCenter.h"
#import "BWMSystemConfigurationManager.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "BWMCrashTempManager.h"

#import "BeautifulShop-Swift.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册远程推送
    [application registerRemotePush];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self disableURLCache];
    
    //向小米推送注册
    [MiPushSDK registerMiPush:self];
    
    // 友盟分享
    [BWMUmengManager initializeUMengShareComponent];
 
    //二维码扫描
    [ZBarReaderView class];
    
    // 蒲公英
    [BWMPgyerManager defaultRun];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UIViewController *rootVC = nil;
    if ([BWMSystemConfigurationManager sharedSystemConfigurationManager].isLogin) {
        [ShareInfo recoverUserModel];
        rootVC = [UIStoryboard initVCOnMainStoryboardWithID:@"ViewControllerNav"];
    } else {
        rootVC = [UIStoryboard initVCOnMainStoryboardWithID:@"StartViewNav"];
    }
    
    self.window.rootViewController = rootVC;
    
    // 过渡启动页动画
    [BWMLaunchScreenView launch];
    
    // 自动蹦破装置
//    [BWMCrashTempManager check];
    
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)disableURLCache {
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
}

#pragma mark 新浪微博回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSLog(@"新浪微博回调：%@",url.description);
    return  [UMSocialSnsService handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([[url scheme]isEqualToString:@"wx13d0fdc20e062e68"]) {
        return [WXApi handleOpenURL:url delegate:self];
    } else {
        return [UMSocialSnsService handleOpenURL:url];
    }
}

- (void)onResp:(BaseResp *)resp {
    if ([resp class] == [SendAuthResp class]) {
        SendAuthResp *newResp = (SendAuthResp *)resp;
        if (newResp.code.length!=0)
        [ShareInfo fromWXCreateUserModelWithRespCode:newResp.code];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //删除通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark 注册push服务.
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    // 注册APNS失败.
    // 自行处理.
    NSLog(@"APNS error: %@", err);
}

#pragma mark Local And Push Notification  接收到的KEY
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"remote notify %@", userInfo);
    
    NSString *messageId = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];

    NSString * type = [userInfo objectForKey:@"type"];
    NSString * msg = userInfo[@"aps"][@"alert"];
    NSLog(@"%@", msg);
    //被迫下线
//    if([type isEqualToString:@"logout"]) {
//        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"您的账号已在另外一台设备上登录，您被迫下线！如果您的账号和密码已泄漏，请及时修改密码！以免造成损失！" message:nil delegate:self cancelButtonTitle:@"重新登录" otherButtonTitles:  nil];
//        av.tag = 999;
//        [av show];
//    }
    
    
    if ([type isEqualToString:@"chat"]) {
        NSMutableDictionary * aps = [userInfo objectForKey:@"aps"];
        NSLog(@"alert:%@",[aps objectForKey:@"alert"]);
        
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"你有一条新客户信息" message:@"详情请查看\"客户管理\"页面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        av.tag = 744;
        [av show];
    }
    
    //新消息通知
    if([type isEqualToString:@"news"]) {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"您有一条新消息" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        av.tag = 998;
        [av show];
    }
    
    if([type isEqualToString:@"upgrade"]) {
        // 发送升级店主通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpgradeBoss" object:nil];
    }
    
    // 检测到苹果有新版本
    if ([type isEqualToString:@"newVersion_apple"]) {
        [BWMSirenManager runWithVersionCheckType:SirenVersionCheckTypeImmediately withDelegate:nil];
    }
    
    // 检测到Pgyer有新版本
    if ([type isEqualToString:@"newVersion_pgyer"]) {
        [BWMPgyerManager checkUpdate];
    }
    
    if ([type isEqualToString:@"order"]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"您有一条新的订单" message:@"详情请查看\"订单管理\"页面" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==999&&buttonIndex==0) {
        // 重新登录
//        [[BWMSystemConfigurationManager sharedSystemConfigurationManager] setLogOutState];
//        UINavigationController * vc = [UIStoryboard initVCOnMainStoryboardWithID:@"StartViewNav"];
//        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }

    if (alertView.tag==744&&buttonIndex==1) {
        NSLog(@"查看新信息");
        //新Messages
    }
    
    if (alertView.tag == 998) {
        
    }
}

#pragma mark MiPushSDKDelegate
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data {
    NSLog(@"succ(%@): %@", selector, data);

    //获取到小米推送ID
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        NSString * regid =[data objectForKey:@"regid"];
        NSLog(@"小米regid：%@",regid);
        [ShareInfo shareInstance].userModel.udid = regid;
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data {
    NSLog(@"error(%@): %@", selector, data);
}

- (void)applicationWillResignActive:(UIApplication *)application {
       [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

@end
