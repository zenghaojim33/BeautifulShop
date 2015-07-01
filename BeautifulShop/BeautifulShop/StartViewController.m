//
//  StartViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-9.
//  Copyright (c) 2014年 jenk. All rights reserved.
//
#import "StartViewController.h"
#import "ChangeInfoViewController.h"
#import "SvUDIDTools.h"
#import "BWMGuideDirector.h"
#import "UIButton+Extension.h"
#import "UITextField+Extension.h"
#import "MiPushSDK.h"
#import "RegExpValidate.h"
#import "BWMAlertViewFactory.h"
#import "BWMMBProgressHUD.h"
#import "BWMUmengManager.h"
#import "NSString+BWMExtension.h"
#import "WXApi.h"
#import "BWMSystemConfigurationManager.h"

@interface StartViewController () <WXApiDelegate, UIApplicationDelegate> {
    
    IBOutlet UIButton *_registerBtn;
    IBOutlet UIButton *_findPasswordBtn;
    NSString * udid;
    
}

@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *wechatLoginBtn;

@end

@implementation StartViewController

- (void)viewWillLayoutSubviews {
    static BOOL flag = YES;
    if (flag) {
        BWMGuideDirector *guideDirector = [[BWMGuideDirector alloc] initWithViewController:self];
        [guideDirector showGuideViewController];
        flag = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    [self initNavigationBar];
    self.userNameTF.text = @"";
    self.passWordTF.text = @"";
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    NSString * lastUserName = [ud objectForKey:@"UserName"];
    
    NSLog(@"lastUserName:%@",lastUserName);
    
    if (lastUserName.length !=0) {
        
        self.userNameTF.text = lastUserName;
    }
    
    NSString * lastPassWord = [ud objectForKey:@"PassWord"];
    NSLog(@"lastPassWord:%@",lastPassWord);
    
    if (lastPassWord.length !=0) {
//        self.passWordTF.text = lastPassWord;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

-(void)getMyID {
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    udid = shareInfo.userModel.udid;
    if (udid.length ==0) {
        udid = @"";
        shareInfo.userModel.udid = @"";
    }
}

#pragma mark 初始化 NavigationBar 属性
-(void)initNavigationBar {
    //返回按钮文字颜色
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //标题颜色
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxlogin) name:@"用户用微信登陆" object:nil];
    // 设置UI样式
    [_userNameTF cb_setDefaultStyleTextField];
    [_passWordTF cb_setDefaultStyleTextField];
//    [_registerBtn cb_setDefaultStyleButton];
//    [_findPasswordBtn cb_setDefaultStyleButton];
    
    self.wechatLoginBtn.hidden = ![WXApi isWXAppInstalled];
}

- (void)wxlogin {
    UINavigationController * Nav = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerNav"];
    Nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:Nav animated:YES completion:nil];
}

#pragma mark 登录Bth
- (IBAction)GoToTheLoginView:(UIButton *)sender {
    [self.userNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];

    NSString *errorMsg = nil;
    if (self.userNameTF.text.length == 0) {
        errorMsg = @"手机号码不能为空！";
    } else if (![RegExpValidate validateMobile:self.userNameTF.text]) {
        errorMsg = @"手机号码格式不正确！";
    } else if (self.passWordTF.text.length == 0) {
        errorMsg = @"密码不能为空！";
    }
    
    if (errorMsg) {
        [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString message:errorMsg type:BWMAlertViewTypeError targetVC:self callBlock:nil];
    } else {
        [self getMyID];
        NSString * phone = self.userNameTF.text;
        NSString * pwd = [self.passWordTF.text bwm_MD5String];
        NSString * link = [NSString stringWithFormat:LoginO2O,phone,pwd,udid];
        [self dataRequest:link SucceedSelector:@selector(UpLoginO2OData:)];
    }
}

-(void)UpLoginO2OData:(NSMutableDictionary*)dict
{
    NSLog(@"UserDict:%@",dict);
    
    NSString * status = [dict objectForKey:@"status"];
    int statusInt = [status intValue];
    
    if (statusInt == false) {
        NSString * error = [dict objectForKey:@"error"];
        [BWMMBProgressHUD showTitle:error toView:self.view hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeError];
    } else {
        ShareInfo * shareInfo = [ShareInfo shareInstance];
        shareInfo.userModel.userID = [dict objectForKey:@"id"];//用户ID
        shareInfo.userModel.userType=[[dict objectForKey:@"userType"] intValue];//用户类型
        shareInfo.userModel.isDataOK=[[dict objectForKey:@"isDataOK"] intValue];//用户资料是否完善
//         shareInfo.userModel.isDataOK= 1;//用户资料是否完善
        shareInfo.userModel.isFirtLogin=[[dict objectForKey:@"isFirtLogin"] intValue];//是否第一次登录
        shareInfo.userModel.isPaid=[[dict objectForKey:@"isPaid"] intValue];//是否付费
        shareInfo.userModel.name=[dict objectForKey:@"name"];//商户名称
        shareInfo.userModel.phone = [dict objectForKey:@"phone"];//手机
        shareInfo.userModel.password=[dict objectForKey:@"password"];//密码
        shareInfo.userModel.regFee=[dict objectForKey:@"regFee"];//注册费
        shareInfo.userModel.uimg = [dict objectForKey:@"uimg"];
        shareInfo.userModel.token = [dict objectForKey:@"token"];
        shareInfo.userModel.parentName = [dict objectForKey:@"parentName"];//老板名字
        shareInfo.userModel.parentId = [dict objectForKey:@"parentId"];//老板id
        shareInfo.userModel.realPassword = self.passWordTF.text;
        [ShareInfo saveUserModel];
        [[BWMSystemConfigurationManager sharedSystemConfigurationManager] setSignInState];
        
        NSLog(@"用户ID:%@ , 类型:%d , 资料是否完善:%d , 是否第一次登录:%d , 是否付费:%d , 商户名称:%@ , 手机:%@ , 密码:%@ , 注册费 : %@  图片地址:%@",
              shareInfo.userModel.userID,
              shareInfo.userModel.userType,
              shareInfo.userModel.isDataOK,
              shareInfo.userModel.isFirtLogin,
              shareInfo.userModel.isPaid,
              shareInfo.userModel.name,
              shareInfo.userModel.phone,
              shareInfo.userModel.password,
              shareInfo.userModel.regFee,
              shareInfo.userModel.uimg);
        
        
        shareInfo.userModel.udid = udid;
        
        NSLog(@"udid:%@",udid);
       NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
        
        [ud setObject:self.userNameTF.text forKey:@"UserName"];
        [ud setObject:self.passWordTF.text forKey:@"PassWord"];
//        if(shareInfo.userModel.isDataOK == 1) {
            UINavigationController * Nav = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerNav"];
            Nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:Nav animated:YES completion:nil];
//        } else {
//            ChangeInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
//            vc.isChange = NO;
//            [self.navigationController pushViewController:vc animated:YES];
//            //6212263602027129402
//        }
    }
}


#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector{
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"正在验证..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *link = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",link);
        id jsonObject = [JSONData JSONDataValue:link];
        
        NSLog(@"%@", jsonObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(jsonObject==nil) {
                [BWMMBProgressHUD hideHUD:HUD title:@"网络不通" hideAfter:kBWMMBProgressHUDHideTimeInterval];
            } else {
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
                [BWMMBProgressHUD hideHUD:HUD hideAfter:0.0];
            }
            
        });
        
    });
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.userNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
}

- (IBAction)loginWXBtnClicked:(id)sender {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"UserLogin";
    [WXApi sendReq:req];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
