//
//  myIncomeViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-11.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "myIncomeViewController.h"
#import "myProfitModel.h"
#import "JSONData.h"
#import "myInComeTableViewCell.h"
#import "AFNetworking.h"
#import "BranchTableViewCell.h"
#import "ChangeInfoViewController.h"
#import "BWMMBProgressHUD.h"

#define anim_time 0.5
#define Vheight 335

@interface myIncomeViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate
>
{
    ShareInfo * shareInfo;
    NSString * type;//分润类型
    
    
    BOOL isAnimating;
}

@property (strong, nonatomic) IBOutlet UILabel *PriceLabel1;
@property (strong, nonatomic) IBOutlet UILabel *PriceLabel2;
@property (strong, nonatomic) IBOutlet UILabel *PriceLabel3;
@property (strong, nonatomic) IBOutlet UILabel *PriceLabel4;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableArray * myProfitArray;
@property (strong, nonatomic) IBOutlet UIButton *titleButton1;
@property (strong, nonatomic) IBOutlet UIButton *titleButton2;
@property (strong, nonatomic) IBOutlet UIButton *titleButton3;
@property (strong, nonatomic) IBOutlet UIButton *titleButton4;
@property(strong,nonatomic)NSMutableArray * buttonArray;

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;


@property (strong, nonatomic) IBOutlet UIView *View1;
@property (strong, nonatomic) IBOutlet UIView *NView1;
@property (strong, nonatomic) IBOutlet UIView *NView2;
@property (strong, nonatomic) IBOutlet UIView *NView3;
@property (strong, nonatomic) IBOutlet UIView *NView4;
@property (strong, nonatomic) IBOutlet UIView *NView5;
@property (strong, nonatomic) IBOutlet UIView *ButtonView;
@property (strong, nonatomic) IBOutlet UIView *TBView;
@property (weak, nonatomic) IBOutlet UIButton *spreadYourShopView;


@end

@implementation myIncomeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)GetData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    shareInfo = [ShareInfo shareInstance];
    
    
    //创建一个请求地址
    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=myprofit"];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //修改请求 方式  ****以下为post请求
    
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"userid=%@&type=%@&size=20&index=%d",shareInfo.userModel.userID,type,1] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
//    NSError *error=nil;
    NSOperationQueue * queue = [[NSOperationQueue alloc]init];
    //发出请求 并且得到响应数据
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data==nil)
        {
            
            
        }else{
            
            NSLog(@"data不等于空");
            
            NSError *error=nil;
            
            id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingAllowFragments
                                                            error:&error];
            
            
            NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self UpData:dict];

            });
        }
        }];
    
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"myInComeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
//==================ANSON==========下面是下面的table的方法"
    if([type isEqualToString:@"2"]){
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString * url2 = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=fendianprofit&userid=%@&pagesize=10&pageindex=1",shareInfo.userModel.userID];
    
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url2 parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _myProfitArray = [NSMutableArray arrayWithArray:responseObject[@"Branchs"]];
        if (_myProfitArray.count>0){
            
            
            
        dispatch_async(dispatch_get_main_queue(), ^{
            [_myTableView reloadData];
            _spreadYourShopView.hidden=YES;
        });
        }else if (_myProfitArray.count==0){
            _spreadYourShopView.hidden=NO;
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    
    
    

}
- (void)UpData:(NSMutableDictionary*)dict
{
    NSLog(@"dict:%@",dict);
    
    self.PriceLabel1.text = [NSString stringWithFormat:@"￥%@.00",[dict objectForKey:@"styleSum"]];

    self.PriceLabel2.text = [NSString stringWithFormat:@"￥%@.00",[dict objectForKey:@"recommentSum"]];

    self.PriceLabel3.text = [NSString stringWithFormat:@"￥%@.00",[dict objectForKey:@"shoopSum"]];

    self.PriceLabel4.text = [NSString stringWithFormat:@"￥%@.00",[dict objectForKey:@"allSum"]];
    
    //判断是否拥有分店
    
    
    
    
    
    
    NSMutableArray * array  = [dict objectForKey:@"myProfit"];
    
    for (int i = 0; i<array.count; i++)
    {
        NSMutableDictionary * newDict = [array objectAtIndex:i];
        myProfitModel *model = [[myProfitModel alloc]init];
        
       model.userId = [newDict objectForKey:@"userId"];
       model.time = [newDict objectForKey:@"time"];
       model.allPrice = [newDict objectForKey:@"allPrice"];
       model.pont = [newDict objectForKey:@"pont"];
       model.profit = [newDict objectForKey:@"profit"];
       model.remark = [newDict objectForKey:@"remark"];
    
        [self.myProfitArray addObject:model];
        
    }
    
    if (self.myProfitArray.count == 0)
    {
            [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
        
//        //测试。
//        for (int i = 0 ; i<30; i++) {
//            myProfitModel * model = [[myProfitModel alloc]init];
//            
//            model.userId = [NSString stringWithFormat:@"%d",i];
//            model.time = [NSString stringWithFormat:@"2014-11-%d 11:30:23",i];
//            model.allPrice = [NSString stringWithFormat:@"%.2d",rand()%999];
//            model.pont = [NSString stringWithFormat:@"%d%%",rand()%100];
//            model.profit = [NSString stringWithFormat:@"%d%%",rand()%100];
//            model.remark = @"分润类型说明";
//            
//            [self.myProfitArray addObject:model];
//        }
    }
    
    [self.myTableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([type isEqualToString:@"2"])
    {
        return _myProfitArray.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString * CellIdentifier2 = @"Branch";

    if ([type isEqualToString:@"2"]) {
        BranchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (!cell){
            cell = [[BranchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            
            
        }
        NSDictionary * dataDict = [_myProfitArray objectAtIndex:indexPath.row];
        
        cell.BranchName.text = dataDict[@"BranchName"];
        cell.Phone.text = dataDict[@"Phone"];
        NSString * allprofit = [NSString stringWithFormat:@"￥%@",dataDict[@"AllProfit"]];
        cell.AllProfit.text = allprofit;
        return cell;
    } else {
        
        myInComeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[myInComeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        //
        //
        //    myProfitModel * model = [self.myProfitArray objectAtIndex:indexPath.row];
        //    cell.remark.text = model.remark;
        //    cell.allPrice.text = [NSString stringWithFormat:@"￥:%@",model.allPrice];
        //    cell.pont.text = model.pont;
        //    cell.profit.text = model.profit;
        //    cell.time.text = model.time;
        return cell;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"我的收入";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    self.myProfitArray = [NSMutableArray array];
    
    type =@"-1";
    
    [self GetData];
    
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"myInComeTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.myTableView registerNib:[UINib nibWithNibName:@"BranchTableViewCell" bundle:nil] forCellReuseIdentifier:@"Branch"];
    
    
    self.buttonArray = [NSMutableArray array];
    
    [self.buttonArray addObject:self.titleButton1];
    [self.buttonArray addObject:self.titleButton2];
    [self.buttonArray addObject:self.titleButton3];
    [self.buttonArray addObject:self.titleButton4];
    
    
    
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480.0)) {
        //3.5寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+254+84)];
    }else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0)){
        //4.0寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+254)];
    }else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667.0)){
        //4.7寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+254)];
    }else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736.0)){
        //5.5寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+254)];
    }else{
        //ipad
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+254+84)];
    }
    
    
    
    
    [self.myScrollView setDelegate:self];

    
    CGRect frame = self.myTableView.frame;
    frame.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    
    self.myTableView.frame = frame;
    
    
    
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TouchTitleButton:(UIButton *)sender {
    
    for (int i = 0; i<self.buttonArray.count; i++)
    {
        UIButton * button = [self.buttonArray objectAtIndex:i];
        
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [sender setTitleColor:[UIColor colorWithRed:205/255.0 green:62/255.0 blue:123/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    switch (sender.tag) {
        case 0:
            type = @"-1";
            
            break;
        case 1:
            type = @"2";
            break;
        case 2:
            type = @"3";
            break;
        case 3:
            type = @"4";
            break;
            
        default:
            break;
    }
    
    _myTableView.hidden = NO;
    _spreadYourShopView.hidden=YES;
    [self GetData];
    
}
- (IBAction)TouchBankButton:(id)sender {
    
    //跳转到输入银行账户
    ChangeInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
    vc.isChange = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击马上推广
- (IBAction)spreadYourShop:(id)sender {
    
   UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPromotionViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

@end
