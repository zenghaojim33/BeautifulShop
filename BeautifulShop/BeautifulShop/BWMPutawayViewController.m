//
//  BWMPutawayViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/17.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMPutawayViewController.h"
#import "BWMProductCell.h"
#import "BWMProductModel.h"
#import "BWMRequestCenter.h"
#import "BWMMBProgressHUD.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "BWMTextViewBox.h"
#import "GoodsInfoViewController.h"
#import "GoodsShelvesViewController.h"
#import "BWMProductPutawayPostModel.h"
#import "BWMRedButton.h"
#import "BWMAlertViewFactory.h"
#import "BWMTipsView.h"
#import "UIView+BWMExtension.h"

static NSString * const kCellIdentity = @"BWMProductCell";

@interface BWMPutawayViewController ()
<
    GoodsShelvesDelegate,
    UITextFieldDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    BWMProductCellDelegate
>
{
    BWMRedButton *_putawayButton;
    NSMutableArray *_dataArray;
    NSMutableArray *_selectedArray;
    NSInteger _pageIndex;
    BWMProductModelOrderBy _orderBy;
}

@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UIButton *closeSearchBtn;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *searchBarContainer;

@end

@implementation BWMPutawayViewController

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 1;
        _dataArray = [NSMutableArray new];
        _selectedArray = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_createUI];
    
    [self p_loadDataIsMove:NO];
    
    [self initRefreshFooterViewWithTargetView:_tableView beginBlock:^(MJRefreshBaseView *refreshView) {
        _pageIndex ++;
        [self p_loadDataIsMove:NO];
    }];
    
    [self initRefreshHeaderViewWithTargetView:_tableView beginBlock:^(MJRefreshBaseView *refreshView) {
        [self p_reloadAttribute];
        [self p_loadDataIsMove:YES];
    }];
}

- (void)p_reloadAttribute {
    _pageIndex = 1;
    _BrandStr = nil;
    _scarchStr = nil;
    _TypeStr = nil;
    _searchTF.text = nil;
    _closeSearchBtn.hidden = YES;
}

- (void)p_createUI {
    self.title = @"货品上架";
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentity bundle:nil] forCellReuseIdentifier:kCellIdentity];
    [_searchBarContainer drawingDefaultStyleShadow];
    _closeSearchBtn.hidden = YES;
    
    _putawayButton = [BWMRedButton createButtonWithFrame:CGRectMake(0, 0, 100, 30) title:@"上架货品" target:self selector:@selector(p_putawayBtnClicked:)];
    [_putawayButton drawingButtonOfTick];
    [_putawayButton setUnactivity];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_putawayButton];
}

- (void)p_putawayBtnClicked:(UIButton *)button {
    BWMProductPutawayPostModel *postModel = [BWMProductPutawayPostModel modelWithType:BWMProductPutawayPostModelTypeAdd];
    [_selectedArray enumerateObjectsUsingBlock:^(BWMProductModel *productModel, NSUInteger idx, BOOL *stop) {
        [postModel addProductID:productModel.productID];
    }];
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.navigationController.view title:@"请求上架.."];
    [BWMRequestCenter POST:[BWMProductPutawayPostModel API] parameters:[postModel postDictionary] success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [BWMMBProgressHUD hideHUD:HUD hideAfter:0];
        if([responseObject[@"status"] boolValue]) {
            _pageIndex = 1;
            [self p_loadDataIsMove:YES];
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString message:@"上架成功" type:BWMAlertViewTypeSuccess targetVC:self callBlock:nil];
            if ([_delegate respondsToSelector:@selector(putawayViewControllerDidGoodsShelvesEnd:)]) {
                [_delegate putawayViewControllerDidGoodsShelvesEnd:self];
            }
        } else {
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString message:responseObject[@"error"] type:BWMAlertViewTypeError targetVC:self callBlock:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD hideAfter:0];
        [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString message:@"服务器访问失败，上架失败！" type:BWMAlertViewTypeError targetVC:self callBlock:nil];
    }];
}

- (void)p_loadDataIsMove:(BOOL)isMove {
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:kBWMMBProgressHUDLoadingMsg];
    NSString *API = [BWMProductModel APIWithPutaway:NO
                                              brand:_BrandStr
                                           category:_TypeStr
                                                key:_scarchStr
                                               size:10
                                              index:_pageIndex
                                            orderBy:_orderBy];
    [BWMRequestCenter GET:API parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (isMove) {
            [_dataArray removeAllObjects];
            [_selectedArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:[BWMProductModel modelsWithDictArray:responseObject[@"productList"]]];
        [HUD hide:YES];
        [_tableView reloadData];
        [self.refreshFooterView endRefreshing];
        [self.refreshHeaderView endRefreshing];
        [self p_changePutawayButton];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadErrorMsg hideAfter:kBWMMBProgressHUDHideTimeInterval];
        [self.refreshFooterView endRefreshing];
        [self.refreshHeaderView endRefreshing];
    }];
}

- (void)p_changePutawayButton {
    if (_selectedArray.count > 0) {
        NSString *btnTitle = [NSString stringWithFormat:@"上架货品(%lu)", (unsigned long)_selectedArray.count];
        [_putawayButton setActivity];
        [_putawayButton setTitle:btnTitle forState:UIControlStateNormal];
    } else {
        [_putawayButton setTitle:@"上架货品" forState:UIControlStateNormal];
        [_putawayButton setUnactivity];
    }
}

- (IBAction)p_closeBtnClicked:(UIButton *)sender {
    [self p_reloadAttribute];
    [self p_loadDataIsMove:YES];
}


#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BWMProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentity];
    BWMProductModel *model = _dataArray[indexPath.row];
    [cell updateWithModel:model];
    [cell selectedAddBtn:[_selectedArray containsObject:model]];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BWMProductCell height];
}

#pragma mark- BWMProductCellDelegate
- (void)productCell:(BWMProductCell *)cell addBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model {
    if (addBtn.selected) {
        [_selectedArray addObject:model];
    } else {
        [_selectedArray removeObject:model];
    }
    
    [self p_changePutawayButton];
}

- (void)productCell:(BWMProductCell *)cell requestLinkBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model {
    [BWMMBProgressHUD showTitle:@"请先上架再复制链接" toView:self.view hideAfter:1.8 msgType:BWMMBProgressHUDMsgTypeInfo];
}

- (void)productCell:(BWMProductCell *)cell shareBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model {
    [BWMMBProgressHUD showTitle:@"请先上架再分享该货品" toView:self.view hideAfter:1.8 msgType:BWMMBProgressHUDMsgTypeInfo];
}

- (void)productCell:(BWMProductCell *)cell infoBgViewTaped:(UIView *)infoBgView model:(BWMProductModel *)model {
    GoodsInfoViewController * vc = [UIStoryboard initVCOnMainStoryboardWithID:@"GoodsInfoViewController"];
    vc.url = [NSString stringWithFormat:@"http://web.mallteem.com/_ProductDetail.aspx?id=%@&ShopId=%@",model.productID, [ShareInfo shareInstance].userModel.userID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- GoodsShelvesDelegate
- (void)goodsShelvesViewController:(GoodsShelvesViewController *)viewController searchDidSuccessful:(NSArray *)resultArray keyword:(NSString *)keyword {
    _searchTF.text = keyword;
    if (_BrandStr.length>0 || _TypeStr.length>0 || keyword.length>0) {
        _closeSearchBtn.hidden = NO;
    } else {
        _closeSearchBtn.hidden = YES;
    }
    
    _dataArray = [NSMutableArray arrayWithArray:resultArray];
    [_selectedArray removeAllObjects];
    [self p_changePutawayButton];
    [_tableView reloadData];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    GoodsShelvesViewController *vc = [GoodsShelvesViewController viewControllerWithSell:NO delegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

@end
