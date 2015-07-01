//
//  SetViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "SetViewController.h"
#import "ChangeInfoViewController.h"
#import "aboutBeautifulShopViewController.h"
#import "assistanceViewController.h"
#import "UIView+BWMExtension.h"
#import "BWMEditInfoTableViewController.h"
#import "BeautifulShop-Swift.h"
#import "BWMSystemConfigurationManager.h"

@interface SetViewController ()
<
UIActionSheetDelegate
>
{
   BOOL isBang;//是否绑定老板
}
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
//@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *button5;
@property (strong, nonatomic) IBOutlet UILabel *BossName;
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *newsVersionLabel;

@end

@implementation SetViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"设定";
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    if (shareInfo.userModel.userType == 3) {
        //是老板
        self.button1.alpha = 0;
        
    }else{
    
    
    if (shareInfo.userModel.parentName.length ==0) {
        NSLog(@"当前没有绑定老板");
        isBang = NO;
    } else {
        isBang = YES;
        NSLog(@"当前已经绑定老板");
        self.BossName.text = [NSString stringWithFormat:@"(%@)",shareInfo.userModel.parentName];
    }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 显示当前版本
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本：v %@", [BWMSirenManager currentVersion]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *newVer = [BWMSirenManager newVersion];
        int newVersion = [[newVer stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        int currentVersion = [[[BWMSirenManager currentVersion] stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newVersion > currentVersion) {
                self.newsVersionLabel.hidden = NO;
                self.newsVersionLabel.text = [NSString stringWithFormat:@"最新版本：v %@", newVer];
            } else {
                self.newsVersionLabel.hidden = YES;
            }
        });
    });
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    if (shareInfo.userModel.userType == 3)
    {
        //是老板

        self.button1.alpha = 0;
        self.BossName.alpha = 0;
        [self.button2 removeFromSuperview];
        self.button2 = [[UIButton alloc]initWithFrame:CGRectMake(16, 21, self.view.frame.size.width-32, 37)];
        [self.button2 setBackgroundColor:[UIColor whiteColor]];
        [self.button2 setTitle:@"编辑我的资料" forState:UIControlStateNormal];
        [self.button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button2 addTarget:self action:@selector(GoToTheChangeInfo:) forControlEvents:UIControlEventTouchUpInside];
        self.button2.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.button2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.button2 setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [self.view addSubview:self.button2];
        [self.button3 removeFromSuperview];
        self.button3 = [[UIButton alloc]initWithFrame:CGRectMake(16, 66, self.view.frame.size.width-32, 37)];
        [self.button3 setBackgroundColor:[UIColor whiteColor]];
        [self.button3 setTitle:@"关于美店" forState:UIControlStateNormal];
        [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.button3 addTarget:self action:@selector(BeautifulShop:) forControlEvents:UIControlEventTouchUpInside];
        self.button3.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.button3 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.button3 setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [self.view addSubview:self.button3];
        
        [self.button5 removeFromSuperview];
        self.button5 = [[UIButton alloc]initWithFrame:CGRectMake(16, 116, self.view.frame.size.width-32, 37)];
        [self.button5 setBackgroundColor:[UIColor whiteColor]];
        [self.button5 setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.button5 setTitleColor:[UIColor colorWithRed:205/255.0 green:62/255.0 blue:123/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.button5 addTarget:self action:@selector(Out:) forControlEvents:UIControlEventTouchUpInside];
        self.button5.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [self.button5 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self.view addSubview:self.button5];
        
//        [self.button3 removeFromSuperview];
//        self.button3 = [[UIButton alloc]initWithFrame:CGRectMake(16, 66, self.view.frame.size.width-32, 37)];
//        [self.button3 setBackgroundColor:[UIColor whiteColor]];
//        [self.button3 setTitle:@"关于靓店" forState:UIControlStateNormal];
//        [self.button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.button3 addTarget:self action:@selector(BeautifulShop:) forControlEvents:UIControlEventTouchUpInside];
//         self.button3.titleLabel.font = [UIFont systemFontOfSize:16.0];
//        [self.button3 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [self.view addSubview:self.button3];
//        
//        [self.button4 removeFromSuperview];
//        self.button4 = [[UIButton alloc]initWithFrame: CGRectMake(16, 111, self.view.frame.size.width-32, 37)];
//        [self.button4 setBackgroundColor:[UIColor whiteColor]];
//        [self.button4 setTitle:@"新手帮助" forState:UIControlStateNormal];
//        [self.button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.button4 addTarget:self action:@selector(assistance:) forControlEvents:UIControlEventTouchUpInside];
//         self.button4.titleLabel.font = [UIFont systemFontOfSize:16.0];
//        [self.button4 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        [self.view addSubview:self.button4];
//        
//        [self.button5 removeFromSuperview];
//        self.button5 = [[UIButton alloc]initWithFrame:CGRectMake(16, 156, self.view.frame.size.width-32, 37)];
//        [self.button5 setBackgroundColor:[UIColor whiteColor]];
//        [self.button5 setTitle:@"退出登录" forState:UIControlStateNormal];
//        [self.button5 setTitleColor:[UIColor colorWithRed:205/255.0 green:62/255.0 blue:123/255.0 alpha:1.0] forState:UIControlStateNormal];
//        [self.button5 addTarget:self action:@selector(Out:) forControlEvents:UIControlEventTouchUpInside];
//         self.button5.titleLabel.font = [UIFont systemFontOfSize:16.0];
//        [self.button5 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//        [self.view addSubview:self.button5];
        
    
    }
    
    [@[_button1, _button2, _button3, _button5] enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        [btn drawingDefaultStyleShadow];
    }];
}

- (IBAction)Out:(UIButton *)sender {
    
//    UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"是否退出当前账号?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    
//    av.tag = 888;
//    
//    [av show];
    
    UIActionSheet * actionSheet =
    [[UIActionSheet alloc]initWithTitle:nil
                               delegate:nil
                      cancelButtonTitle:@"取消"
                 destructiveButtonTitle:@"退出"
                      otherButtonTitles:nil];
    actionSheet.delegate=self;//有时不调用时需要输入这句话
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    if (buttonIndex==0) {
        [[BWMSystemConfigurationManager sharedSystemConfigurationManager] setLogOutState];
        UINavigationController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartViewNav"];
        
        vc.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:vc animated:YES completion:nil];
//        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{ NSLog(@"您选择了取消");}
};
#pragma mark 新手帮助
- (IBAction)assistance:(UIButton *)sender {
    
    assistanceViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"assistanceViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 关于美店
- (IBAction)BeautifulShop:(UIButton *)sender {
    aboutBeautifulShopViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutBeautifulShopViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 编辑我的资料
- (IBAction)GoToTheChangeInfo:(UIButton *)sender {
    ChangeInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
    vc.isChange = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 解除/绑定老板
- (IBAction)BindingBoss:(UIButton *)sender {
    ShareInfo *shareInfo = [ShareInfo shareInstance];
    
    if (isBang == YES) {
//        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"解绑店主" message:@"确定解绑店主?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        av.tag =889;
//        [av show];
    } else {
        
        if (shareInfo.userModel.userType == 3) {
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"当前用户必须是发型师账号" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        } else {
            UIViewController * view = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeViewController"];
            [self.navigationController pushViewController:view animated:YES];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==888) {
        if (buttonIndex==1) {
            UINavigationController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StartViewNav"];
            
            vc.modalTransitionStyle =UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
    
    if (alertView.tag == 889) {
        if (buttonIndex == 1) {
            [self Unpinless];
        }
    }
}

-(void)Unpinless {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    //创建一个请求地址
    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=linkbos"];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //修改请求 方式  ****以下为post请求
    
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"userid=%@&parent=",shareInfo.userModel.userID] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
    
    NSLog(@"%@", [NSString stringWithFormat:@"userid=%@&parent=",shareInfo.userModel.userID]);
    
    //发出请求 并且得到响应数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:Nil];
    
    if(data==nil) {
        
        NSString*  message = @"获取数据失败请检查你的网络";
        
        [self showAlertViewForTitle:nil AndMessage:message];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } else {
        
        NSLog(@"data不等于空");
        
        NSError *error=nil;
        
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        
        
        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
        
        
        [self performSelector:@selector(UpData2:) withObject:dict afterDelay:0.2f];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }
}

-(void)UpData2:(NSMutableDictionary*)dict {
    NSLog(@"%@", dict);
    NSLog(@"%@", dict[@"error"]);
    
    NSString * status = [dict objectForKey:@"status"];
    int statusInt = [status intValue];
    if (statusInt==true) {
        UIAlertView * av= [[UIAlertView alloc]initWithTitle:@"解除绑定成功" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        
        self.BossName.text = @"";
        [ShareInfo shareInstance].userModel.parentId = nil;
        [ShareInfo shareInstance].userModel.parentName = nil;
        isBang = NO;
    } else {
        NSString * error = [dict objectForKey:@"error"];
        
        UIAlertView * av= [[UIAlertView alloc]initWithTitle:@"解除绑定失败" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
    }
}

#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}

@end
