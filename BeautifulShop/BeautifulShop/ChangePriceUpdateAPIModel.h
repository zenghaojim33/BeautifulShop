//
//  ChangePriceUpdateAPIModel.h
//  BeautifulShop
//
//  Created by btw on 15/3/19.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestAPIModelProtocol.h"

/**
 *  店主修改价格——提交
 */
@interface ChangePriceUpdateAPIModel : NSObject <RequestAPIModelProtocol>

/**
 *  包含一些字典的数组
    <att>%@</att>
    <prc>%@</prc>
 */
@property (strong, nonatomic) NSArray *XMLNoteArray;

@property (assign, nonatomic) NSString* bossID;
@property (assign, nonatomic) NSString * productID;

@end
