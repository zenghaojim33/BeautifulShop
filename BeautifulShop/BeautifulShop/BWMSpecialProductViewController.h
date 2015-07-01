//
//  BWMSpecialProductViewController.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/29.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMViewController.h"
#import "BWMProductModel.h"

/** 品牌特卖&店主福利的抽象父类 */
@interface BWMSpecialProductViewController : BWMViewController

@property (nonatomic, strong) NSString *BrandStr;
@property (nonatomic, strong) NSString *TypeStr;
@property (nonatomic, strong) NSString *scarchStr;


// Abstract Method...
- (BWMProductModelType)APIRequestType;

@end
