//
//  BWMProductModel.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BWMProductModelOrderBy) {
    BWMProductModelOrderByUseTime,
    BWMProductModelOrderBySellNumber
};

typedef NS_ENUM(NSInteger, BWMProductModelType) {
    BWMProductModelTypeNormal = 0,
    BWMProductModelTypeWelfare,
    BWMProductModelTypeSpecialSelling
};

/** 产品Model */
@interface BWMProductModel : NSObject

/** 产品ID */
@property (strong, nonatomic) NSString *productID;

/** 产品图片 */
@property (strong, nonatomic) NSURL *imageURL;

/** 产品名称 */
@property (strong, nonatomic) NSString *productName;

/** 规格 */
@property (strong, nonatomic) NSString *size;

/** 库存数量 */
@property (assign, nonatomic) NSInteger storeCount;

/** 美店价格 */
@property (assign, nonatomic) double weiPrice;

/** 市场价格 */
@property (assign, nonatomic) double marketPrice;

/** 销售数 */
@property (assign, nonatomic) NSInteger saleNum;

/** 开始销售的时间 */
@property (strong, nonatomic) NSString *onSaleDate;

/** 详细描述(用于分享) */
@property (strong, nonatomic) NSString *desc;

/** 规格、库存数量、美店价格、市场价格组成的字符串 */
@property (strong, nonatomic) NSString *sizeDesc;

// 附加属性
@property (nonatomic, strong, readonly) NSString *storeCountString;
@property (nonatomic, strong, readonly) NSString *weiPriceString;
@property (nonatomic, strong, readonly) NSAttributedString *marketPriceAttributeString;
@property (nonatomic, strong, readonly) NSDate *realOnSaleDate;

+ (NSArray *)modelsWithDictArray:(NSArray *)dictArray;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (NSMutableArray *)orderBy:(BWMProductModelOrderBy)orderBy models:(NSMutableArray *)models;

// userid=供应商id&seller=当前登录的用户id&use=0/1(0没上架的，1上架的，留空全部)&brand=品牌&category=类别&key=名称关键字&size=每页显示条数&index=页码数&orderBy=排序
// 上架时间：usetime desc 销量：sellnumber desc
+ (NSString *)APIWithPutaway:(BOOL)putaway
                   brand:(NSString *)brand
                category:(NSString *)category
                     key:(NSString *)key
                    size:(NSInteger)size
                   index:(NSInteger)index
                 orderBy:(BWMProductModelOrderBy)orderBy;

+ (NSString *)APIWithPutaway:(BOOL)putaway
                       brand:(NSString *)brand
                    category:(NSString *)category
                         key:(NSString *)key
                        size:(NSInteger)size
                       index:(NSInteger)index
                     orderBy:(BWMProductModelOrderBy)orderBy
                        type:(BWMProductModelType)type;

@end
