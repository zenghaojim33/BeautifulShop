//
//  BWMTakeCashPostModel.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/21.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMTakeCashPostModel.h"
#import "APIFactory.h"

@implementation BWMTakeCashPostModel

+ (NSString *)API {
    return @"http://server.mallteem.com/AllinPay/Withdrawals.ashx";
}

- (id)getParameterObject {
    return @{
             @"uid" : self.userID,
             @"total" : @(self.total),
             @"pwd" : self.password
             };
}

- (double)total {
    return [self.totalString doubleValue];
}

- (NSString *)userID {
    return [ShareInfo shareInstance].userModel.userID;
}

- (NSString *)password {
    return [ShareInfo shareInstance].userModel.realPassword;
}

+ (instancetype)modelWithTotalString:(NSString *)totalString {
    BWMTakeCashPostModel *model = [[BWMTakeCashPostModel alloc] init];
    model.totalString = totalString;
    return model;
}


@end
