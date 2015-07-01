//
//  BWMSpecialProductViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/29.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMSpecialProductViewController.h"
#import "BWMProductCell.h"
#import "BWMRequestCenter.h"
#import "BWMMBProgressHUD.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "BWMTextViewBox.h"
#import "GoodsInfoViewController.h"
#import "GoodsShelvesViewController.h"
#import "BWMProductPutawayPostModel.h"
#import "BWMAlertViewFactory.h"
#import "BWMTipsView.h"
#import "UIView+BWMExtension.h"
#import "BWMUmengManager.h"

static NSString * const kCellIdentity = @"BWMSpecialProductCell";

@interface BWMSpecialProductViewController ()
<
    GoodsShelvesDelegate,
    UITextFieldDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    BWMProductCellDelegate,
    UMSocialUIDelegate
>
{
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

@implementation BWMSpecialProductViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:@"BWMSpecialProductViewController" bundle:nil]) {
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
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentity bundle:nil] forCellReuseIdentifier:kCellIdentity];
    [_searchBarContainer drawingDefaultStyleShadow];
    _closeSearchBtn.hidden = YES;
}

- (void)p_loadDataIsMove:(BOOL)isMove {
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:kBWMMBProgressHUDLoadingMsg];
    NSString *API = [BWMProductModel APIWithPutaway:NO
                                              brand:_BrandStr
                                           category:_TypeStr
                                                key:_scarchStr
                                               size:10
                                              index:_pageIndex
                                            orderBy:_orderBy
                                               type:[self APIRequestType]];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:kBWMMBProgressHUDLoadErrorMsg hideAfter:kBWMMBProgressHUDHideTimeInterval];
        [self.refreshFooterView endRefreshing];
        [self.refreshHeaderView endRefreshing];
    }];
}

- (BWMProductModelType)APIRequestType {
    return BWMProductModelTypeNormal;
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

- (void)productCell:(BWMProductCell *)cell requestLinkBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model {
    NSString * CopyStr = [NSString stringWithFormat:myProduct,model.productID,[ShareInfo shareInstance].userModel.userID];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = CopyStr;
    [BWMMBProgressHUD showTitle:@"复制成功"
                         toView:self.view
                      hideAfter:kBWMMBProgressHUDHideTimeInterval];
}

- (void)productCell:(BWMProductCell *)cell shareBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model {
    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
    if (isInstalledWeixin) {
        [BWMUmengManager settingWXShareTypeWeb];
        [BWMUmengManager sharingWithController:self
                                    shareTitle:model.productName
                                   shareDetail:model.desc
                                    shareImage:model.imageURL
                                     shareLink:[NSString stringWithFormat:myProduct,model.productID,[ShareInfo shareInstance].userModel.userID]
                                      delegate:self];
    } else {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}

- (void)productCell:(BWMProductCell *)cell infoBgViewTaped:(UIView *)infoBgView model:(BWMProductModel *)model {
    GoodsInfoViewController * vc = [UIStoryboard initVCOnMainStoryboardWithID:@"GoodsInfoViewController"];
    vc.url = [NSString stringWithFormat:@"http://web.mallteem.com/ProductDetail.aspx?id=%@&ShopId=%@",model.productID, [ShareInfo shareInstance].userModel.userID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- UMSocialUIDelegate
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if(response.responseCode == UMSResponseCodeSuccess) {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
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
    [_tableView reloadData];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    GoodsShelvesViewController *vc = [GoodsShelvesViewController viewControllerWithDelegate:self type:[self APIRequestType]];
    [self.navigationController pushViewController:vc animated:YES];
    return NO;
}

@end