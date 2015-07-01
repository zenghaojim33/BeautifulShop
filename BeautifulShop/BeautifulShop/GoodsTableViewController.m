//
//  GoodsTableViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-14.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GoodsTableViewController.h"
#import "MyGoodsTableViewCell.h"
#import "GoodsModel.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/SDWebImageManager.h"
#import "GoodsInfoViewController.h"
#import "GoodsShelvesViewController.h"
#import "UITableView+BWMTableView.h"
#import "BWMUmengManager.h"
#import "APIFactory.h"
#import "UIView+BWMExtension.h"
#import "UIColorFactory.h"
#import "BWMAlertViewFactory.h"
#import "BWMRequestCenter.h"
#import "BWMMBProgressHUD.h"

@interface GoodsTableViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    MyGoodsCellDelegate,
    MJRefreshBaseViewDelegate,
    GoodsShelvesDelegate,
    UITextFieldDelegate,
    UMSocialUIDelegate,UIAlertViewDelegate
>
{
    int selectNum;
    ShareInfo * shareInfo;
    
    int pageNum;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int totalCount;
    BOOL isScarch;
    BOOL _isLoadMoreData;
    NSOperationQueue *queue;
}
@property (strong, nonatomic) IBOutlet UIControl *searchBarBGView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray * selectArray;
@property (strong, nonatomic) IBOutlet UIButton *addGoodBth;

@property (strong, nonatomic) IBOutlet UITextField *myTF;
@end

@implementation GoodsTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"货品上架";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    
    self.myTF.delegate = self;
    self.myTF.tag = 999;
    self.navigationItem.backBarButtonItem = backItem;
}

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    if (refreshView == _header) { // 下拉刷新
        _isLoadMoreData = NO;
        NSLog(@"下拉刷新");
        pageNum = 1;
        if ([queue operationCount] > 0) {
            
            [queue cancelAllOperations];
        }
        
        [self performSelector:@selector(UpMyGoods) withObject:nil afterDelay:0.5];
    } else if (refreshView == _footer) { // 上拉加载更多
        _isLoadMoreData = YES;
//        if (pageNum * 20 < totalCount) {
            NSLog(@"%d",totalCount);
            pageNum++;
            if ([queue operationCount] > 0) {
                
                [queue cancelAllOperations];
            }
            [self performSelector:@selector(UpMyGoods) withObject:nil afterDelay:0.5];
//        }
//        else{
//            
//            [self performSelector:@selector(endRefreshing:) withObject:@YES afterDelay:0.5];
//            
//        }
        
    }
}

- (void)endRefreshing:(NSNumber *)value
{
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
    if ([value boolValue]) {
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:1.0f];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)UpMyGoods {
    
    shareInfo = [ShareInfo shareInstance];
    
    NSString * link = [NSString stringWithFormat:Getproduct,@"",shareInfo.userModel.userID,@"0",_BrandStr,_TypeStr,_scarchStr,pageNum,@""];
    
    [self dataRequest:link SucceedSelector:@selector(GetproductData:)];    
}

- (void)GetproductData:(NSMutableDictionary*)dict {
    MBProgressHUD * HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:kBWMMBProgressHUDLoadingMsg];
    
    NSLog(@"dict:%@",dict);
    NSString * status = [dict objectForKey:@"status"];
    NSString * error = dict[@"error"];
    
    if ([[dict objectForKey:@"productList"] isKindOfClass:[NSArray class]] && [[dict objectForKey:@"productList"] count] == 0 && !_isLoadMoreData) {
        [_myTableView bwm_addLabelToCenterWithText:@"没有找到相关的货品..."];
        [self.myDataArray removeAllObjects];
        [_myTableView reloadData];
    } else {
        [_myTableView bwm_removeView];
    }
    
    int statusInt = [status intValue];
    if (pageNum == 1) {
        self.myDataArray= [NSMutableArray array];
    }
    if ([error isEqualToString:@""]){
    if (statusInt == 0) {
        
        [HUD hide:YES afterDelay:0.1];
        
        [self showAlertViewForTitle:@"获取数据失败" AndMessage:@"请检查您的网络"];
        
    } else {
    
        
        NSArray *productList = [dict objectForKey:@"productList"];
        
        if (productList.count==0) {
              [self performSelector:@selector(endRefreshing:) withObject:@YES afterDelay:0.5];
        } else {
            for (int i = 0; i<productList.count; i++) {
                NSMutableDictionary * GoodDit =  [productList objectAtIndex:i];
                GoodsModel * model = [[GoodsModel alloc]init];
                model.GoodsID = [GoodDit objectForKey:@"id"];
                model.productName = [GoodDit objectForKey:@"productName"];
                model.mainImgUrl = [GoodDit objectForKey:@"mainImgUrl"];
                model.size = [GoodDit objectForKey:@"size"];
                model.saleNum = [GoodDit objectForKey:@"saleNum"];
                model.onSaleDate = [GoodDit objectForKey:@"onSaleDate"];
                model.productDescription = [GoodDit objectForKey:@"desc"];
                model.storeNumber = [[GoodDit objectForKey:@"_number"] integerValue];
                model.finalPrice = [GoodDit objectForKey:@"_finalPrice"];
                model.marketPrice = [GoodDit objectForKey:@"_marketPrice"];
                model.nSize = [GoodDit objectForKey:@"_size"];
                [self.myDataArray addObject:model];
            }
            [HUD hide:YES afterDelay:0.1];
        
            [_header endRefreshing];
            [_footer endRefreshing];
        
            
            NSLog(@"my.Data.count:%lu", (unsigned long)self.myDataArray.count);
            self.myTableView.delegate = self;
            self.myTableView.dataSource = self;
            [self.myTableView registerNib:[UINib nibWithNibName:@"MyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
            [self.myTableView reloadData];
            selectNum = 0;
            [self initVC];
        }
        
    }
    } else {
        [self performSelector:@selector(endRefreshing:) withObject:@YES afterDelay:0.5];
    }
    [self.myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addGoodBth.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
    
    [self.searchBarBGView drawingDefaultStyleShadow];
    self.selectArray = [NSMutableArray array];
    selectNum = 0;
    
    

     pageNum = 1;

    /**
     *  重置搜索参数
     */
    
        _BrandStr = @"";
        _TypeStr = @"";
        _scarchStr = @"";
    
        _header = [MJRefreshHeaderView header];
        _header.scrollView = self.myTableView;
        _header.delegate = self;
        
        _footer = [MJRefreshFooterView footer];
        _footer.scrollView = self.myTableView;
        _footer.delegate = self;
        
        self.myTableView.delegate  = self;
        self.myTableView.dataSource = self;
        
        [self.myTableView registerNib:[UINib nibWithNibName:@"MyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        
        [self.myTableView reloadData];
//    
    
    ShareInfo * theShareInfo = [ShareInfo shareInstance];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setInteger:theShareInfo.userModel.productNumber forKey:@"productNumber"];
    
    [self UpMyGoods];
}

- (IBAction)AddGoods:(UIButton *)sender {
    if(selectNum ==0){
        [BWMMBProgressHUD showTitle:@"请选择需要添加的产品" toView:self.view hideAfter:2.0f msgType:BWMMBProgressHUDMsgTypeWarning];
    }else{
//        UIAlertView * av = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"确定添加这%d件产品到你的店吗?",selectNum] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        av.tag = 888;
//
//        [av show];
        [self AllUpGoods];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==888&&buttonIndex==1) {
                //上架
        [self AllUpGoods];
    }
    
    if (alertView.tag == 77&&buttonIndex!=0) {
        //发送文字
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = @"TEST123321123123131231";
        
        
        if(buttonIndex==1){
            //微信好友
            req.scene = 0;
        }else{
            //朋友圈
            req.scene = 1;
        }
        [WXApi sendReq:req];
    } else if (buttonIndex==1 && alertView.tag==998){
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://appsto.re/cn/S8gTy.i"]];
    }
}

#pragma mark 全部上架
-(void)AllUpGoods {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ShareInfo * theShareInfo = [ShareInfo shareInstance];
    
    
    // 创建一个请求地址
    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=useproduct"];
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 修改请求 方式  ****以下为post请求
    
    [request setHTTPMethod:@"POST"];
    
    NSString * pid = @"";
    
    //拼接ID
    if(self.selectArray.count==1) {
        GoodsModel * model = [self.selectArray objectAtIndex:0];
        pid = model.GoodsID;
    } else {
        for (int i = 0 ; i<self.selectArray.count; i++) {
            GoodsModel * model = [self.selectArray objectAtIndex:i];
           
            if (i==0) {
                pid = model.GoodsID;
            } else {
                pid = [NSString stringWithFormat:@"%@,%@",pid,model.GoodsID];
            }
        }
    }
    
    
    NSLog(@"pid:%@",pid);
    
    NSData *requestBody = [[NSString stringWithFormat:@"pid=%@&uid=%@&du=add",pid,theShareInfo.userModel.userID] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
    NSError *error=nil;
    
    //发出请求 并且得到响应数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:&error];
    
    
    if(data==nil) {
        
        
    } else {
        
        NSLog(@"data不等于空");
        
        NSError *error=nil;
        
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        
        
        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
        [self performSelector:@selector(AllUpGoods:) withObject:dict afterDelay:0.2f];
        
    }
    
    [HUD hide:YES afterDelay:0.1];

}

-(void)AllUpGoods:(NSMutableDictionary*)dict {
    NSLog(@"dict:%@",dict);

    NSString * status = [dict objectForKey:@"status"];
    
    int statusInt = [status intValue];
    if (statusInt == false) {
        NSString * error = [dict objectForKey:@"error"];
        [self showAlertViewForTitle:@"上架失败" AndMessage:error];
    } else {
        [self showAlertViewForTitle:@"上架成功" AndMessage:nil];
        
        selectNum = 0;
        
        [_header beginRefreshing];
        [self UpMyGoods];
        
        [self initVC];
        
        if ([self.delegate respondsToSelector:@selector(goodsTableViewControllerDidGoodsShelvesEnd:)]) {
            [self.delegate goodsTableViewControllerDidGoodsShelvesEnd:self];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    if (textField.tag== 999) {
        
        [self.myTF resignFirstResponder];
        
        GoodsShelvesViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsShelvesViewController"];
        
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark 初始化数据
-(void)initVC {
    self.selectArray = [NSMutableArray array];
    [self.addGoodBth setTitle:@"上架货品" forState:UIControlStateNormal];
    self.addGoodBth.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell" ;

    MyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell != nil) {
        cell =  (MyGoodsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    GoodsModel * model = self.myDataArray[indexPath.row];
    
    cell.GoodTitleLabel.text = model.productName;
    
    cell.storeCountLabel.text = [NSString stringWithFormat:@"%ld", (long int)model.storeNumber];
    cell.weiPriceLabel.text = model.finalPrice;
    cell.marketPriceLabel.attributedText =  model.marketPriceAttributeString;
    cell.sizeLabel.text = model.nSize;
    
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    if (model.isTouch==YES) {
        [cell.AddBth setTitle:@"已选择" forState:UIControlStateNormal];
        cell.AddBth.selected = YES;
        [cell.AddBth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    } else {
        [cell.AddBth setTitle:@"增加" forState:UIControlStateNormal];
        cell.AddBth.selected = NO;
        [cell.AddBth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    NSString * Link = [NSString stringWithFormat:@"http://server.mallteem.com/%@",model.mainImgUrl];
    [cell.GoodImageView sd_setImageWithURL:[NSURL URLWithString:Link]
                          placeholderImage:[UIImage imageNamed:@"product_placeholder"]
                                   options:SDWebImageRefreshCached];
    
    cell.TextView.text = model.size;
    
    int i = indexPath.row%4;
    
    UIColor * color;
    
    switch (i) {
        case 0:
            color = [UIColor colorWithRed:125/255.0 green:90/255.0 blue:90/255.0 alpha:1];
            break;
        case 1:
            color = [UIColor colorWithRed:95/255.0 green:127/255.0 blue:132/255.0 alpha:1];
            break;
        case 2:
            color = [UIColor colorWithRed:186/255.0 green:70/255.0 blue:122/255.0 alpha:1];
            break;
        case 3:
            color = [UIColor colorWithRed:53/255.0 green:211/255.0 blue:250/255.0 alpha:1];
            break;
            
        default:
            break;
    }
    // Configure the cell...
    cell.BGView1.backgroundColor = [UIColor whiteColor];
    [cell.AddBth setBackgroundColor:[UIColor whiteColor]];
    [cell.CopyBth setBackgroundColor:[UIColor whiteColor]];
    [cell.ShareBth setBackgroundColor:[UIColor whiteColor]];
    
     cell.selectionStyle =UITableViewCellAccessoryNone;
    return cell;
}

-(void)TouchAddButtonForTag:(int)tag IsBool:(BOOL)isTouch AndButton:(UIButton *)button {
    GoodsModel * model = [self.myDataArray objectAtIndex:tag];
    NSLog(@"GoodsID:%@",model.GoodsID);
    if (isTouch == 1)
    {
        model.isTouch = YES;
        [self.selectArray addObject:model];
        selectNum += 1;
        [self.addGoodBth setTitle:[NSString stringWithFormat:@"确认上架(%d)",selectNum] forState:UIControlStateNormal];
        self.addGoodBth.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
    } else {
        model.isTouch = NO;
        
        selectNum -= 1;
        if (selectNum==0) {
            self.selectArray = [NSMutableArray array];
            
            [self.addGoodBth setTitle:@"上架货品" forState:UIControlStateNormal];
            self.addGoodBth.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
        } else {
            
            for (int i = 0; i<self.selectArray.count; i++) {
                GoodsModel * newModel = [self.selectArray objectAtIndex:i];
                if ([newModel.productName isEqualToString:model.productName]) {
                    [self.selectArray removeObjectAtIndex:i];
                }
            }
            
            [self.addGoodBth setTitle:[NSString stringWithFormat:@"确认上架(%d)",selectNum] forState:UIControlStateNormal];
            self.addGoodBth.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
        }
    }
    self.myDataArray[tag] = model;
    
    [self.myTableView reloadData];

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector {
    [BWMRequestCenter GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self performSelector:selector withObject:responseObject afterDelay:0.2f];
        [_header endRefreshing];
        [_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadErrorMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
        
        [_header endRefreshing];
        [_footer endRefreshing];
    }];
    
}

-(void)SetArray:(NSMutableArray *)array {
    NSLog(@"返回搜索数据");
    isScarch = YES;
    self.myDataArray = array;
    [self.myTableView reloadData];
}

-(void)TouchCellForTag:(int)tag {
    NSLog(@"TouchTableView:%d",tag);
    
    GoodsModel * model = [self.myDataArray objectAtIndex:tag];
    
   
    GoodsInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsInfoViewController"];
    
    vc.url = [NSString stringWithFormat:@"http://web.mallteem.com/_ProductDetail.aspx?id=%@&ShopId=%@",model.GoodsID,shareInfo.userModel.userID];
    NSLog(@"%@", vc.url);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击复制
-(void)TouchCopyForCellTag:(int)tag {
    [BWMMBProgressHUD showTitle:@"请先上架才能复制链接！" toView:self.view hideAfter:2.0f msgType:BWMMBProgressHUDMsgTypeInfo];
//    GoodsModel * model = [self.myDataArray objectAtIndex:tag];
//    
//    NSString * CopyStr = [NSString stringWithFormat:myProduct,model.GoodsID,shareInfo.userModel.userID];
//    
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    
//    pasteboard.string = CopyStr;
//    
//    [Tools showPromptToView:self.view atPoint:self.view.center withText:@"复制成功" duration:1.0];
}

#pragma mark 点击分享
-(void)TouchShareForCellTag:(int)tag {
    [BWMMBProgressHUD showTitle:@"请先上架再进行分享！" toView:self.view hideAfter:2.0f msgType:BWMMBProgressHUDMsgTypeInfo];
    
//    BOOL hasInstalledWeixin = [WXApi isWXAppInstalled];
//    
//    if (hasInstalledWeixin) {
//        GoodsModel * model = [self.myDataArray objectAtIndex:tag];
//        
//        [BWMUmengManager settingWXShareTypeWeb];
//        [BWMUmengManager sharingWithController:self
//                                    shareTitle:model.productName
//                                   shareDetail:model.productDescription
//                                    shareImage:[APIFactory imageCompletionStringWithSegment:model.mainImgUrl]
//                                     shareLink:[NSString stringWithFormat:myProduct,model.GoodsID,shareInfo.userModel.userID]
//                                      delegate:self];
//    } else {
//        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
//        av.tag = 998;
//        [av show];
//    }
}

- (void)dealloc {
    if (_header) {
        [_header free];
    }
    
    if (_footer) {
        [_footer free];
    }
}

@end
