//
//  BWMViewController.m
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMViewController.h"

@interface BWMViewController ()

@end

@implementation BWMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)initRefreshHeaderViewWithTargetView:(UIScrollView *)targetView beginBlock:(void(^)(MJRefreshBaseView *refreshView))beginBlock {
    _refreshHeaderView = [MJRefreshHeaderView header];
    [_refreshHeaderView setBeginRefreshingBlock:beginBlock];
    _refreshHeaderView.scrollView = targetView;
}

- (void)initRefreshFooterViewWithTargetView:(UIScrollView *)targetView beginBlock:(void(^)(MJRefreshBaseView *refreshView))beginBlock {
    _refreshFooterView = [MJRefreshFooterView footer];
    [_refreshFooterView setBeginRefreshingBlock:beginBlock];
    _refreshFooterView.scrollView = targetView;
}


- (void)dealloc {
    if (_refreshHeaderView) {
        [_refreshHeaderView free];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView free];
    }
}

@end
