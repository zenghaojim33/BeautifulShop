//
//  BWMViewController.h
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWMViewController : UIViewController

@property (strong, nonatomic) MJRefreshHeaderView *refreshHeaderView;
@property (strong, nonatomic) MJRefreshFooterView *refreshFooterView;

- (void)initRefreshHeaderViewWithTargetView:(UIScrollView *)targetView beginBlock:(void(^)(MJRefreshBaseView *refreshView))beginBlock;
- (void)initRefreshFooterViewWithTargetView:(UIScrollView *)targetView beginBlock:(void(^)(MJRefreshBaseView *refreshView))beginBlock;

@end
