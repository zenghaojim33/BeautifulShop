//
//  ChangePriceAPIRequestModel.h
//  BeautifulShop
//
//  Created by btw on 15/3/19.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestAPIModelProtocol.h"

/**
 *  店主修改价格——获取产品的API Model
 */
@interface ChangePriceAPIRequestModel : NSObject <RequestAPIModelProtocol>

@property (assign, nonatomic) NSString * productID;
@property (assign, nonatomic) NSString * BossID;

@end
