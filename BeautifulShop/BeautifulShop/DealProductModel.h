//
//  DealProductModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-11.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DealProductModel : NSObject
@property(nonatomic)int productId;//货品ID,自增数字
@property(nonatomic,strong)NSString * productName;//货品名称
@property(nonatomic,strong)NSString * productImg;//首图链接
@property(nonatomic)int color;//物品颜色
@property(nonatomic,strong)NSString * size;//物品大小
@end
