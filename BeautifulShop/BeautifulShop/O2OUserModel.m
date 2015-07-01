//
//  O2OUserModel.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "O2OUserModel.h"

@implementation O2OUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userID" : @"id",
             @"isDataOK" : @"isDataOK",
             @"isFirtLogin" : @"isFirtLogin",
             @"isPaid" : @"isPaid",
             @"name" : @"name",
             @"parentId" : @"parentId",
             @"parentName" : @"parentName",
             @"password" : @"password",
             @"phone" : @"phone",
             @"regFee" : @"regFee",
             @"status" : @"status",
             @"token" : @"token",
             @"uimg" : @"uimg",
             @"userType" : @"userType"
             };
}

- (NSString *)userID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
}

- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)realPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"RealPasword"];
}

- (void)setRealPassword:(NSString *)realPassword {
    [[NSUserDefaults standardUserDefaults] setObject:realPassword forKey:@"RealPasword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)uimg {
    if ([_uimg hasPrefix:@"http"]) {
        return _uimg;
    } else {
        return [NSString stringWithFormat:@"http://server.mallteem.com%@",_uimg];
    }
}

- (void)setUdid:(NSString *)udid {
    [[NSUserDefaults standardUserDefaults] setObject:udid forKey:@"UserRegid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)udid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserRegid"];
}


@end
