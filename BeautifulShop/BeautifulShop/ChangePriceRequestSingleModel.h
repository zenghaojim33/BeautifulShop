//
//  ChangePriceRequestSingleModel.h
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelProtocol.h"

/**
 *  店主修改价格——获取产品 产品的每个属性Model
 */
@interface ChangePriceRequestSingleModel : NSObject <ModelProtocol>

@property (strong, nonatomic) NSString * attributeID;
@property (strong, nonatomic) NSString * sizeTitle;
@property (assign, nonatomic) float basePrice;
@property (assign, nonatomic) float price;

@end
