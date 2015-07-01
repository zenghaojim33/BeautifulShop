//
//  BranksViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-15.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "BranksViewController.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "BWMBankCoder.h"
#import "BWMMBProgressHUD.h"

@interface BranksViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isSearch;
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextField *MyTF;
@property(nonatomic,strong)NSArray* BanksArray;
@property(nonatomic,strong)NSMutableArray*searchArray;
@end

@implementation BranksViewController

+ (instancetype)viewController {
    return [UIStoryboard initVCOnMainStoryboardWithID:@"BranksViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.title = @"选择银行";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    
    
    isSearch = NO;
    self.navigationItem.backBarButtonItem = backItem;
    
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (IBAction)MyTextFieldDidEndOnExit:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.text.length==0)
    {
        isSearch = NO;
        [self.myTableView reloadData];
        
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:1.0f];
    }else{
        isSearch = YES;
        self.searchArray = [NSMutableArray array];
        
        for (int i = 0; i<self.BanksArray.count; i++)
        {
            NSString * bank = [self.BanksArray objectAtIndex:i];
            NSRange range = [bank rangeOfString:textField.text];
            if (range.location!=NSNotFound) {
                NSLog(@"Yes");
                [self.searchArray addObject:bank];
            }else {
                NSLog(@"NO");
            }
            
        }
        
        [self.myTableView reloadData];
        
        
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadSuccessMsg toView:self.view hideAfter:1.0f];
    }
}
#pragma 银行列表
-(void)initView {
    // 读取银行列表
    self.BanksArray = [BWMBankCoder banksNameArray];
    
    [self.view addSubview:self.myTableView];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    
    [self.myTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearch == YES) {
        return self.searchArray.count;
    } else {
        return self.BanksArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (isSearch==YES) {
    cell.textLabel.text = [self.searchArray objectAtIndex:indexPath.row];
    }else{
    cell.textLabel.text = [self.BanksArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isSearch == YES){
    [self.delegate setBrandName:[self.searchArray objectAtIndex:indexPath.row]];
    }else{
    [self.delegate setBrandName:[self.BanksArray objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

@end
