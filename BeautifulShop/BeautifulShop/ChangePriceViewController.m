//
//  ChangePriceViewController.m
//  BeautifulShop
//
//  Created by btw on 15/3/17.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ChangePriceViewController.h"
#import "ChangePriceTBCell.h"
#import "ChangePriceTBCellHeaderView.h"
#import "BWMRedButton.h"
#import "ChangePriceTBCellHeaderView.h"
#import "ChangePriceRequestModel.h"
#import "ChangePriceRequestSingleModel.h"
#import "ChangePriceAPIRequestModel.h"
#import "BWMRequestCenter.h"
#import "BWMNetVCProtocol.h"
#import "ChangePriceUpdateAPIModel.h"
#import "FormatStringFactory.h"
#import "BWMAlertViewFactory.h"

static NSString *kCellIdentity = @"ChangePriceTBCell";
static NSString *kCellHeaderViewIdentity = @"ChangePriceTBCellHeaderView";

@interface ChangePriceViewController() <UITableViewDataSource, UITableViewDelegate, BWMNetVCProtocol> {
    ChangePriceAPIRequestModel *_requestModel;
    ChangePriceTBCellHeaderView *_cellHeaderView;
    ChangePriceRequestModel *_dataModel;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *titleTextView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChangePriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self createLeftNavButton];
    
    [self createData];
    
    [super initRefreshHeaderViewWithTargetView:self.tableView beginBlock:^(MJRefreshBaseView *refreshView) {
        [self refreshData];
    }];
}

- (void)createUI {
    [self createLeftNavButton];
}

- (void)createData {
    _requestModel = [[ChangePriceAPIRequestModel alloc] init];
    _requestModel.BossID = [ShareInfo shareInstance].userModel.userID;
    _requestModel.productID = _productID;
    
    [BWMRequestCenter GET:[ChangePriceAPIRequestModel API] parameters:[_requestModel getParameterObject] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self createLeftNavButton];
        [self analysisDataWithResponseDict:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.navigationItem.rightBarButtonItem = nil;
    }];
}

- (void)refreshData {
    [BWMRequestCenter GET:[ChangePriceAPIRequestModel API] parameters:[_requestModel getParameterObject] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self createLeftNavButton];
        [self analysisDataWithResponseDict:responseObject];
        [self.refreshHeaderView endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.refreshHeaderView endRefreshing];
    }];
}

- (void)analysisDataWithResponseDict:(NSDictionary *)responseDict {
    NSLog(@"%@", responseDict);
    
    _dataModel = [[ChangePriceRequestModel alloc] initWithDictionary:responseDict[@"data"]];
    [self.tableView reloadData];
    
    [self.imageView sd_setImageWithURL:_dataModel.productImagePath placeholderImage:nil options:SDWebImageRefreshCached];
    self.titleTextView.text = _dataModel.productName;
}

- (void)createLeftNavButton {
    UIButton *navRightButton = [BWMRedButton createButtonWithFrame:CGRectMake(0, 0, 80, 30) title:@"√ 确定" target:self selector:@selector(confirmBtnClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightButton];
}

- (void)confirmBtnClicked:(UIButton *)button {
    ChangePriceUpdateAPIModel *model = [[ChangePriceUpdateAPIModel alloc] init];
    model.bossID = [ShareInfo shareInstance].userModel.userID;
    model.productID = _productID;
    
    NSMutableArray *XMLNoteArray = [[NSMutableArray alloc] init];
    __block BOOL isError;
    [_dataModel.contentArray enumerateObjectsUsingBlock:^(ChangePriceRequestSingleModel* attributeModel, NSUInteger idx, BOOL *stop) {
        if (attributeModel.price < attributeModel.basePrice) {
            *stop = YES;
            isError = YES;
            
            NSString *basePriceStr = [FormatStringFactory  priceStringWithFloat:attributeModel.basePrice];
            NSString *message = [NSString stringWithFormat:@"%@ %@ 修改的价格不能低于原价%@", _dataModel.productName,attributeModel.sizeTitle, basePriceStr];
            
            [BWMAlertViewFactory showMessage:message];
            return;
        }
        [XMLNoteArray addObject:@{@"att" : attributeModel.attributeID, @"prc" : @(attributeModel.price)}];
    }];
    model.XMLNoteArray = XMLNoteArray;
    
    if (isError) return;
    
    [BWMRequestCenter POST:[ChangePriceUpdateAPIModel API] parameters:[model getParameterObject] success:nil failure:nil];
}

#pragma mark- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataModel.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChangePriceTBCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentity];
    [cell updateWithModel:_dataModel.contentArray[indexPath.row]];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ChangePriceTBCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ChangePriceTBCellHeaderView height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    _cellHeaderView = [[[NSBundle mainBundle] loadNibNamed:kCellHeaderViewIdentity owner:nil options:nil] lastObject];
    return _cellHeaderView;
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView == scrollView) {
        if (self.tableView.contentOffset.y > 110) {
            [_cellHeaderView changeState];
        } else {
            [_cellHeaderView reverseState];
        }
    }
}

@end
