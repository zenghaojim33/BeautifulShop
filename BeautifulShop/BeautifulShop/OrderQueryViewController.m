//
//  OrderQueryViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-11.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderQueryViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/SDWebImageManager.h"
#import "MyOderTableViewCell.h"
#import "OrderModel.h"
#import "productModel.h"
#import "StartTimeViewController.h"
#import "EndTimeViewController.h"
#import "OrderInfoViewController.h"
#import "OrderStatusFactory.h"
#import "OrderInfoDetailStatusFactory.h"
#import "UITableView+BWMTableView.h"
#import "OrderTypeToolView.h"
#import "BWMMBProgressHUD.h"

@interface OrderQueryViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,StartimeDelegate,EndTimeDelegate, OrderTypeToolViewDelegate>
{

    OrderTypeToolView *_orderTypeToolView;
    NSString * DataStr;
    
    
    int selectNum;
    ShareInfo * shareInfo;
    
    int pageNum;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int totalCount;
    NSOperationQueue *queue;
    
    
    OrderDetailStatus _orderStatus;
    
    BOOL isTime;
    
    
    NSString * selectStartTime;
    NSString * selectEndTime;
    
    
    IBOutlet UIView *_buttonViewContrainer;

}
@property (strong, nonatomic) IBOutlet UIButton *DATEndBth;
@property (strong, nonatomic) IBOutlet UIButton *DATABth;

@property (strong, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;



@property (strong,nonatomic) NSMutableArray * MyDataArray;
@end

@implementation OrderQueryViewController
#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    if (refreshView == _header) { // 下拉刷新
        NSLog(@"下拉刷新");
        pageNum = 1;
        if ([queue operationCount] > 0) {
            
            [queue cancelAllOperations];
        }
        
        [self performSelector:@selector(UpDaata) withObject:nil afterDelay:0.5];
        
        
    }else if (refreshView == _footer) { // 上拉加载更多
        
        if (pageNum * 20 < totalCount) {
            
            pageNum++;
            if ([queue operationCount] > 0) {
                
                [queue cancelAllOperations];
            }
            [self performSelector:@selector(UpDaata) withObject:nil afterDelay:0.5];
            
        } else {
            
            [self performSelector:@selector(endRefreshing:) withObject:@YES afterDelay:0.5];
            
        }
        
    }
}

- (void)endRefreshing:(NSNumber *)value
{
    // 结束刷新状态
    [_header endRefreshing];
    [_footer endRefreshing];
    if ([value boolValue]) {
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"没有更多数据了");
    }
}

-(void)UpDaata {
    
//http://server.mallteem.com/json/index.ashx?aim=getorders&seller=发型师id&buyer=顾客id&type=订单类型&key=关键字&index=页码&size=每页条数starttime=开始时间段（yyyy-mm-dd）&endtime=结束时间（yyyy-mm-dd）
    
    
    NSString * starttime = selectStartTime?selectStartTime:@"";
    NSString * endtime = selectEndTime?selectEndTime:@"";
    
    shareInfo = [ShareInfo shareInstance];
    NSString * link = [NSString stringWithFormat:Getorders, shareInfo.userModel.userID, @"",(int)_orderStatus,self.myTextField.text,pageNum,starttime,endtime];
    
    [self dataRequest:link SucceedSelector:@selector(UpOderData:)];

}

-(void)UpOderData:(NSMutableDictionary*)dict
{
    
    self.myTableView.delegate  = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyOderTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.myTableView reloadData];
    
    
    NSLog(@"dict:%@",dict);
    
    self.MyDataArray = [NSMutableArray array];
    
    NSMutableArray * orders = [dict objectForKey:@"orders"];
    if (orders.count == 0) {
        static CGPoint labelCenter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            labelCenter = CGPointMake(_myTableView.center.x, 250);
        });
        [_myTableView bwm_addLabelWithText:@"找不到相关的订单..." toPoint:labelCenter];
    } else {
        [_myTableView bwm_removeView];
    }
    
    for (int i = 0; i<orders.count;i++)
    {
        NSMutableDictionary * orderDict = [orders objectAtIndex:i];
        OrderModel * model = [[OrderModel alloc]init];
        model.orderId = [orderDict objectForKey:@"orderId"];
        model.createAcc = [orderDict objectForKey:@"createTime"];
        model.createTime = [orderDict objectForKey:@"createTime"];
//        model.orderNo = [orderDict objectForKey:@"orderNo"];
        model.buyer = [orderDict objectForKey:@"buyer"];
        model.price = [orderDict objectForKey:@"price"];
        model.status = [[orderDict objectForKey:@"status"] integerValue];
        NSMutableArray * array = [orderDict objectForKey:@"products"];
        model.products = [NSMutableArray array];
        for (int i = 0; i<array.count; i++)
        {
            NSMutableDictionary * dict = [array objectAtIndex:i];
            productModel * newModel = [[productModel alloc]init];
            newModel.productId = [dict objectForKey:@"productId"];
            newModel.productImg = [dict objectForKey:@"productImg"];
            newModel.productName = [dict objectForKey:@"productName"];
            newModel.size = [dict objectForKey:@"size"];
            
            [model.products addObject:newModel];
        }
        
        [self.MyDataArray addObject:model];
        
    }
    [_header endRefreshing];
    [_footer endRefreshing];
    
    [self.myTableView reloadData];
}

// test
- (void)p_createButtonView {
    _orderTypeToolView = [OrderTypeToolView createWithFrame:CGRectMake(0, 0, 320, 33) delegate:self];
    [_buttonViewContrainer addSubview:_orderTypeToolView];
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
        
        NSString *link = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(self.MyDataArray.count==0){
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }
    
    return self.MyDataArray.count;
}
- (void)dealloc
{
    [ _header free ];
    [ _footer free ];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyOderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
    
    OrderModel * model = [self.MyDataArray objectAtIndex:indexPath.row];
    cell.OderNameLabel.text = [NSString stringWithFormat:@"订单编号: %@", model.orderId];
    cell.OderPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    cell.OderTimeLabel.text = model.createTime;
    cell.OderStatus.text = model.productsName;
    productModel * newModel = [model.products objectAtIndex:0];
    NSString * Link = [NSString stringWithFormat:@"http://server.mallteem.com/%@",newModel.productImg];
    
    UIImage * image =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:Link];
    if (image==nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * NewImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            [[SDWebImageManager sharedManager] saveImageToCache:NewImage forURL:[NSURL URLWithString:Link]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.OderImageView.image = NewImage;
//                [cell layoutSubviews];
            });
        });
    }else{
        cell.OderImageView.image = image;
    }

    cell.selectionStyle = UITableViewCellAccessoryNone;
    // Configure the cell...
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    isTime = YES;
    
    self.title = @"订单查询";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;

    // Do any additional setup after loading the view.
}

- (IBAction)DidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
    
    // 搜索条完成点击事件
    if(sender.tag == 33) {
        [self UpDaata];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _orderStatus = OrderInfoDetailStatusNotPaying;
  
      [self UpDaata];
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.myTableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.myTableView;
    _footer.delegate = self;
    

    ShareInfo * theShareInfo = [ShareInfo shareInstance];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setInteger:(NSInteger)theShareInfo.userModel.orderNumber forKey:@"orderNumber"];
    
    [self p_createButtonView];
}


- (IBAction)TouchData:(UIButton *)sender {
    
    NSLog(@"TouchData");

    StartTimeViewController *vc = [[StartTimeViewController alloc]init];
    
    vc.delegate =self;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)SetStartTimteStr:(NSString *)startTimeStr {
    
    selectStartTime = startTimeStr;
    
    [self.DATABth setTitle:[NSString stringWithFormat:@"%@",startTimeStr] forState:UIControlStateNormal];
}

- (IBAction)TouchEndData:(id)sender {
    if (selectStartTime.length ==0) {
        [self showAlertViewForTitle:@"请选择开始日期" AndMessage:nil];
    }else{
    
        EndTimeViewController * vc = [[EndTimeViewController alloc]init];
        vc.StartTimeStr = selectStartTime;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
}

-(void)SetEndTimeStr:(NSString *)endTimeStr {
    [self.DATEndBth setTitle:[NSString stringWithFormat:@"%@",endTimeStr] forState:UIControlStateNormal];
    
    selectEndTime = endTimeStr;
    
    
    [self UpDaata];
}

#pragma mark - Table view delegate
//告诉你那一行被点击了
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel * model = [self.MyDataArray objectAtIndex:indexPath.row];
    OrderInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderInfoViewController"];
    vc.myModel = model;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark- OrderTypeToolViewDelegate
- (void)toolView:(OrderTypeToolView *)toolView didSelectRow:(NSInteger)row button:(UIButton *)button title:(NSString *)title {
    _orderStatus = row;
    [self UpDaata];
}

@end
