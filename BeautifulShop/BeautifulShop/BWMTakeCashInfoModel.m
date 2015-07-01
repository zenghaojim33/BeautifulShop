//
//  BWMTakeCashInfoModel.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/21.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMTakeCashInfoModel.h"
#import "ShareInfo.h"
#import "NSString+BWMExtension.h"

@implementation BWMTakeCashInfoModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _bankUserName = dictionary[@"bankUser"];
        _bankName = dictionary[@"bankName"];
        _bankCardNumber = dictionary[@"bankCode"];
    }
    return self;
}

- (NSString *)bankCardNumberAndPersonName {
    return [NSString stringWithFormat:@"%@, %@",[self.bankCardNumber bwm_bankCardNumberString], self.bankUserName];
}

+ (NSString *)API {
    ShareInfo *shareInfo = [ShareInfo shareInstance];
    NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=getmyinfor&userid=%@", shareInfo.userModel.userID];
    return link;
}

- (BOOL)isCompletion {
    return self.bankName.length>0 && self.bankUserName.length>0 && self.bankCardNumber.length>0;
}

@end
