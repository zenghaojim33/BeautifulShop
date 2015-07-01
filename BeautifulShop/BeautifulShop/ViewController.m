//
//  ViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-9-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "ViewController.h"
#import "BWMMyPurseViewController.h"
#import "BWMRequestCenter.h"
#import "BWMAlertViewFactory.h"
#import "SalesManagementViewController.h"
#import "BeautifulShop-Swift.h"
#import "BWMMyShopViewController.h"
#import "BWMPutawayViewController.h"
#import "BWMWelfareViewController.h"
#import "BWMSpecialSellingViewController.h"

@interface ViewController ()
<
    UIScrollViewDelegate
>
{
    ShareInfo * shareInfo;
    
    long int nowSilogin;
    long int nowmsgNumber;
    long int noworderNumber;
    long int nowuserNumber;
    long int nowproductNumber;
    
    UIButton * productNumberButton;
    UIButton * userNumberButton;
    UIButton * orderNumberButton;
    
    IBOutlet UIButton *_bossButton;
    
    IBOutlet UIButton *_customerNumberButton;
    IBOutlet UIButton *_ordersNumberButton;
    IBOutlet UIButton *_productNumberButton;
}

@property(strong,nonatomic)UIPageControl* pageControl;
#define NowWidth self.view.frame.size.width
#define NowHeigth self.view.frame.size.height
@property (strong, nonatomic) IBOutlet UIButton *MessageBth;
@property (strong, nonatomic) IBOutlet UIButton *setBth;
@property (strong, nonatomic) IBOutlet UIButton *MeagessButton;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [self initNavigationBar];
    
    self.MeagessButton.alpha = 0;
    //获取状态
    [self CheckloginData];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

-(void)CheckloginData {
    shareInfo = [ShareInfo shareInstance];
    NSString * link = [NSString stringWithFormat:Checklogin,shareInfo.userModel.userID,shareInfo.userModel.udid];
    [self dataRequest:link SucceedSelector:@selector(CheckloginData:)];
}

-(void)CheckloginData:(NSMutableDictionary*)dict {
    NSLog(@"dict:%@",dict);
    // 是否绑定
    shareInfo.userModel.siLogin = [[dict objectForKey:@"siLogin"]intValue];
    
    //信息数
    shareInfo.userModel.msgNumber = [[dict objectForKey:@"msgNumber"]intValue];
    //订单数
    shareInfo.userModel.orderNumber = [[dict objectForKey:@"orderNumber"]intValue];
    //客户数
    shareInfo.userModel.userNumber = [[dict objectForKey:@"userNumber"]intValue];
    //产品数
    shareInfo.userModel.productNumber = [[dict objectForKey:@"productNumber"]intValue];
    
    
    //跟本地判断
    //UserDefaults 用来保存数据(应用的配置信息)
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    /************************************************************************************************/
    
    
    long int siLogin = [ud integerForKey:@"siLogin"];
    if (!siLogin) {
        NSLog(@"当前本地没有保存是否绑定");
        [ud setInteger:shareInfo.userModel.siLogin forKey:@"siLogin"];
    } else {
        NSLog(@"判断是否绑定");
        NSLog(@"本地:%ld  服务器:%d",siLogin,shareInfo.userModel.siLogin);
        
        if (shareInfo.userModel.siLogin > siLogin) {
           nowSilogin = shareInfo.userModel.siLogin - siLogin;
            NSLog(@"nowSilogin:%ld",nowSilogin);
        } else {
            NSLog(@"本地与服务器相同");
        }
        
    }
    
    /************************************************************************************************/
    
    long int msgNumber = [ud integerForKey:@"msgNumber"];
    if (!msgNumber) {
        NSLog(@"当前本地没有保存信息数");
        if (shareInfo.userModel.msgNumber == 0 ) {
              [ud setInteger:shareInfo.userModel.orderNumber forKey:@"msgNumber"];
        } else {
            [self.MeagessButton setTitle:[NSString stringWithFormat:@"%d",shareInfo.userModel.msgNumber] forState:UIControlStateNormal];
            self.MeagessButton.alpha = 1;
        }
    } else {
        NSLog(@"判断信息数");
        NSLog(@"本地:%ld  服务器:%d",msgNumber,shareInfo.userModel.msgNumber);
        
        if (shareInfo.userModel.msgNumber > msgNumber) {
            nowmsgNumber = shareInfo.userModel.msgNumber - msgNumber;
            NSLog(@"nowmsgNumber:%ld",nowmsgNumber);
            
            [self.MeagessButton setTitle:[NSString stringWithFormat:@"%ld",nowmsgNumber] forState:UIControlStateNormal];
            self.MeagessButton.alpha = 1;
        } else {
            NSLog(@"本地与服务器相同");
        }
    }
    
    
    /************************************************************************************************/

    long int orderNumber =  [ud integerForKey:@"orderNumber"];
    if (!orderNumber) {
        NSLog(@"当前本地没有保存订单数");
        if (shareInfo.userModel.orderNumber == 0) {
            [ud setInteger:0 forKey:@"orderNumber"];
        } else {
            noworderNumber = shareInfo.userModel.orderNumber - orderNumber;
            NSLog(@"当前有%ld个订单",orderNumber);
        }
    }else{
        NSLog(@"判断订单数");
        NSLog(@"本地:%ld  服务器:%d",orderNumber,shareInfo.userModel.orderNumber);
        if (shareInfo.userModel.orderNumber > orderNumber) {
            noworderNumber = shareInfo.userModel.orderNumber - orderNumber;
            NSLog(@"noworderNumber:%ld",noworderNumber);
        } else {
            NSLog(@"本地与服务器相同");
             noworderNumber = 0;
        }
    }
    
    /************************************************************************************************/

    long int userNumber =  [ud integerForKey:@"userNumber"];
    if (!userNumber) {
        NSLog(@"当前本地没有保存客户数");
        if (shareInfo.userModel.userNumber ==0) {
            [ud setInteger:0 forKey:@"userNumber"];
        } else {
            nowuserNumber = shareInfo.userModel.userNumber - userNumber;
            NSLog(@"当前有%ld个客户",nowuserNumber);
        }
    }else{
        
        NSLog(@"判断客户数");
        NSLog(@"本地:%ld  服务器:%d",userNumber,shareInfo.userModel.userNumber);
        
        if (shareInfo.userModel.userNumber > userNumber) {
            nowuserNumber = shareInfo.userModel.userNumber - userNumber;
            NSLog(@"nowuserNumber:%ld",nowuserNumber);
        } else {
            NSLog(@"本地与服务器相同");
              nowuserNumber = 0;
        }
    }
    
    /************************************************************************************************/
    
    long int productNumber = [ud integerForKey:@"productNumber"];
    if (!productNumber) {
        NSLog(@"当前本地没有保存产品数");
        if (shareInfo.userModel.productNumber ==0) {
            [ud setInteger:0 forKey:@"productNumber"];
        } else {
            nowproductNumber = shareInfo.userModel.productNumber - productNumber;
            NSLog(@"当前有%ld个产品",nowproductNumber);
        }
        
    }else{
        
        NSLog(@"判断产品数");
        
        NSLog(@"本地:%ld  服务器:%d",productNumber,shareInfo.userModel.productNumber);
        
        if (shareInfo.userModel.productNumber > productNumber) {
            nowproductNumber = shareInfo.userModel.productNumber - productNumber;
            NSLog(@"nowproductNumber:%ld",nowproductNumber);
        } else {
            NSLog(@"本地与服务器相同");
            nowproductNumber = 0;
        }
    }

    /************************************************************************************************/
    
    if(noworderNumber > 0) {
        _ordersNumberButton.hidden = NO;
        [_ordersNumberButton setTitle:[NSString stringWithFormat:@"%ld", noworderNumber] forState:UIControlStateNormal];
    } else {
        _ordersNumberButton.hidden = YES;
    }
    
    if(nowproductNumber > 0) {
        _productNumberButton.hidden = NO;
        [_productNumberButton setTitle:[NSString stringWithFormat:@"%ld", nowproductNumber] forState:UIControlStateNormal];
    } else {
        _productNumberButton.hidden = YES;
    }
    
    if(nowuserNumber > 0) {
        _customerNumberButton.hidden = NO;
        [_customerNumberButton setTitle:[NSString stringWithFormat:@"%ld", nowuserNumber] forState:UIControlStateNormal];
    } else {
        _customerNumberButton.hidden = YES;
    }
    
    if ([ShareInfo shareInstance].userModel.userType == 3) {
        [self p_changeToBossButton];
    }
}

- (void)p_changeToBossButton {
    [_bossButton setImage:[UIImage imageNamed:@"home_icon_09_off"] forState:UIControlStateNormal];
    [_bossButton setImage:[UIImage imageNamed:@"home_icon_09_on"] forState:UIControlStateHighlighted];
    [_bossButton setTitle:@"店主二维码" forState:UIControlStateNormal];
}

#pragma mark 初始化 NavigationBar 属性
-(void)initNavigationBar {
    //返回按钮文字颜色
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    
    // 标题颜色
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor],
                                                                     NSForegroundColorAttributeName,
                                                                     [UIFont fontWithName:@"Arial-Black" size:20.0f],
                                                                     NSFontAttributeName,
                                                                     shadow,
                                                                     NSShadowAttributeName
                                                                     ,nil]];
    
    
    //背景颜色
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52/255.0 green:45/255.0 blue:44/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:52/255.0 green:45/255.0 blue:44/255.0 alpha:1];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ShareInfo refreshUserModel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpgradeBoss:) name:@"UpgradeBoss" object:nil];
    
    // 检查版本更新；频率：每日
    [BWMSirenManager runWithVersionCheckType:SirenVersionCheckTypeDaily withDelegate:nil];
}

// 收到升级为老板的通知
- (void)UpgradeBoss:(NSNotification *)notification {
    NSString *getURLStr = [NSString stringWithFormat:LoginO2O, shareInfo.userModel.phone, shareInfo.userModel.password, shareInfo.userModel.udid];
    
    [BWMRequestCenter GET:getURLStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        shareInfo.userModel.userType  = [responseObject[@"userType"] intValue];
        if(3 == shareInfo.userModel.userType) {
            [self p_changeToBossButton];
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString
                                       message:@"您的帐号成功升级成为店主帐号！"
                                          type:BWMAlertViewTypeInfo
                                      targetVC:self
                                     callBlock:nil];
        } else {
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString
                                       message:@"您的升级为店主帐号的申请被拒绝了！"
                                          type:BWMAlertViewTypeInfo
                                      targetVC:self
                                     callBlock:nil];
        }
        
    } failure:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}



#pragma mark Touch Home View Button
- (IBAction)TouchButton:(UIButton*)button {
    NSLog(@"Touch Home View Button From Tag:%ld",(long)button.tag);

    if(button.tag==1) {
        BWMMyShopViewController *vc = [[BWMMyShopViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if(button.tag==2) {
        
//        if (shareInfo.userModel.isPaid == false) {
//            if (![shareInfo.userModel.regFee isEqualToString:@"0"]) {
//                NSString * message = [NSString stringWithFormat:@"您的账户需要支付%@元", shareInfo.userModel.regFee];
//                UIAlertView * av = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"付款", nil];
//                
//                av.tag = 444;
//                
//                [av show];
//
//            }else{
//                UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsTableViewController"];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//        }else{
        BWMPutawayViewController *vc = [[BWMPutawayViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
//        }
    }
    
    if (button.tag==3) {
        UIViewController * vc = [[SalesManagementViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (button.tag==4){
        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GuestManagementViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (button.tag==5) {

        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderQueryViewController"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (button.tag==6){

        BWMMyPurseViewController *viewController = [[BWMMyPurseViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (button.tag==7) {
        
        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyPromotionViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (button.tag==8) {
        
        if (shareInfo.userModel.userType == 4) {
            UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UpBossViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BossCodeViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (button.tag == 9) {
        BWMSpecialProductViewController *vc = [[BWMWelfareViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (button.tag == 10) {
        BWMSpecialProductViewController *vc = [[BWMSpecialSellingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 444) {
        if (buttonIndex == 1) {
            ShareInfo * theShareInfo = [ShareInfo shareInstance];
            NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/mobilepay/regfee.aspx?userid=%@" ,theShareInfo.userModel.userID];
            
            [self dataRequest:link SucceedSelector:@selector(UpRegFee:)];
        }
    }
}

#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}

-(void)UpRegFee:(NSMutableDictionary*)dict
{
    NSLog(@"dict:%@",dict);
    NSString * remark = [dict objectForKey:@"remark"];
    NSString * tn = [dict objectForKey:@"tn"];
    NSLog(@"remark:%@  tn:%@",remark,tn);
    
    if (tn.length ==0) {
        [self showAlertViewForTitle:remark AndMessage:nil];
    }else{
        
//        [UPPayPlugin startPay:tn mode:@"00" viewController:self delegate:self];
    }
}
-(void)UPPayPluginResult:(NSString*)result {
    NSLog(@"result:%@",result);
    if ([result isEqualToString:@"success"]) {
        shareInfo.userModel.isPaid = true;
        shareInfo.userModel.regFee = @"0";
    }
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSString *link = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",link);
        id jsonObject = [JSONData JSONDataValue:link];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(jsonObject==nil) {
            } else {
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
            }
        });
    });
}

@end
