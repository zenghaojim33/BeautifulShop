//
//  BWMSalesManagementInfoViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMSalesManagementInfoViewController.h"
#import "BWMLineChartView.h"
#import "UIColor+BWMExtension.h"
#import "BWMRequestCenter.h"
#import "BWMSalesManagementInfoSectionHeaderView.h"
#import "BWMSalesManagementInfoTableViewCell.h"
#import "UITableView+BWMTableView.h"
#import "FormatStringFactory.h"
#import "BWMMBProgressHUD.h"

static NSString * const kCellIdentity = @"BWMSalesManagementInfoTableViewCell";

@interface BWMSalesManagementInfoViewController () <UITableViewDataSource, UITableViewDelegate, BWMSalesManagementInfoViewController> {
    BWMLineChartView *_lineChartView;
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    NSUInteger _pageNum;
}

@end

@implementation BWMSalesManagementInfoViewController

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = [NSMutableArray new];
        _pageNum = 1;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self theTitle];
    [self createUI];
    [self loadData];

    [self initRefreshHeaderViewWithTargetView:_tableView beginBlock:^(MJRefreshBaseView *refreshView) {
        _pageNum = 1;
        NSDictionary *parameters = @{@"sellerid" : [ShareInfo shareInstance].userModel.userID, @"size" : @31, @"index" : @(_pageNum)};
        
        NSString *api = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=%@", [self aimString]];
        [BWMRequestCenter GET:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [_dataArray removeAllObjects];
            [self analysisDataWithResponseObject:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadErrorMsg toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }];

    }];
    
    [self initRefreshFooterViewWithTargetView:_tableView beginBlock:^(MJRefreshBaseView *refreshView) {
        _pageNum ++;
        NSDictionary *parameters = @{@"sellerid" : [ShareInfo shareInstance].userModel.userID, @"size" : @31, @"index" : @(_pageNum)};
        
        NSString *api = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=%@", [self aimString]];
        [BWMRequestCenter GET:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self analysisDataWithResponseObject:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadErrorMsg toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }];
    }];
}

- (void)analysisDataWithResponseObject:(NSDictionary *)responseObject {
    [_dataArray addObjectsFromArray:responseObject[[self apiReturnKey]]];
    [_tableView reloadData];
    [self.refreshFooterView endRefreshing];
    [self.refreshHeaderView endRefreshing];
}

- (void)createUI {
    UIColor *color = [self color];
    _lineChartView = [[BWMLineChartView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 155) color:color hasFloat:[self hasFloat] delegate:nil];
    [self.view addSubview:_lineChartView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 175)];
    headerView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:_lineChartView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentity bundle:nil] forCellReuseIdentifier:kCellIdentity];
    _tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
}

- (void)loadData {
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"统计中..."];
    
    NSDictionary *parameters = @{@"sellerid" : [ShareInfo shareInstance].userModel.userID, @"size" : @31, @"index" : @1};
    
    NSString *api = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=%@", [self aimString]];
    [BWMRequestCenter GET:api parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self loadAPIWithResponseObject:responseObject returnKey:[self apiReturnKey] title:[self theTitle] isFloat:[self hasFloat]];
        [BWMMBProgressHUD hideHUD:HUD hideAfter:kBWMMBProgressHUDHideTimeInterval];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadErrorMsg hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
}

- (void)loadAPIWithResponseObject:(id)responseObject
                        returnKey:(NSString *)returnKey
                            title:(NSString *)title
                          isFloat:(BOOL)isFloat {
    
    NSArray *dailyOrdersArray = responseObject[returnKey];
    
    NSMutableArray *XVals = [NSMutableArray new];
    NSMutableArray *YVals = [NSMutableArray new];
    [dailyOrdersArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSDictionary *tempDict, NSUInteger idx, BOOL *stop) {
        NSString *date = [tempDict[@"date"] substringFromIndex:5];
        [XVals addObject:date];
        [YVals addObject:tempDict[@"sum"]];
        
        [_dataArray addObject:@{@"date" : tempDict[@"date"], @"sum" : tempDict[@"sum"]}];
    }];
    
    _dataArray = [[NSMutableArray alloc] initWithArray:dailyOrdersArray];
    
    NSString *theTitle = nil;
    if (isFloat) {
        theTitle = [NSString stringWithFormat:@"%@         今天：%.2f      昨天：%.2f", title, [YVals[YVals.count-1] floatValue], [YVals[YVals.count-2] floatValue]];
    } else {
        theTitle = [NSString stringWithFormat:@"%@         今天：%d      昨天：%d", title, [YVals[YVals.count-1] intValue], [YVals[YVals.count-2] intValue]];
    }
    [_lineChartView updateWithTitle:theTitle XVals:XVals YVals:YVals];
    
    [_tableView reloadData];
}

#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BWMSalesManagementInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentity];
    NSDictionary *dataDict = _dataArray[indexPath.row];
    if ([self hasFloat]) {
        NSString *priceString = [FormatStringFactory priceStringWithFloat:[dataDict[@"sum"] floatValue]];
        [cell updateWithLeftLabelText:dataDict[@"date"] rightLabelText:priceString];
    } else {
        [cell updateWithLeftLabelText:dataDict[@"date"] rightLabelText:[dataDict[@"sum"] stringValue]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [BWMSalesManagementInfoSectionHeaderView height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BWMSalesManagementInfoSectionHeaderView *headerView = [BWMSalesManagementInfoSectionHeaderView create];
    headerView.rightLabel.text = [self sectionHeaderRightText];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

+ (BWMSalesManagementInfoViewController<BWMSalesManagementInfoViewController> *)createWithbInfoType:(BWMSalesManagementInfoType)infoType {
    NSString *className = nil;
    switch (infoType) {
        case BWMSalesManagementInfoTypeDailyOrder:
            className = @"BWMDailyOrderViewController";
            break;
            
        case BWMSalesManagementInfoTypeOrderPrice:
            className = @"BWMDailyTurnoverViewController";
            break;
        case BWMSalesManagementInfoTypeVisiterCount:
            className = @"BWMDailyVisitorsViewController";
    }
    
    BWMSalesManagementInfoViewController<BWMSalesManagementInfoViewController> *vc = [[NSClassFromString(className) alloc] init];
    return vc;
}

#pragma mark- BWMSalesManagementInfoViewController Protocol
- (UIColor *)color {
    return nil;
}

- (BOOL)hasFloat {
    return NO;
}

- (NSString *)theTitle {
    return nil;
}

- (NSString *)aimString {
    return nil;
}

- (NSString *)apiReturnKey {
    return nil;
}

- (NSString *)sectionHeaderRightText {
    return nil;
}

@end
