//
//  OrderInfoProductsModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"
#import "OrderInfoDetailStatusFactory.h"

@interface OrderInfoProductsModel : NSObject <ModelProtocol>

/** 货品数量 */
@property (assign, nonatomic, readonly) int count;

/** 货品单价 */
@property (assign, nonatomic, readonly) float price;

/** detailsID */
@property (strong, nonatomic, readonly) NSString *detailsId;

/** 原始货品id */
@property (strong, nonatomic, readonly) NSString *productId;

/** 首图链接 */
@property (strong, nonatomic, readonly) NSString *productImg;

/** 货品名称 */
@property (strong, nonatomic, readonly) NSString *productName;

/** 物品大小和颜色 */
@property (strong, nonatomic, readonly) NSString *size;

/** 货品状态 */
@property (assign, nonatomic, readonly) OrderDetailStatus status;

/** 货品状态说明（返回如下文字：已申请退货，已同意退货，不同意退货）*/
@property (strong, nonatomic, readonly) NSString *statusString;

@end
