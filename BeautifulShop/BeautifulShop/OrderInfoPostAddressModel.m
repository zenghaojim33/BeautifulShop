//
//  OrderInfoPostAddress.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/2.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "OrderInfoPostAddressModel.h"

@implementation OrderInfoPostAddressModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary[@"province"]) {
            _province = dictionary[@"province"];
        }
        
        if (dictionary[@"city"]) {
            _city = dictionary[@"city"];
        }
        
        if (dictionary[@"area"]) {
            _area = dictionary[@"area"];
        }
        
        if (dictionary[@"address"]) {
            _address = dictionary[@"address"];
        }
        
        if (dictionary[@"linkman"]) {
            _linkman = dictionary[@"linkman"];
        }
        
        if (dictionary[@"phone"]) {
            _phone = dictionary[@"phone"];
        }
        
        if (dictionary[@"zipcode"]) {
            _zipcode = dictionary[@"zipcode"];
        }
    }
    return self;
}

@end
