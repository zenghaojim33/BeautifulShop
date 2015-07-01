//
//  ChangePriceRequestModel.h
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

/**
 *  店主修改价格——获取产品
 */
@interface ChangePriceRequestModel : NSObject <ModelProtocol>

@property (assign, nonatomic) NSString *productID;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSURL* productImagePath;

/** 一个包含ChangePriceRequestSingleModel的数组 */
@property (strong, nonatomic) NSArray *contentArray;

@end
