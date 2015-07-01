//
//  ShareInfo.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "ShareInfo.h"
#import "BWMRequestCenter.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "BWMSystemConfigurationManager.h"
#import "BWMMBProgressHUD.h"

static ShareInfo *shareInfo = nil;
@interface ShareInfo ()
@end

@implementation ShareInfo

+ (ShareInfo *) shareInstance
{
    if (!shareInfo) {
        shareInfo = [[self alloc] init];
    }
    
    return shareInfo;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (O2OUserModel *)userModel
{
    if (!_userModel) {
        _userModel = [O2OUserModel new];
    }
    return _userModel;
}

+ (void)refreshUserModel {
    NSString *link = [NSString stringWithFormat:LoginO2O, [ShareInfo shareInstance].userModel.phone, [ShareInfo shareInstance].userModel.password, [ShareInfo shareInstance].userModel.udid];
    [BWMRequestCenter GET:link parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        shareInfo.userModel = [MTLJSONAdapter modelOfClass:[O2OUserModel class] fromJSONDictionary:responseObject error:nil];
        NSLog(@"刷新用户数据成功！");
        [ShareInfo saveUserModel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"刷新用户数据失败!");
    }];
}

+ (void)fromWXCreateUserModelWithRespCode:(NSString *)respCode {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:window title:@"正在登录.."];
    
    NSString *ecode = [NSString stringWithFormat:@"ios_%@", [ShareInfo shareInstance].userModel.udid];
    NSString *api = @"http://server.mallteem.com/json/index.ashx?aim=weixinlogin";
    [BWMRequestCenter GET:api parameters:@{@"code" : respCode, @"ecode" : ecode} success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        [self shareInstance].userModel = [MTLJSONAdapter modelOfClass:[O2OUserModel class] fromJSONDictionary:responseObject error:nil];
        [ShareInfo shareInstance].userModel.userID = responseObject[@"id"];
        [[BWMSystemConfigurationManager sharedSystemConfigurationManager] setSignInState];
        [self saveUserModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"用户用微信登陆" object:nil];
        [BWMMBProgressHUD hideHUD:HUD hideAfter:0];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:@"登录失败!" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
}

+ (BOOL)saveUserModel {
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[self shareInstance].userModel forKey:@"UserModel"];
    [archiver finishEncoding];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"UserModel.archiver"];
    return [data writeToFile:path atomically:YES];
}

+ (BOOL)recoverUserModel {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"UserModel.archiver"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [self shareInstance].userModel = [unarchiver decodeObjectForKey:@"UserModel"];
    return YES;
}

@end
