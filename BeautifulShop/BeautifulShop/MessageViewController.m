//
//  MessageViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MessageViewController.h"
#import "MyMessageTableViewCell.h"
#import "MessageModel.h"
#import "MessageInfoViewController.h"
#import "UITableView+BWMTableView.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray * myDataArray;
@end

@implementation MessageViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"我的消息";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    self.myDataArray = [NSMutableArray array];
    [self UpDta];
}
- (void)UpDta
{
    NSString * link = [NSString stringWithFormat:MessageCentre,1];
    [self dataRequest:link SucceedSelector:@selector(UpData:)];
}
- (void)UpData:(NSMutableDictionary*)dict
{
    NSLog(@"dict:%@",dict);
    
    NSMutableArray * array = [dict objectForKey:@"news"];

    for (int i = 0; i<array.count; i++)
    {
        NSMutableDictionary * dict = [array objectAtIndex:i];
        MessageModel * model = [[MessageModel alloc]init];
        model.messageID = [dict objectForKey:@"id"];
        model.title = [dict objectForKey:@"title"];
        model.time = [dict objectForKey:@"time"];
        
        [self.myDataArray addObject:model];
    }
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
  
         NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
         [ud setInteger:shareInfo.userModel.msgNumber forKey:@"msgNumber"];

    
    [self.myTableView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if(array.count == 0) {
        [self.myTableView bwm_addLabelToCenterWithText:@"暂时没有收到任何信息..."];
    } else {
        [self.myTableView bwm_removeView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    MessageModel * model = [self.myDataArray objectAtIndex:indexPath.row];
    cell.TitleLabel.text = model.title;
    cell.time.text = model.time;
    // Configure the cell...
    cell.BGView.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.BGView.layer.shadowOffset = CGSizeMake(1, 1);
    cell.BGView.layer.shadowOpacity = 0.2;
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageModel * model = [self.myDataArray objectAtIndex:indexPath.row];
    MessageInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageInfoViewController"];
    vc.url = [NSString stringWithFormat:@"http://server.mallteem.com/json/news.htm?id=%@",model.messageID];
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
        
        NSString *link = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",link);
        id jsonObject = [JSONData JSONDataValue:link];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = nil;
            if(jsonObject==nil)
            {
                
                message = @"获取数据失败请检查你的网络";
                [self showAlertViewForTitle:message AndMessage:nil];
            }
            else
            {
                
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
                
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
