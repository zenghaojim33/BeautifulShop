//
//  GuestMessageModelViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GuestMessageModelViewController.h"
#import "GuestMessageModelCell.h"
#import "GuestMessageModel.h"
#import "ChattingRecordsViewController.h"
@interface GuestMessageModelViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation GuestMessageModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"GuestMessageModelCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.myTableView reloadData];
    
    self.title = @"聊天记录";
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.MyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    GuestMessageModelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    
    GuestMessageModel * model = [self.MyArray objectAtIndex:indexPath.row];

    int Count = model.Count;
    
    if (Count==0) {
        cell.Count .alpha = 0;
    }else{
        [cell.Count setTitle:[NSString stringWithFormat:@"%d",Count] forState:UIControlStateNormal];
    }
    
    cell.msg.text = model.msg;
    cell.nickName.text = model.nickName;
    
    cell.ts.text = model.ts;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    // Configure the cell...
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view delegate
//告诉你那一行被点击了
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuestMessageModel * model = [self.MyArray objectAtIndex:indexPath.row];

    
    ShareInfo *shareInfo = [ShareInfo shareInstance];
    NSString * shopkeeperid = shareInfo.userModel.userID;
    NSString * told = @"1";
//    NSString * nickname = shareInfo.userModel.name;
    
//    NSString * link = [NSString stringWithFormat:@"http://183.60.132.104:8089/?customerId=%d&shopkeeperId=%@&toId=%@&nickName=%@",model.customerId,shopkeeperid,told,nickname];
    
    NSString * link = [NSString stringWithFormat:@"http://183.60.132.104:8089/?customerId=%d&shopkeeperId=%@&customerName=%@&shopkeeperName=%@&toId=%@",model.customerId,shopkeeperid,model.nickName,shareInfo.userModel.name,told];
    
    link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ChattingRecordsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChattingRecordsViewController"];
    vc.url = link;
    vc.title = @"聊天记录";
    [self.navigationController pushViewController:vc animated:YES];


}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
