//
//  OrderInfoModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"
#import "OrderInfoPostAddressModel.h"
#import "OrderInfoProductsModel.h"
#import "OrderStatusFactory.h"

@interface OrderInfoModel : NSObject <ModelProtocol>

/** 订单ID */
@property (strong, nonatomic, readonly) NSString *orderId;

/** 下单时间 */
@property (strong, nonatomic, readonly) NSString *createDate;

/** 物流单号 */
@property (strong, nonatomic, readonly) NSString *expressNo;

/** 物流名称 */
@property (strong, nonatomic, readonly) NSString *expressName;

/** 邮费 */
@property (assign, nonatomic, readonly) float expressPrice;

/** 状态 */
@property (assign, nonatomic, readonly) OrderDetailStatus status;

/** 状态字符串 */
@property (strong ,nonatomic, readonly) NSString *statusString;

/** 收货信息 OrderInfoPostAddressModel */
@property (strong, nonatomic, readonly) OrderInfoPostAddressModel *postAddressModel;

/** 货品参数数组 包含OrderInfoProductsModel的数组 */
@property (strong, nonatomic, readonly) NSMutableArray *productArray;

@end
