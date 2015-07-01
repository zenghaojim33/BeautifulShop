//
//  myIncome2ViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-21.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "myIncome2ViewController.h"
#import "myProfitModel.h"
#import "myInComeTableViewCell.h"
#import "ChangeInfoViewController.h"
#import "BWMMBProgressHUD.h"

#define anim_time 0.5
#define Vheight 335
@interface myIncome2ViewController ()
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
@property (strong, nonatomic) IBOutlet UIView *NView4;
@property (strong, nonatomic) IBOutlet UIView *NView5;
@property (strong, nonatomic) IBOutlet UIView *ButtonView;
@property (strong, nonatomic) IBOutlet UIView *TBView;


@end

@implementation myIncome2ViewController
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
    NSError *error=nil;
    
    //发出请求 并且得到响应数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:&error];
    
    
    if(data==nil)
    {
        
        
    }else{
        
        NSLog(@"data不等于空");
        
        NSError *error=nil;
        
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        
        
        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
        
        
        
        [self performSelector:@selector(UpData:) withObject:dict afterDelay:0.2f];
        
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
- (void)UpData:(NSMutableDictionary*)dict
{
    NSLog(@"dict:%@",dict);
    
    self.PriceLabel1.text = [NSString stringWithFormat:@"￥%@.00",[dict objectForKey:@"styleSum"]];
    
    self.PriceLabel2.text = [NSString stringWithFormat:@"￥%@.00",[dict objectForKey:@"recommentSum"]];
    
    self.PriceLabel4.text = [NSString stringWithFormat:@"￥%@.00",[dict objectForKey:@"allSum"]];
    
    
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
    return self.myProfitArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    myInComeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[myInComeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    myProfitModel * model = [self.myProfitArray objectAtIndex:indexPath.row];
    cell.remark.text = model.remark;
    cell.allPrice.text = [NSString stringWithFormat:@"￥:%@",model.allPrice];
    cell.pont.text = model.pont;
    cell.profit.text = model.profit;
    cell.time.text = model.time;
    // Configure the cell...
    
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    self.buttonArray = [NSMutableArray array];
    
    [self.buttonArray addObject:self.titleButton1];
    [self.buttonArray addObject:self.titleButton2];
    [self.buttonArray addObject:self.titleButton3];
    [self.buttonArray addObject:self.titleButton4];
    
    
    
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 480.0)) {
        //3.5寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200+84)];
    }else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0)){
        //4.0寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200)];
    }else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 667.0)){
        //4.7寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200)];
    }else if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736.0)){
        //5.5寸
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200)];
    }else{
        //ipad
        [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+200+84)];
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
    
    [self GetData];
}
- (IBAction)TouchBankButton:(id)sender {
    
    ChangeInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
    vc.isChange = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
