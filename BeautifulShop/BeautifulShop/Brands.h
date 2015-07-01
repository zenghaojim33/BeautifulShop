//
//  Brands.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-15.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brands : NSObject
@property(nonatomic,strong)NSString * brandName;
@property(nonatomic,strong)NSString * brandID;

+(NSMutableArray *)AllBrands;

@end
