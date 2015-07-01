//
//  ChangePriceAPIRequestModel.m
//  BeautifulShop
//
//  Created by btw on 15/3/19.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ChangePriceAPIRequestModel.h"
#import "APIFactory.h"

@implementation ChangePriceAPIRequestModel

- (NSDictionary *)getParameterObject {
    return @{
             @"pid" : self.productID,
             @"uid" : self.BossID
             };
}

+ (NSString *)API {
    return [APIFactory APICompletionServerURLStringWithSegment:@"/json/index.ashx?aim=getallattr"];
}

@end
