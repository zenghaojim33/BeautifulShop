//
//  SalesManagementViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "SalesManagementViewController.h"
#import "BWMSalesManagementInfoViewController.h"
#import "BWMLineChartView.h"
#import "UIColor+BWMExtension.h"
#import "BWMRequestCenter.h"
#import "BWMMBProgressHUD.h"

@interface SalesManagementViewController () <BWMLineChartViewDelegate> {
    NSMutableArray *_lineChartViewArray;
    UIScrollView *_scrollView;
}
@end

@implementation SalesManagementViewController

- (instancetype)init {
    if (self = [super init]) {
        _lineChartViewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"销售管理";
    
    [self createUI];
    [self loadData];
    [self initRefreshHeaderViewWithTargetView:_scrollView beginBlock:^(MJRefreshBaseView *refreshView) {
        [self loadData];
    }];
}

- (void)createUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_scrollView];
    
    NSArray *colors = @[
                            [UIColor colorWithHex:@"#B04B87" alpha:1.0f],
                            [UIColor colorWithHex:@"#566892" alpha:1.0f],
                            [UIColor colorWithHex:@"#E95A6F" alpha:1.0f]
                        ];
    for (int i = 0; i<colors.count; i++) {
        CGRect rect = CGRectMake(0, 165*i+10, self.view.frame.size.width, 155);
        BOOL hasFloat = NO;
        if (i == 1) hasFloat = YES;
        BWMLineChartView *lineChartView = [[BWMLineChartView alloc] initWithFrame:rect
                                                                            color:colors[i]
                                                                         hasFloat:hasFloat
                                                                         delegate:self];
        [_lineChartViewArray addObject:lineChartView];
        lineChartView.tag = i;
        [_scrollView addSubview:lineChartView];
    }
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 570.0f);
}

- (void)loadData {
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:kBWMMBProgressHUDLoadingMsg];
    
    NSDictionary *parameters = @{@"sellerid" : [ShareInfo shareInstance].userModel.userID, @"size" : @31, @"index" : @1};
    
    [BWMRequestCenter GET:@"http://server.mallteem.com/json/index.ashx?aim=getordercount" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadAPIWithResponseObject:responseObject returnKey:@"dailyOrders" index:0 title:@"每日订单" isFloat:NO];
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadSuccessMsg hideAfter:kBWMMBProgressHUDHideTimeInterval];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadErrorMsg hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
    
    [BWMRequestCenter GET:@"http://server.mallteem.com/json/index.ashx?aim=getorderallpric" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadAPIWithResponseObject:responseObject returnKey:@"dailyTurnover" index:1 title:@"成交金额" isFloat:YES];
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadSuccessMsg hideAfter:kBWMMBProgressHUDHideTimeInterval];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadErrorMsg hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
    
    [BWMRequestCenter GET:@"http://server.mallteem.com/json/index.ashx?aim=getvisitercount" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadAPIWithResponseObject:responseObject returnKey:@"dailyVisitors" index:2 title:@"每日访客" isFloat:NO];
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadSuccessMsg hideAfter:kBWMMBProgressHUDHideTimeInterval];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadErrorMsg hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
    
    [self.refreshHeaderView endRefreshing];
}

- (void)loadAPIWithResponseObject:(id)responseObject
             returnKey:(NSString *)returnKey
                 index:(NSInteger)index
                            title:(NSString *)title
                          isFloat:(BOOL)isFloat {
    
    NSArray *dailyOrdersArray = responseObject[returnKey];
    
    NSMutableArray *XVals = [NSMutableArray new];
    NSMutableArray *YVals = [NSMutableArray new];
    [dailyOrdersArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *tempDict, NSUInteger idx, BOOL *stop) {
        NSString *date = [tempDict[@"date"] substringFromIndex:5];
        [XVals addObject:date];
        [YVals addObject:tempDict[@"sum"]];
    }];
    
    BWMLineChartView *lineChartView = _lineChartViewArray[index];
    NSString *theTitle = nil;
    if (isFloat) {
        theTitle = [NSString stringWithFormat:@"%@         今天：%.2f      昨天：%.2f", title, [YVals[YVals.count-1] floatValue], [YVals[YVals.count-2] floatValue]];
    } else {
        theTitle = [NSString stringWithFormat:@"%@         今天：%d      昨天：%d", title, [YVals[YVals.count-1] intValue], [YVals[YVals.count-2] intValue]];
    }
    [lineChartView updateWithTitle:theTitle XVals:XVals YVals:YVals];
}

#pragma mark- BWMLineChartViewDelegate
- (void)lineChartViewSelected:(BWMLineChartView *)lineChartView {
    BWMSalesManagementInfoViewController<BWMSalesManagementInfoViewController> *vc = [BWMSalesManagementInfoViewController createWithbInfoType:lineChartView.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
