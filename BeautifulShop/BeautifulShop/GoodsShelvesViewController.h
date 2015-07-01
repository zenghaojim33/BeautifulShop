//
//  GoodsShelvesViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//
@protocol GoodsShelvesDelegate;
#import <UIKit/UIKit.h>
#import "BWMProductModel.h"

@interface GoodsShelvesViewController : UIViewController

@property(nonatomic,strong)id<GoodsShelvesDelegate>delegate;
@property (assign, nonatomic, getter=isSell) BOOL sell; // 是否已经上架销售的
@property (assign, nonatomic) BWMProductModelType type;

+ (instancetype)viewControllerWithSell:(BOOL)isSell delegate:(id<GoodsShelvesDelegate>)delegate;
+ (instancetype)viewControllerWithDelegate:(id<GoodsShelvesDelegate>)delegate type:(BWMProductModelType)type;

@end
@protocol GoodsShelvesDelegate <NSObject>

@optional
-(void)SetArray:(NSMutableArray*)array;
- (void)goodsShelvesViewController:(GoodsShelvesViewController *)viewController searchDidSuccessful:(NSArray *)resultArray keyword:(NSString *)keyword;

@end