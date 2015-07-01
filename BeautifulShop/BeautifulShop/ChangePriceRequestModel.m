//
//  ChangePriceRequestModel.m
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ChangePriceRequestModel.h"
#import "ChangePriceRequestSingleModel.h"
#import "APIFactory.h"

@implementation ChangePriceRequestModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        if (dictionary[@"attr"] &&
            [dictionary[@"attr"] isKindOfClass:[NSArray class]] &&
            [dictionary[@"attr"] count] > 0) {
            
            NSMutableArray *contentArray = [[NSMutableArray alloc] init];
            [dictionary[@"attr"] enumerateObjectsUsingBlock:^(NSDictionary* attrDict, NSUInteger idx, BOOL *stop) {
                ChangePriceRequestSingleModel *cprsModel = [[ChangePriceRequestSingleModel alloc] initWithDictionary:attrDict];
                [contentArray addObject:cprsModel];
            }];
            
            self.contentArray = contentArray;
        }
        
        if (dictionary[@"name"]) {
            self.productName = dictionary[@"name"];
        }
        
        if (dictionary[@"productid"]) {
            self.productID = dictionary[@"productid"];
        }
        
        if (dictionary[@"titleimg"]) {
            self.productImagePath = [APIFactory imageCompletionURLWithSegment:dictionary[@"titleimg"]];
        }
        
    }
    return self;
}

@end
