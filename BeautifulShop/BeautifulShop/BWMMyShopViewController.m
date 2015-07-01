//
//  BWMMyShopViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMMyShopViewController.h"
#import "BWMProductCell.h"
#import "BWMProductModel.h"
#import "BWMProductSectionView.h"
#import "BWMMyShopHeaderView.h"
#import "BWMRequestCenter.h"
#import "BWMMBProgressHUD.h"
#import "BWMUmengManager.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "ChangeInfoViewController.h"
#import "BWMTextViewBox.h"
#import "GoodsInfoViewController.h"
#import "GoodsShelvesViewController.h"
#import "BWMProductPutawayPostModel.h"
#import "BWMRedButton.h"
#import "BWMAlertViewFactory.h"
#import "BWMTipsView.h"
#import "BWMPutawayViewController.h"

static NSString * const kCellIdentity = @"BWMProductCell";

@interface BWMMyShopViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    BWMProductCellDelegate,
    BWMProductSectionViewDelegate,
    BWMMyShopHeaderViewDelegate,
    UMSocialUIDelegate,
    BWMTextViewBoxDelegate,
    GoodsShelvesDelegate,
    BWMTipsViewDelegate,
    BWMPutawayViewControllerDelegate,
    ChangeInfoViewControllerDelegate
>
{
    BWMProductSectionView *_sectionView;
    BWMMyShopHeaderView *_headerView;
    BWMRedButton *_putawayButton;
    BWMTipsView *_tipsView;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_selectedArray;
    
    NSInteger _pageIndex;
    BWMProductModelOrderBy _orderBy;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BWMMyShopViewController

- (instancetype)init {
    if (self = [super init]) {
        _pageIndex = 1;
        _orderBy = BWMProductModelOrderByUseTime;
        _dataArray = [[NSMutableArray alloc] init];
        _selectedArray = [[NSMutableArray alloc] init];
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
    _tipsView.title = kTipsViewNoProductTips;
    _headerView.searchText = nil;
    [_headerView hideCloseBtn];
}

- (void)p_loadDataIsMove:(BOOL)isMove {
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:kBWMMBProgressHUDLoadingMsg];
    NSString *API = [BWMProductModel APIWithPutaway:YES
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

- (void)p_createUI {
    self.title = @"我的美店";
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentity bundle:nil] forCellReuseIdentifier:kCellIdentity];
    _headerView = [BWMMyShopHeaderView headerViewWithDelegate:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tableView.tableHeaderView = _headerView;
    });
    
    _tipsView = [BWMTipsView putawayTipsViewWithDelegate:self];
    
    _putawayButton = [BWMRedButton createButtonWithFrame:CGRectMake(0, 0, 100, 30) title:@"下架商品" target:self selector:@selector(p_putawayBtnClicked:)];
    [_putawayButton drawingButtonOfTick];
    [_putawayButton setUnactivity];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_putawayButton];
}

- (void)p_putawayBtnClicked:(UIButton *)button {
    BWMProductPutawayPostModel *postModel = [BWMProductPutawayPostModel modelWithType:BWMProductPutawayPostModelTypeDel];
    [_selectedArray enumerateObjectsUsingBlock:^(BWMProductModel *productModel, NSUInteger idx, BOOL *stop) {
        [postModel addProductID:productModel.productID];
    }];
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.navigationController.view title:@"请求下架.."];
    [BWMRequestCenter POST:[BWMProductPutawayPostModel API] parameters:[postModel postDictionary] success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [BWMMBProgressHUD hideHUD:HUD hideAfter:0];
        if([responseObject[@"status"] boolValue]) {
            _pageIndex = 1;
            [self p_loadDataIsMove:YES];
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString message:@"下架成功" type:BWMAlertViewTypeSuccess targetVC:self callBlock:nil];
        } else {
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString message:responseObject[@"error"] type:BWMAlertViewTypeError targetVC:self callBlock:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD hideAfter:0];
        [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString message:@"服务器访问失败，下架失败！" type:BWMAlertViewTypeError targetVC:self callBlock:nil];
    }];
}

- (void)p_changePutawayButton {
    if (_selectedArray.count > 0) {
        NSString *btnTitle = [NSString stringWithFormat:@"下架商品(%lu)", (unsigned long)_selectedArray.count];
        [_putawayButton setActivity];
        [_putawayButton setTitle:btnTitle forState:UIControlStateNormal];
    } else {
        [_putawayButton setTitle:@"下架商品" forState:UIControlStateNormal];
        [_putawayButton setUnactivity];
    }
    
    if (_dataArray.count == 0) {
        _tableView.tableFooterView = _tipsView;
    } else {
        _tableView.tableFooterView = [[UIView alloc] init];
    }
}

#pragma mark- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BWMProductCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentity];
    BWMProductModel *model = _dataArray[indexPath.row];
    [cell updateWithModel:model];
    [cell selectedAddBtn:[_selectedArray containsObject:model]];
    cell.delegate = self;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BWMProductCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [BWMProductSectionView height];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_sectionView == nil) {
        _sectionView = [BWMProductSectionView sectionViewWithDelegate:self];
    }
    return _sectionView;
}

#pragma mark- BWMMyShopHeaderViewDelegate
- (void)headerView:(BWMMyShopHeaderView *)headerView editBtnClicked:(UIButton *)button {
    ChangeInfoViewController *editInfoVC = [UIStoryboard initVCOnMainStoryboardWithID:@"ChangeInfoViewController"];
    editInfoVC.isChange = YES;
    [self.navigationController pushViewController:editInfoVC animated:YES];
}

- (void)headerView:(BWMMyShopHeaderView *)headerView cpyBtnClicked:(UIButton *)button {
    NSString * CopyStr = button.titleLabel.text;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = CopyStr;
    [BWMMBProgressHUD showTitle:@"复制成功"
                         toView:self.view
                      hideAfter:kBWMMBProgressHUDHideTimeInterval];
}

- (void)headerView:(BWMMyShopHeaderView *)headerView shareBtnClicked:(UIButton *)button{
    //微信网页类型
    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
    if (isInstalledWeixin){
        BWMTextViewBox *box = [BWMTextViewBox boxWithTitle:[ShareInfo shareInstance].userModel.name
                                                   content:kDefaultShareDetailText
                                              buttonTitles:@[@"确定", @"取消"]
                                                  delegate:self];
        [box show];
    } else {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}

- (void)headerView:(BWMMyShopHeaderView *)headerView searchTextFieldTaped:(UITextField *)textField {
    GoodsShelvesViewController *vc = [GoodsShelvesViewController viewControllerWithSell:YES delegate:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerView:(BWMMyShopHeaderView *)headerView myIconTaped:(UIImageView *)myIcon {
    ChangeInfoViewController *editInfoVC = [UIStoryboard initVCOnMainStoryboardWithID:@"ChangeInfoViewController"];
    editInfoVC.isChange = YES;
    editInfoVC.delegate = self;
    [self.navigationController pushViewController:editInfoVC animated:YES];
}

- (void)headerView:(BWMMyShopHeaderView *)headerView searchCloseBtnClicked:(UIButton *)button {
    [self p_reloadAttribute];
    [self p_loadDataIsMove:YES];
}

#pragma mark- BWMProductSectionViewDelegate
- (void)sectionView:(BWMProductSectionView *)sctionView putawayBtnClicked:(UIButton *)button {
    _orderBy = BWMProductModelOrderByUseTime;
    [BWMProductModel orderBy:_orderBy models:_dataArray];
    [_tableView reloadData];
}

- (void)sectionView:(BWMProductSectionView *)sctionView salesBtnClicked:(UIButton *)button {
    _orderBy = BWMProductModelOrderBySellNumber;
    [BWMProductModel orderBy:_orderBy models:_dataArray];
    [_tableView reloadData];
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
    vc.url = [NSString stringWithFormat:@"http://web.mallteem.com/ProductDetail.aspx?id=%@&ShopId=%@", model.productID, [ShareInfo shareInstance].userModel.userID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- BWMTextViewBoxDelegate
- (void)textViewBox:(BWMTextViewBox *)textViewBox buttonIndex:(int)buttonIndex {
    if (0 == buttonIndex) {
        //如果得到分享完成回调，需要设置delegate为self
        [BWMUmengManager settingWXShareTypeWeb];
        [BWMUmengManager sharingWithController:self
                                    shareTitle:textViewBox.titleValue
                                   shareDetail:textViewBox.contentValue
                                    shareImage:[ShareInfo shareInstance].userModel.uimg
                                     shareLink:[NSString stringWithFormat:myBeautifulShop,[ShareInfo shareInstance].userModel.userID]
                                      delegate:self];
    }
    
    [textViewBox close];
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
    _tipsView.title = kTipsViewNoSearchResultTips;
    _headerView.searchText = keyword;
    
    if (_BrandStr.length>0 || _TypeStr.length>0 || keyword.length>0) {
        [_headerView showCloseBtn];
    } else {
        [_headerView hideCloseBtn];
    }
    
    _dataArray = [NSMutableArray arrayWithArray:resultArray];
    [_selectedArray removeAllObjects];
    [self p_changePutawayButton];
    [_tableView reloadData];
}

#pragma mark- BWMTipsViewDelegate
- (void)tipsViewTaped:(BWMTipsView *)tipsView {
    BWMPutawayViewController *vc = [[BWMPutawayViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- BWMPutawayViewControllerDelegate
- (void)putawayViewControllerDidGoodsShelvesEnd:(BWMPutawayViewController *)viewController {
    [self p_reloadAttribute];
    [self p_loadDataIsMove:YES];
}

#pragma mark- ChangeInfoViewControllerDelegate
- (void)changeInfoViewControllerDidSuccessfulChangeInfo:(ChangeInfoViewController *)viewController {
    [_headerView refresh];
}

@end
