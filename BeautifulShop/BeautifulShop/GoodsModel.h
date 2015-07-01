//
//  GoodsModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-13.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property(nonatomic,copy)NSString * GoodsID;
@property(nonatomic,strong)NSString * productName;
@property(nonatomic,strong)NSString * mainImgUrl;
@property(nonatomic,strong)NSString * size;
@property(nonatomic,strong)NSString * saleNum;
@property(nonatomic,strong)NSString * onSaleDate;
@property(nonatomic,strong)NSString * productDescription;

// 新添加的属性
@property (nonatomic, strong) NSString *nSize;
@property (nonatomic, strong) NSString *finalPrice;
@property (nonatomic, strong) NSString *marketPrice;
@property (nonatomic, assign) NSInteger storeNumber;
@property (nonatomic, readonly, strong) NSAttributedString *marketPriceAttributeString;

@property(nonatomic)BOOL isTouch;

@end
