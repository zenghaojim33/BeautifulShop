//
//  OrderInfoViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-13.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "OrderInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImage/SDWebImageManager.h"
#import "OrderInfoModel.h"
#import "ChattingRecordsViewController.h"
#import "GoodsInfoViewController.h"
#import "UIColorFactory.h"

@interface OrderInfoViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    OrderInfoCellDelegate
>
{
    OrderInfoModel * _orderInfoModel;
}
@property (strong, nonatomic) IBOutlet UIButton *emsInfoBtn;
@property (strong, nonatomic) IBOutlet UILabel *orderNo;
@property (strong, nonatomic) IBOutlet UILabel *status;
@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (strong, nonatomic) IBOutlet UILabel *addLabel;
@property (strong, nonatomic) IBOutlet UILabel *linkMan;
@property (strong, nonatomic) IBOutlet UILabel *zipCodeLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *PhoneButton;
//@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *mySCView;

@end

@implementation OrderInfoViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.title = @"订单详情";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
}

//订单详情改动：
//http://server.mallteem.com/json/index.ashx?aim=orderdetail&orderid=订单id&userid=购买者id（在获取订单列表中的buyer字段）
- (void)upData {
    NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=orderdetail&orderid=%@&userid=%@",self.myModel.orderId, self.myModel.buyer];
    NSLog(@"%@", link);
    [self dataRequest:link SucceedSelector:@selector(upData:)];
    
}

- (void)upData:(NSMutableDictionary*)dict {
    NSLog(@"dict(OrderInfo):%@",dict);
    
    _orderInfoModel = [[OrderInfoModel alloc] initWithDictionary:dict[@"data"]];
    [self showOrderInfoViewForModel:_orderInfoModel];
}

- (void)showOrderInfoViewForModel:(OrderInfoModel *)model {
    self.zipCodeLabel.text = model.postAddressModel.zipcode;
    self.orderNo.text = [NSString stringWithFormat:@"%@" ,model.orderId];
    
    self.status.text = model.statusString;
    
//    float price = [model.price floatValue];

    
    self.createTime.text = model.createDate;
    
//    self.createAcc.text = [NSString stringWithFormat:@"%@",model.createAcc];
    
    self.addLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.postAddressModel.province,model.postAddressModel.city,model.postAddressModel.area,model.postAddressModel.address];
    
    self.linkMan.text = model.postAddressModel.linkman;
    
    [self.PhoneButton setTitle:model.postAddressModel.phone forState:UIControlStateNormal];
    
    [self.mySCView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+190+62+40+90)];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"OrderInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.myTableView reloadData];
    
    if (_orderInfoModel.status == OrderStatusNotPaying) {
        _emsInfoBtn.userInteractionEnabled = NO;
        [_emsInfoBtn setTitleColor:[UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable] forState:UIControlStateNormal];
        _emsInfoBtn.layer.borderColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable].CGColor;
    } else {
        _emsInfoBtn.userInteractionEnabled = YES;
        [_emsInfoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _emsInfoBtn.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }
    
    [_emsInfoBtn addTarget:self action:@selector(emsInfoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

// 物流按钮点击事件
- (void)emsInfoBtnClicked:(UIButton *)button {
    GoodsInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsInfoViewController"];
    vc.url = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@", _orderInfoModel.expressName, _orderInfoModel.expressNo];
    vc.title = @"快递查询";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)TouchPhoneButton:(UIButton *)sender {
    if (sender.titleLabel.text.length != 0) {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:sender.titleLabel.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        av.tag = 99;
        [av show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 99&&buttonIndex ==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertView.message]]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 重新配置物流信息按钮
    _emsInfoBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _emsInfoBtn.layer.borderWidth = 1.0f;
    _emsInfoBtn.layer.cornerRadius = 3.0f;
    _emsInfoBtn.layer.masksToBounds = YES;
    
    [self upData];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _orderInfoModel.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    OrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    OrderInfoProductsModel * model = [_orderInfoModel.productArray objectAtIndex:indexPath.row];
    
    cell.productName.text = model.productName;
    cell.size.text = model.size;
    
    NSString * Link = [NSString stringWithFormat:@"http://server.mallteem.com/%@",model.productImg];
    
    UIImage * image =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:Link];
    if (image==nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * NewImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
            [[SDWebImageManager sharedManager] saveImageToCache:NewImage forURL:[NSURL URLWithString:Link]];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.productImg.image = NewImage;
                [cell layoutSubviews];
            });
        });
    } else {
        cell.productImg.image = image;
    }
    

    cell.price.text = [NSString stringWithFormat:@"¥%.2fx%d",model.price,model.count];
    cell.allPrice.text = model.statusString;
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    cell.delegate = self;
    
    cell.tag = indexPath.row;
    cell.WLButton.userInteractionEnabled = NO;
    [cell.WLButton setBackgroundColor:[UIColor grayColor]];

    return cell;
}

- (void)setEmsForTag:(int)tag {
    NSLog(@"tag:%d",tag);
//    OrderInfoProductsModel * model = [_orderInfoModel.productArray objectAtIndex:tag];
    
//    NSString * link = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",model.emsName,model.emsNum];
//    
//    link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    ChattingRecordsViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChattingRecordsViewController"];
//    
//    vc.title = @"物流查询";
//    vc.url = link;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)setBGViewForTag:(int)tag
{
    OrderInfoProductsModel * model = [_orderInfoModel.productArray objectAtIndex:tag];
    
    GoodsInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsInfoViewController"];
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    vc.url = [NSString stringWithFormat:@"http://web.mallteem.com/_ProductDetail.aspx?id=%@&ShopId=%@",model.productId,shareInfo.userModel.userID];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:vc animated:YES];
}
//#pragma mark - Table view delegate
////告诉你那一行被点击了
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
// 
//
//}


#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector {
    
  MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
            
            [HUD hide:YES afterDelay:0.1];
            
        });
        
    });
    
}


@end
