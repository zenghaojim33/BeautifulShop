//
//  OrderModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-13.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderStatusFactory.h"

@interface OrderModel : NSObject

@property(nonatomic,strong)NSString * orderId;
@property(nonatomic,assign)NSUInteger status;
@property(strong, nonatomic, readonly) NSString *statusString;
@property(nonatomic,strong)NSString * price;
@property(nonatomic,strong)NSString * createTime;

@property(nonatomic,strong)NSMutableArray * products;
@property(nonatomic, strong)NSString *buyer;

// 产品名称
@property(nonatomic, strong, readonly) NSString *productsName;


// DEBUG
@property(nonatomic,strong)NSString * orderNo;
@property(nonatomic,strong)NSString * createAcc;

@end
