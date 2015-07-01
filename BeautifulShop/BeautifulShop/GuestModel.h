//
//  GuestModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-11.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuestModel : NSObject
@property (nonatomic)NSString *GuestID;//客户id
@property (nonatomic,strong)NSString * imgUrl;//客户图片
@property (nonatomic,strong)NSString * name;//客户名称
@property (nonatomic,strong)NSString * phone;//客户手机号
@property (nonatomic,strong)NSString * weixinNo;//客户微信号
@property (nonatomic,strong)NSString * turnover;//购买总金额
@property (nonatomic,strong)NSString * lastDealTime;//上次购买时间
@property (nonatomic,strong)NSMutableArray* lastDealProducts;
@end
