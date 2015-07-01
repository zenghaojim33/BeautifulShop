//
//  BWMBindAccountViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/12.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMBindAccountViewController.h"
#import "UIView+BWMExtension.h"
#import "RegExpValidate.h"
#import "BWMMBProgressHUD.h"
#import "BWMRequestCenter.h"
#import "UIColorFactory.h"
#import "BWMAlertViewFactory.h"
#import "NSString+BWMExtension.h"

@interface BWMBindAccountViewController () {
    NSString *_code;
}

@property (strong, nonatomic) IBOutlet UIView *boxView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UITextField *password1TF;
@property (strong, nonatomic) IBOutlet UITextField *password2TF;
@property (strong, nonatomic) IBOutlet UIButton *requestCodeBtn;

@end

@implementation BWMBindAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_changeUI];
}

- (void)p_changeUI {
    [self.boxView drawingDefaultStyleShadow];
}

- (void)p_resignResponder {
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.password1TF resignFirstResponder];
    [self.password2TF resignFirstResponder];
}

// 获取验证码按钮事件
- (IBAction)requestCodeBtnClicked:(UIButton *)sender {
    [self p_resignResponder];
    NSString *errorMsg = nil;
    if (self.phoneTF.text.length == 0) {
        errorMsg = @"手机号码不能为空！";
    } else if (![RegExpValidate validateMobile:self.phoneTF.text]) {
        errorMsg = @"手机号码格式不正确！";
    }
    if (errorMsg) {
        [BWMMBProgressHUD showTitle:errorMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
        return;
    }
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"验证手机"];
    // 检查手机是否已经被绑定
    [BWMRequestCenter POST:@"http://server.mallteem.com/json/index.ashx?aim=checkphone" parameters:@{@"phone" : self.phoneTF.text} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([responseObject[@"status"] boolValue]) {
            [BWMMBProgressHUD hideHUD:HUD hideAfter:0.0];
            // 获取验证码
            [self p_requestCode];
        } else {
            [BWMMBProgressHUD hideHUD:HUD title:@"号码已被占用" hideAfter:kBWMMBProgressHUDHideTimeInterval];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:@"网络故障，请求失败。" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
}

// 获取验证码
- (void)p_requestCode {
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"正在获取验证码"];
    [BWMRequestCenter POST:sendSmsCode parameters:@{@"phone" : self.phoneTF.text} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] boolValue]) {
            _code = responseObject[@"data"][@"code"];
            NSLog(@"code : %@", _code);
            [BWMMBProgressHUD hideHUD:HUD title:@"验证码发送成功" hideAfter:kBWMMBProgressHUDHideTimeInterval];
            [self startTime];
        } else {
            if (responseObject[@"errormsg"] == nil) {
                [BWMMBProgressHUD hideHUD:HUD title:@"验证码发送失败" hideAfter:kBWMMBProgressHUDHideTimeInterval];
            } else {
                [BWMMBProgressHUD hideHUD:HUD title:responseObject[@"errormsg"] hideAfter:kBWMMBProgressHUDHideTimeInterval];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:@"网络故障，请求失败。" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
}

// 马上绑定按钮事件
- (IBAction)bindingBtnClicked:(UIButton *)sender {
    NSString *errMsg = nil;
    if (self.phoneTF.text.length == 0) {
        errMsg = @"手机号码不能为空！";
    } else if (![RegExpValidate validateMobile:self.phoneTF.text]) {
        errMsg = @"手机号码格式不正确";
    } else if (self.codeTF.text == 0) {
        errMsg = @"验证码不能为空！";
    } else if (![self.codeTF.text isEqualToString:_code]) {
        errMsg = @"验证码不正确！";
    } else if (self.password1TF.text.length == 0 || self.password2TF.text.length == 0) {
        errMsg = @"密码不能为空！";
    } else if (self.password1TF.text.length<6 || self.password2TF.text.length<6) {
        errMsg = @"密码不能少于6位！";
    } else if (![self.password1TF.text isEqualToString:self.password2TF.text]) {
        errMsg = @"两次输入的密码不一致！";
    }
    
    if (errMsg) {
        [BWMMBProgressHUD showTitle:errMsg toView:self.view.window hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    } else {
        MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.navigationController.view title:@"正在绑定"];
        NSString *userID = [ShareInfo shareInstance].userModel.userID;
        [BWMRequestCenter POST:@"http://server.mallteem.com/json/index.ashx?aim=UpdatePhoneAndPwd" parameters:@{@"phone" : self.phoneTF.text, @"pwd" : self.password1TF.text, @"userid" : userID} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            NSLog(@"绑定结果：%@", responseObject);
            if ([responseObject[@"status"] boolValue]) {
                [BWMMBProgressHUD hideHUD:HUD hideAfter:0.0];
                [ShareInfo shareInstance].userModel.password = [self.password1TF.text bwm_MD5String];
                [ShareInfo shareInstance].userModel.phone = self.phoneTF.text;
                [ShareInfo shareInstance].userModel.realPassword = self.password1TF.text;
                [ShareInfo refreshUserModel];
                [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString message:@"绑定账号成功，您牢记您的新账号和密码，可以用它来登陆啦！" type:BWMAlertViewTypeSuccess targetVC:self callBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                    [self.navigationController popViewControllerAnimated:YES];
                    if (_delegate) {
                        [_delegate bindAccountViewController:self didSuccessfulBindingPhone:self.phoneTF.text];
                    }
                }];
            } else {
                [BWMMBProgressHUD hideHUD:HUD title:responseObject[@"errormsg"] hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeError];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [BWMMBProgressHUD hideHUD:HUD title:@"绑定失败，请重新尝试！" hideAfter:2.0 msgType:BWMMBProgressHUDMsgTypeError];
        }];
    }
    
    [self p_resignResponder];
}

- (void)startTime{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置 特别注明：UI的改变一定要在主线程中进行
                [self.requestCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.requestCodeBtn.enabled = YES;
                self.requestCodeBtn.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
                self.phoneTF.enabled = YES;
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [self.requestCodeBtn setTitle:[NSString stringWithFormat:@"重新获取(%@)",strTime] forState:UIControlStateNormal];
                self.requestCodeBtn.enabled = NO;
                self.requestCodeBtn.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
                self.phoneTF.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
