//
//  GuestManagementViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-11.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GuestManagementViewController.h"
#import "GuestManagementTableViewCell.h"
#import "GuestModel.h"
#import "DealProductModel.h"
#import "GuestInfoViewController.h"
#import "ChattingRecordsViewController.h"
#import "GuestMessageModel.h"
#import "GuestMessageModelViewController.h"
#import "UITableView+BWMTableView.h"
#import "UIView+BWMExtension.h"
#import "UIColor+BWMExtension.h"
#import "APIFactory.h"
#import "BWMMBProgressHUD.h"
#import "BWMDatePicker.h"

@interface GuestManagementViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
MJRefreshBaseViewDelegate,
BWMDatePickerDelegate
>
{
    int pageNum;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int totalCount;
    BOOL isScarch;
    NSOperationQueue *queue;
    NSString * dateString;
    NSString *_keyword;

}
@property (strong, nonatomic) IBOutlet UIView *searchBarBGView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *selecteDateBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) NSMutableArray * myGuests;
@end

@implementation GuestManagementViewController
#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if (refreshView == _header) { // 下拉刷新
        NSLog(@"下拉刷新");
        pageNum = 1;
        if ([queue operationCount] > 0) {
            
            [queue cancelAllOperations];
        }
        
        [self performSelector:@selector(GetMyGuest) withObject:nil afterDelay:0.5];
        
        
    }else if (refreshView == _footer) { // 上拉加载更多
        
        if (pageNum * 20 < totalCount) {
            
            pageNum++;
            if ([queue operationCount] > 0) {
                
                [queue cancelAllOperations];
            }
            [self performSelector:@selector(GetMyGuest) withObject:nil afterDelay:0.5];
        } else {
            [self performSelector:@selector(endRefreshing:) withObject:@YES afterDelay:0.5];
        }
        
    }
}
- (void)endRefreshing:(NSNumber *)value {
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
    if ([value boolValue]) {
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"没有更多数据了");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"客户管理";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;

}
- (void)GetMyGuest
{
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
//    //获取当天的日期
//    NSDate * date = [NSDate date];
//    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    fmt.dateFormat = @"yyyy-MM-dd";
//    dateString = [fmt stringFromDate:date];

    NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=customers&userid=%@&size=20&index=%d&moon=%@&key=%@",shareInfo.userModel.userID,pageNum,dateString, _keyword];
    
    [self dataRequest:link SucceedSelector:@selector(UpCustomereData:)];

}

- (void)UpCustomereData:(NSMutableDictionary*)dict {
    NSLog(@"dict:%@",dict);
    
    self.myGuests = [NSMutableArray array];
    NSMutableArray * array = [dict objectForKey:@"customers"];
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary * GuestDict = [array objectAtIndex:i];
        GuestModel * myGuestModel = [[GuestModel alloc]init];
        myGuestModel.GuestID = [GuestDict objectForKey:@"id"];
        myGuestModel.imgUrl = [GuestDict objectForKey:@"imgUrl"];
        myGuestModel.name = [GuestDict objectForKey:@"name"];
        myGuestModel.phone = [GuestDict objectForKey:@"phone"];
        myGuestModel.weixinNo = [GuestDict objectForKey:@"weixinNo"];
        myGuestModel.turnover = [GuestDict objectForKey:@"turnover"];
        myGuestModel.lastDealTime = [GuestDict objectForKey:@"lastDealTime"];
        NSMutableArray * DealProducts = [GuestDict objectForKey:@"lastDealProducts"];
        myGuestModel.lastDealProducts = [NSMutableArray array];
        for (int y = 0; y<DealProducts.count; y++) {
            NSMutableDictionary * DealProductDict = [DealProducts objectAtIndex:y];
            DealProductModel * ProductModel = [[DealProductModel alloc]init];
            ProductModel.productId = [[DealProductDict objectForKey:@"productId"]intValue];
            ProductModel.productName = [DealProductDict objectForKey:@"productName"];
            ProductModel.productImg = [DealProductDict objectForKey:@"productImg"];
            ProductModel.color = [[DealProductDict objectForKey:@"color"] intValue];
            ProductModel.size = [DealProductDict objectForKey:@"size"];
            
            
            [myGuestModel.lastDealProducts addObject:ProductModel];
        }
        
        [self.myGuests addObject:myGuestModel];
    }
    
    [self.myTableView reloadData];
    
    [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
   
    [_header endRefreshing];
    [_footer endRefreshing];
    
    if (array.count == 0) {
        [self.myTableView bwm_addLabelToCenterWithText:@"还没有相应的客户..."];
    } else {
        [self.myTableView bwm_removeView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _keyword = @"";
    
    self.myTableView.delegate  = self;
    self.myTableView.dataSource = self;
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.myTableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.myTableView;
    _footer.delegate = self;
    
    pageNum = 1;
    dateString = @"";
    [self GetMyGuest];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"GuestManagementTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    [self.myTableView reloadData];

    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setInteger:shareInfo.userModel.userNumber forKey:@"userNumber"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myGuests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell" ;
    
    GuestManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    GuestModel * model = [self.myGuests objectAtIndex:indexPath.row];
    cell.GuestName.text = model.name;
    cell.LsatDealTime.text = [NSString stringWithFormat:@"手机号码:%@",model.phone];
    cell.orderTimeLabel.text = [NSString stringWithFormat:@"最后下单时间：%@", model.lastDealTime];
    float turn = [model.turnover floatValue];
    cell.turnover.text = [NSString stringWithFormat:@"总消费:￥%.2f",turn];
    
    NSString *imageURLString = [APIFactory imageCompletionStringWithSegment:model.imgUrl];
    [cell.GuestImage sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"测试头像"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            cell.GuestImagePlaceholderLabel.hidden = NO;
            if (model.name.length >= 1) {
                cell.GuestImagePlaceholderLabel.text = [model.name substringToIndex:1];
            }
            cell.GuestImagePlaceholderLabel.backgroundColor = [UIColor colorWithCustomerPhone:model.phone];
        } else {
            cell.GuestImagePlaceholderLabel.hidden = YES;
        }
    }];
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

 #pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     GuestModel * model  = [self.myGuests objectAtIndex:indexPath.row];
     
     GuestInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestInfoViewController"];
     vc.myModel = model;
     [self.navigationController pushViewController:vc animated:YES];
 }
 
#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *link = url;
        NSLog(@"%@",link);
        id jsonObject = [JSONData JSONDataValue:link];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = nil;
            if(jsonObject==nil) {
                message = @"获取数据失败请检查你的网络";
                [self showAlertViewForTitle:message AndMessage:nil];
            } else {
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
        
    });
    
}
- (IBAction)DidEndOnExit:(UITextField *)sender {
    _keyword = sender.text;
    pageNum = 1;
    [self GetMyGuest];
    [sender resignFirstResponder];
}

- (void)dealloc {
    [_header free];
    [_footer free];
}

#pragma mark 聊天记录
- (IBAction)ChattingRecords:(UIButton *)sender {
    //    顾客：http://183.60.132.104:8089/?customerId=3&shopkeeperId=2&nickName=%E9%A1%BE%E5%AE%A23
    //    店主：http://183.60.132.104:8089/?customerId=3&shopkeeperId=2&t=1&nickName=%E5%BA%97%E4%B8%BB2
    //    获取顾客：http://183.60.132.104:8089/customers?shopkeeperId=2&pageIndex=1
    
    //    customerid 顾客id
    //    shopkeeperid 店主/店长id
    //    told 为1就行了
    //    nickname  店主/店长名称
    
//    ShareInfo * shareInfo = [ShareInfo shareInstance];
//    NSString * link = [NSString stringWithFormat:@"http://183.60.132.104:8089/customers?shopkeeperId=%@&pageIndex=1",shareInfo.userModel.userID];
//    [self dataRequest:link SucceedSelector:@selector(UpGuestData:)];
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}

- (void)UpGuestData:(NSMutableArray*)array {
    NSLog(@"array:%@",array);
    NSMutableArray * mesArray = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        NSMutableDictionary * dict = [array objectAtIndex:i];
        GuestMessageModel *model = [[GuestMessageModel alloc]init];
        model.customerId = [[dict objectForKey:@"customerId"] intValue];
        model.msg = [dict objectForKey:@"msg"];
        model.Count = [[dict objectForKey:@"newCount"]intValue];
        model.nickName = [dict objectForKey:@"customerName"];
        model.shopkeeperId = [dict objectForKey:@"shopkeeperId"];
        NSString * tsStr = [dict objectForKey:@"ts"];
        long long int ts  = [tsStr longLongValue];
        NSLog(@"tsStr : %@",tsStr);
        NSLog(@"ts : %lld",ts);
    
        NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:ts/1000];
        
//        NSDate *  dateTime = [NSDate dateWithTimeIntervalSince1970:ts/1000];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterNoStyle];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        NSLocale *formatterLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
        [formatter setLocale:formatterLocal];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *theDateString = [formatter stringFromDate:dateTime];
        
        NSLog(@"time is %@",theDateString);
        

        model.ts = theDateString;
        
        [mesArray addObject:model];
        
    }
    NSLog(@"mesArray.count:%d",(int)mesArray.count);
    
    
    GuestMessageModelViewController * vc= [self.storyboard instantiateViewControllerWithIdentifier:@"GuestMessageModelViewController"];
    vc.MyArray = mesArray;
    [self.navigationController pushViewController:vc animated:YES];
}

// 选择年月份查询
- (IBAction)selecteDateBtnClicked:(UIButton *)sender {
    if (!_selecteDateBtn.selected) {
        BWMDatePicker *datePicker = [BWMDatePicker pickerWithDelegate:self];
        [datePicker show];
    } else {
        NSLog(@"做取消选择的操作");
        [_selecteDateBtn setTitle:@"选择日期" forState:UIControlStateNormal];
        dateString = @"";
        pageNum = 1;
        [self GetMyGuest];
        _selecteDateBtn.selected = NO;
    }
    
    [self.searchTF resignFirstResponder];
}

#pragma mark- BWMDatePickerDelegate
- (void)datePicker:(BWMDatePicker *)datePicker didSelectedDate:(NSString *)dateStr sender:(UIButton *)sender {
    [_selecteDateBtn setTitle:dateStr forState:UIControlStateNormal];
    _selecteDateBtn.selected = YES;
    [datePicker close];
    
    // 重新加载数据
    dateString = [NSString stringWithFormat:@"%@-01", dateStr];
    pageNum = 1;
    [self GetMyGuest];
}

- (void)datePicker:(BWMDatePicker *)datePicker didCancelBtnClicked:(UIButton *)cancelBtn {
    [datePicker close];
}

@end
