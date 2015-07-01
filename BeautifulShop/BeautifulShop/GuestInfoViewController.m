//
//  GuestInfoViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GuestInfoViewController.h"
#import "GuestTableViewCell.h"
#import "OrderModel.h"
#import "productModel.h"
#import "OrderInfoViewController.h"
#import "ChattingRecordsViewController.h"
#import "UIColor+BWMExtension.h"
#import "OrderInfoDetailStatusFactory.h"
#import "APIFactory.h"
#import "UIView+BWMExtension.h"
#import "BWMMBProgressHUD.h"

@interface GuestInfoViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    MJRefreshBaseViewDelegate
>
{
    int pageNum;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    int totalCount;
    NSOperationQueue *queue;
}
@property (strong, nonatomic) IBOutlet UILabel *GuestName;
@property (strong, nonatomic) IBOutlet UILabel *LastDealTime;
@property (strong, nonatomic) IBOutlet UILabel *turnover;
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *GuestImage;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *BGView;
@property (strong, nonatomic) NSMutableArray * MyDataArray;
@property (strong, nonatomic) IBOutlet UILabel *GuestImagePlaceholderLabel;
@property (strong, nonatomic) IBOutlet UIButton *GMLSBtn;

@end

@implementation GuestInfoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"客户详情";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_BGView drawingDefaultStyleShadow];
    [_GMLSBtn drawingDefaultStyleShadow];
    
    pageNum = 1;
    // Do any additional setup after loading the view.
    self.GuestName.text = self.myModel.name;
    self.LastDealTime.text = [NSString stringWithFormat:@"手机号码:%@", self.myModel.phone];
    self.orderTimeLabel.text = [NSString stringWithFormat:@"最后下单时间:%@", self.myModel.lastDealTime];
    float turn = [self.myModel.turnover floatValue];
    self.turnover.text = [NSString stringWithFormat:@"总消费:￥%.2f",turn];
    
    NSString *imagePath = self.myModel.imgUrl;
    NSURL *imageURL = [APIFactory imageCompletionURLWithSegment:imagePath];
    [self.GuestImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"测试头像"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            self.GuestImagePlaceholderLabel.hidden = NO;
            if (self.myModel.name.length >= 1) {
                self.GuestImagePlaceholderLabel.text = [self.myModel.name substringToIndex:1];
            }
            self.GuestImagePlaceholderLabel.backgroundColor = [UIColor colorWithCustomerPhone:self.myModel.phone];
        } else {
            self.GuestImagePlaceholderLabel.hidden = YES;
        }
    }];
    
    [self upOrderData];
   
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    _header = [MJRefreshHeaderView header];
    _header.scrollView = self.myTableView;
    _header.delegate = self;
    
    _footer = [MJRefreshFooterView footer];
    _footer.scrollView = self.myTableView;
    _footer.delegate = self;
    self.myTableView.backgroundColor = [UIColor clearColor];
     [self.myTableView registerNib:[UINib nibWithNibName:@"GuestTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.myTableView reloadData];
}

-(void)upOrderData {
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=getorders&seller=%@&buyer=%@&type=&key=&index=%d&size=20&starttime=&endtime=",shareInfo.userModel.userID,self.myModel.GuestID,pageNum];
    
    [self dataRequest:link SucceedSelector:@selector(UpOderData:)];
    
}

-(void)UpOderData:(NSMutableDictionary*)dict {
    
    self.myTableView.delegate  = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"GuestTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.myTableView reloadData];
    
    
    NSLog(@"dict:%@",dict);
    
    self.MyDataArray = [NSMutableArray array];
    
    NSMutableArray * orders = [dict objectForKey:@"orders"];
    
    for (int i = 0; i<orders.count;i++) {
        NSMutableDictionary * orderDict = [orders objectAtIndex:i];
        OrderModel * model = [[OrderModel alloc]init];
        model.orderId = [orderDict objectForKey:@"orderId"];
        model.createAcc = [orderDict objectForKey:@"createTime"];
        model.createTime = [orderDict objectForKey:@"createTime"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.MyDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell" ;
    
    GuestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OrderModel * model = [self.MyDataArray objectAtIndex:indexPath.row];
    productModel * newModel = [model.products objectAtIndex:0];
    
    NSString * Link = [NSString stringWithFormat:@"http://server.mallteem.com/%@",newModel.productImg];
    
    UIImage * image =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:Link];
    if (image==nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * NewImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            
            [[SDWebImageManager sharedManager] saveImageToCache:NewImage forURL:[NSURL URLWithString:Link]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.productIMG.image = NewImage;
                [cell layoutSubviews];
            });
        });
    } else {
        cell.productIMG.image = image;
    }

    // Configure the cell...
    
    
    cell.productTime.text = [NSString stringWithFormat:@"下单时间:%@",model.createTime];
    cell.productNumber.text = [NSString stringWithFormat:@"订单号:%@", model.orderId];
    cell.productMoney.text = [NSString stringWithFormat:@"￥%.2f",[model.price floatValue]];
    
    NSMutableArray *productsNameArray = [NSMutableArray array];
    [model.products enumerateObjectsUsingBlock:^(productModel * pModel, NSUInteger idx, BOOL *stop) {
        [productsNameArray addObject:pModel.productName];
    }];
    
    cell.productUserName.text = [productsNameArray componentsJoinedByString:@", "]; // 现在修改为产品的名称
    cell.productStatusLabel.text = [OrderInfoDetailStatusFactory stringWithOrderDetailStatus:model.status];
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}

#pragma mark - Table view delegate
//告诉你那一行被点击了
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel * model = [self.MyDataArray objectAtIndex:indexPath.row];
    OrderInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderInfoViewController"];
    vc.myModel = model;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector {
    
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
                [_header endRefreshing];
                [_footer endRefreshing];;
            } else {
                
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
                
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
        
    });
    
}
#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    if (refreshView == _header) { // 下拉刷新
        NSLog(@"下拉刷新");
        pageNum = 1;
        if ([queue operationCount] > 0) {
            
            [queue cancelAllOperations];
        }
        
        [self performSelector:@selector(upOrderData) withObject:nil afterDelay:0.5];
        
        
    }else if (refreshView == _footer) { // 上拉加载更多
        
        if (pageNum * 20 < totalCount) {
            
            pageNum++;
            if ([queue operationCount] > 0) {
                
                [queue cancelAllOperations];
            }
            [self performSelector:@selector(upOrderData) withObject:nil afterDelay:0.5];
            
        }
        else{
            
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
- (void)dealloc
{
    [ _header free ];
    [ _footer free ];
}

@end
