//
//  ChangePriceRequestSingleModel.m
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ChangePriceRequestSingleModel.h"

@implementation ChangePriceRequestSingleModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (dictionary[@"attributeId"]) {
            self.attributeID = dictionary[@"attributeId"];
        }
        
        if (dictionary[@"size"]) {
            self.sizeTitle = dictionary[@"size"];
        }
        
        if (dictionary[@"basePrice"]) {
            self.basePrice = [dictionary[@"basePrice"] floatValue];
        }
        
        
        if (dictionary[@"price"]) {
            self.price = [dictionary[@"price"] floatValue];
        }
        
    }
    return self;
}

@end
