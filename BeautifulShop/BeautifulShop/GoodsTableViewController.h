//
//  GoodsTableViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-14.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsTableViewController;

@protocol GoodsTableViewControllerDelegate <NSObject>

- (void)goodsTableViewControllerDidGoodsShelvesEnd:(GoodsTableViewController *)viewController;

@end

@interface GoodsTableViewController : UIViewController
@property (weak, nonatomic) id<GoodsTableViewControllerDelegate> delegate;
@property(nonatomic,strong)NSMutableArray * myDataArray;
@property(nonatomic,strong)NSString * url;
@property (nonatomic,strong)NSString * BrandStr;
@property (nonatomic,strong)NSString * TypeStr;
@property (nonatomic,strong)NSString * scarchStr;


@end
