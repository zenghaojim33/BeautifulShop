//
//  BWMBankAccountChangeRequestModel.m
//  BeautifulShop
//
//  Created by 伟明 毕 on 15/4/11.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMBankAccountChangeRequestModel.h"
#import "ShareInfo.h"
#import "BWMBankCoder.h"

@implementation BWMBankAccountChangeRequestModel

- (instancetype)init {
    if (self = [super init]) {
        _userid = [ShareInfo shareInstance].userModel.userID;
    }
    return self;
}

+ (NSString *)API {
    return @"http://server.mallteem.com/json/index.ashx?aim=bankinfo";
}

- (id)getParameterObject {
    return @{
             @"userid" : _userid,
             @"bname" : _bname,
             @"bcode" : _bcode,
             @"buser" : _buser,
             @"bankNumber" : self.bankNumber
             };
}

- (NSString *)bankNumber {
    return [BWMBankCoder bankCodeWithName:self.bname];
}

+ (instancetype)modelWithbname:(NSString *)bname bcode:(NSString *)bcode buser:(NSString *)buser {
    BWMBankAccountChangeRequestModel *model = [[BWMBankAccountChangeRequestModel alloc] init];
    model.bname = bname;
    model.bcode = bcode;
    model.buser = buser;
    return model;
}

@end
