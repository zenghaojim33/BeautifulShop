//
//  BWMMyPurseViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyPurseViewController.h"
#import "BWMMyPruseTableHeaderView.h"
#import "BWMMyPruseTableViewCell.h"
#import "BWMMyPruseTableSectionHeaderView.h"
#import "BWMTakeCashTableViewController.h"
#import "UITableView+BWMTableView.h"
#import "NSBundle+BWMBundle.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "BWMRequestCenter.h"
#import "BWMAlertViewFactory.h"
#import "BWMMBProgressHUD.h"
#import "BWMInputBankAccountViewController.h"
#import "BWMMyInComeSimplePreviewModel.h"
#import "BWMMyDealInfoModel.h"
#import "ChangeInfoViewController.h"

static NSString * const kCellIdentity = @"BWMMyPruseTableViewCell";

@interface BWMMyPurseViewController ()
<
    UITableViewDataSource, UITableViewDelegate,
    BWMMyPruseTableHeaderViewDelegate,
    BWMMyPruseTableSectionHeaderViewDelegate
>
{
    BWMMyPruseTableSectionHeaderView *_sectionHeaderView;
    BWMMyPruseTableHeaderView<BWMMyPruseTableHeaderView> *_headerView;
    CGPoint _tipsLabelPoint;
    NSUInteger _currentPageIndex;
    BWMMyDealInfoType _dealInfoType;
    NSMutableArray *_dataArray; // 表格数据集
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BWMMyPurseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的收入";
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    _tipsLabelPoint = CGPointMake(self.tableView.center.x, 460);
    
    _dataArray = [[NSMutableArray alloc] init];
    _currentPageIndex = 1;
    _dealInfoType = BWMMyDealInfoTypeIncome;
    
    _headerView = [BWMMyPruseTableHeaderView createView];
    _headerView.delegate = self;
    
    [_tableView bwm_registerNibName:kCellIdentity forCellReuseIdentifier:kCellIdentity];
    _tableView.tableHeaderView = _headerView;
    [_tableView bwm_hideSeparatorLines];
    
    
    [self initRefreshHeaderViewWithTargetView:self.tableView beginBlock:^(MJRefreshBaseView *refreshView) {
        [_sectionHeaderView scrollToFirstElement];
        _currentPageIndex = 1;
        _dealInfoType = BWMMyDealInfoTypeIncome;
        [self requestInitData];
    }];
    
    [self initRefreshFooterViewWithTargetView:self.tableView beginBlock:^(MJRefreshBaseView *refreshView) {
        [self loadMoreData];
    }];
}

- (void)loadMoreData {
    _currentPageIndex ++;
    NSDictionary *getParameters = @{@"userid" : [ShareInfo shareInstance].userModel.userID, @"type" : @(_dealInfoType), @"pagesize" : @20, @"pageindex" : @(_currentPageIndex)};

    [BWMRequestCenter GET:@"http://server.mallteem.com/json/index.ashx?aim=profitList" parameters:getParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_dataArray addObjectsFromArray:[BWMMyDealInfoModel arrayWithArray:responseObject]];
        [_tableView reloadData];
        [self.refreshFooterView endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshFooterView endRefreshing];
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDNoMoreDataMsg toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestInitData];
    [_sectionHeaderView scrollToFirstElement];
}

- (void)requestInitData {
    
    _currentPageIndex = 1;
    _dealInfoType = BWMMyDealInfoTypeIncome;
    
    [BWMRequestCenter
     GET:@"http://server.mallteem.com/json/index.ashx?aim=myprofit"
     parameters:@{@"userid" : [ShareInfo shareInstance].userModel.userID,  @"type": @([ShareInfo shareInstance].userModel.userType)}
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
         BWMMyInComeSimplePreviewModel *model = [[BWMMyInComeSimplePreviewModel alloc] initWithDictionary:responseObject];
         [_headerView updateWithModel:model];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [BWMMBProgressHUD showTitle:@"获取收入信息失败！"
                              toView:self.navigationController.view
                           hideAfter:kBWMMBProgressHUDHideTimeInterval
                             msgType:BWMMBProgressHUDMsgTypeError];
     }];
    
    NSDictionary *getParameters = @{@"userid" : [ShareInfo shareInstance].userModel.userID, @"type" : @1, @"pagesize" : @20, @"pageindex" : @1};
    [BWMRequestCenter
     GET:@"http://server.mallteem.com/json/index.ashx?aim=profitList"
     parameters:getParameters
     success:^(AFHTTPRequestOperation *operation, NSArray* responseObject) {
         NSLog(@"%@", responseObject);
         if (responseObject.count == 0) {
             [self.tableView bwm_addTipsViewWithTitle:@"暂无收入，再加吧劲！" height:120.0f];
         } else {
             [_tableView bwm_removeTipsView];
         }
         [_dataArray removeAllObjects];
         [_dataArray addObjectsFromArray:[BWMMyDealInfoModel arrayWithArray:responseObject]];
         [_tableView reloadData];
         [_tableView scrollRectToVisible:CGRectZero animated:YES];
         [self.refreshFooterView endRefreshing];
         [self.refreshHeaderView endRefreshing];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.tableView bwm_addTipsViewWithTitle:@"暂无收入，再加吧劲！" height:120.0f];
         [BWMMBProgressHUD showTitle:@"获取收入信息失败！"
                              toView:self.navigationController.view
                           hideAfter:kBWMMBProgressHUDHideTimeInterval
                             msgType:BWMMBProgressHUDMsgTypeError];
         [self.refreshFooterView endRefreshing];
         [self.refreshHeaderView endRefreshing];
     }];
}

#pragma mark- BWMMyPruseTableHeaderViewDelegate
- (void)headerView:(BWMMyPruseTableHeaderView<BWMMyPruseTableHeaderView> *)headerView inputAccountBtnClicked:(UIButton *)inputAccountBtn {
    BWMInputBankAccountViewController *vc = [BWMInputBankAccountViewController viewController];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerView:(BWMMyPruseTableHeaderView<BWMMyPruseTableHeaderView> *)headerView takeCashBtnClicked:(UIButton *)takeCashBtn {
    BWMTakeCashTableViewController *VC = [UIStoryboard initVCOnMainStoryboardWithID:@"BWMTakeCashTableViewController"];
    [self.navigationController pushViewController:VC animated:YES];
    
    NSLog(@"%s", __FUNCTION__ );
}

#pragma mark- BWMMyPruseTableSectionHeaderViewDelegate
- (void)sectionHeaderView:(BWMMyPruseTableSectionHeaderView *)sectionHeaderView buttonClicked:(UIButton *)button tag:(NSInteger)tag {
    NSString *tipsString = nil;
    switch (tag) {
        case 0: {
            _dealInfoType = BWMMyDealInfoTypeIncome;
            tipsString = @"暂无收入，再加吧劲！";
        }
            break;
            
        case 1: {
            _dealInfoType = BWMMyDealInfoTypeTakeOut;
            tipsString = @"暂无提现纪录...";
        }
            break;
        case 2: {
            _dealInfoType = BWMMyDealInfoTypeAll;
            tipsString = @"暂无收入和提现纪录...";
        }
            break;
    }
    _currentPageIndex = 1;
    
    NSDictionary *getParameters = @{@"userid" : [ShareInfo shareInstance].userModel.userID, @"type" : @(_dealInfoType), @"pagesize" : @20, @"pageindex" : @(_currentPageIndex)};
    [BWMRequestCenter GET:@"http://server.mallteem.com/json/index.ashx?aim=profitList" parameters:getParameters success:^(AFHTTPRequestOperation *operation, NSArray* responseObject) {
        if (responseObject.count == 0) {
            [self.tableView bwm_addTipsViewWithTitle:tipsString height:120.0f];
        } else {
            [_tableView bwm_removeTipsView];
        }
        
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:[BWMMyDealInfoModel arrayWithArray:responseObject]];
        [_tableView reloadData];
        [_tableView scrollRectToVisible:CGRectZero animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadErrorMsg
                             toView:self.navigationController.view
                          hideAfter:kBWMMBProgressHUDHideTimeInterval];
        [self.tableView bwm_addTipsViewWithTitle:tipsString height:120.0f];
    }];
}

#pragma mark- UITableViewDataSrouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BWMMyPruseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentity];
    BWMMyDealInfoModel *model = _dataArray[indexPath.row];
    [cell updateWithModel:model];
    return cell;
}

#pragma mark- UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_sectionHeaderView == nil) {
        _sectionHeaderView =  [[BWMMyPruseTableSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, BWMMyPruseTableSectionHeaderView.height)];
        _sectionHeaderView.delegate = self;
    }
    
    return _sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [BWMMyPruseTableSectionHeaderView height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BWMMyPruseTableViewCell height];
}

@end
