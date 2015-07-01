//
//  OrderInfoPostAddress.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/2.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

@interface OrderInfoPostAddressModel : NSObject <ModelProtocol>

/** 省份 */
@property (strong, nonatomic, readonly) NSString *province;

/** 城市 */
@property (strong, nonatomic, readonly) NSString *city;

/** 区 */
@property (strong, nonatomic, readonly) NSString *area;

/** 详细地址 */
@property (strong, nonatomic, readonly) NSString *address;

/** 联系人姓名 */
@property (strong, nonatomic, readonly) NSString *linkman;

/** 手机号码 */
@property (strong, nonatomic, readonly) NSString *phone;

/** 邮政编码 */
@property (strong, nonatomic, readonly) NSString *zipcode;

@end
