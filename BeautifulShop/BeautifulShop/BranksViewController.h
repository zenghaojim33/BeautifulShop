//
//  BranksViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-15.
//  Copyright (c) 2014年 jenk. All rights reserved.
//
#import "ViewController.h"

@protocol BrandDelegate <NSObject>

-(void)setBrandName:(NSString*)brandName;

@end

@interface BranksViewController : UIViewController

@property(nonatomic,strong)id<BrandDelegate>delegate;

+ (instancetype)viewController;

@end
