//
//  BWMProductPutawayPostModel.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/15.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMProductPutawayPostModel.h"

@interface BWMProductPutawayPostModel() {
    NSMutableArray *_productIDArray;
}

@end

@implementation BWMProductPutawayPostModel

- (instancetype)init {
    if (self = [super init]) {
        _productIDArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)userID {
    return [ShareInfo shareInstance].userModel.userID;
}

- (NSArray *)productsID {
    return _productIDArray;
}

- (void)addProductID:(NSString *)productID {
    [_productIDArray addObject:productID];
}

- (NSDictionary *)postDictionary {
    NSString *pid = [self.productsID componentsJoinedByString:@","];
    NSString *du = nil;
    switch (self.type) {
        case BWMProductPutawayPostModelTypeAdd:
            du = @"add";
            break;
            
        case BWMProductPutawayPostModelTypeDel:
            du = @"del";
            break;
    }
    
    return @{
             @"pid" : pid,
             @"uid" : self.userID,
             @"du" : du
             };
}

+ (NSString *)API {
    return @"http://server.mallteem.com/json/index.ashx?aim=useproduct";
}

+ (instancetype)modelWithType:(BWMProductPutawayPostModelType)type {
    BWMProductPutawayPostModel *model = [[[self class] alloc] init];
    model.type = type;
    return model;
}


@end
