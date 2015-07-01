//
//  changePassWordViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "changePassWordViewController.h"
#import "BWMRequestCenter.h"
#import "UIColorFactory.h"
#import "UIView+BWMExtension.h"
#import "BWMMBProgressHUD.h"
#import "NSString+BWMExtension.h"
#import "RegExpValidate.h"

@interface changePassWordViewController ()
{
    NSString * smsCode;
}
@property (strong, nonatomic) IBOutlet UITextField *PhoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *smsBth;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UITextField *passWord2TF;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic)int times;
@property(nonatomic,weak)NSTimer * timer;
@end

@implementation changePassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_bgView drawingDefaultStyleShadow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"找回密码";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#define FPS 30.0
#pragma mark 获取验证码
- (IBAction)GetCodeNumber:(UIButton *)sender {
    [self.passWordTF resignFirstResponder];
    [self.passWord2TF resignFirstResponder];
    [self.PhoneNumberTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    
    if (self.PhoneNumberTF.text.length==0) {
        
        [self showAlertViewForTitle:@"请输入手机号码" AndMessage:nil];
        
    }else{
        
        BOOL mobile = [RegExpValidate validateMobile:self.PhoneNumberTF.text];
        if (mobile == NO) {
            
            [self showAlertViewForTitle:@"手机号码格式错误" AndMessage:nil];
            
        }else{
            MBProgressHUD * HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:kBWMMBProgressHUDLoadingMsg];
            [BWMRequestCenter POST:@"http://server.mallteem.com/json/index.ashx?aim=checkphone" parameters:@{@"phone" : self.PhoneNumberTF.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                if (![responseObject[@"status"] boolValue]) {
                    [BWMMBProgressHUD hideHUD:HUD hideAfter:0.0f];
                    [self p_postCode];
                } else {
                    [BWMMBProgressHUD hideHUD:HUD title:@"该手机号码还没有注册!" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [BWMMBProgressHUD hideHUD:HUD title:@"访问服务器失败！" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
            }];
            
//            NSString * link = [NSString stringWithFormat:sendSmsCode,self.PhoneNumberTF.text];
            
//            [self dataRequest:link SucceedSelector:@selector(upDataSmsCode:)];
        }
    }
}

- (void)p_postCode {
    [BWMRequestCenter POST:sendSmsCode parameters:@{@"phone" : self.PhoneNumberTF.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = responseObject;
        NSLog(@"dict:%@",dict);
        if ([[dict objectForKey:@"status"] boolValue])
        {
            self.PhoneNumberTF.textColor = [UIColor lightGrayColor];
            self.PhoneNumberTF.userInteractionEnabled = NO;
            [self.smsBth setBackgroundColor:[UIColor lightGrayColor]];
            self.smsBth.userInteractionEnabled = NO;
            self.times = 60;
            self.timer =[NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(animate:)
                                                       userInfo:nil
                                                        repeats:YES];
            smsCode = dict[@"data"][@"code"];
            [BWMMBProgressHUD showTitle:@"验证码发送成功！" toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeSuccessful];
        } else {
            if (dict[@"errormsg"] == nil) {
                [BWMMBProgressHUD showTitle:@"验证码发送失败！" toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
            } else {
                [BWMMBProgressHUD showTitle:dict[@"errormsg"] toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD showTitle:@"访问服务器失败！" toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
    }];

}
#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
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
            if(jsonObject==nil) {
                message = @"获取数据失败请检查你的网络";
                [self showAlertViewForTitle:message AndMessage:nil];
            } else {
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
        
    });
    
}

- (IBAction)TFDidEndOnExit:(UITextField *)sender {

    [sender resignFirstResponder];
}


-(void)animate:(id)sender {
    self.times --;
    [self.smsBth setTitle:[NSString stringWithFormat:@"重新获取(%d)",self.times] forState:UIControlStateNormal];
    if (self.times==0) {
        self.PhoneNumberTF.textColor = [UIColor blackColor];
        self.PhoneNumberTF.userInteractionEnabled = YES;
        self.smsBth.userInteractionEnabled = YES;
        [self.smsBth setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsBth setBackgroundColor:[UIColorFactory createColorWithType:UIColorFactoryColorTypePurple]];
        [self.timer invalidate];
    }
}
#pragma mark  马上修改
- (IBAction)ChangePassWord:(UIButton *)sender {
    NSString *errMsg = nil;
    if (self.PhoneNumberTF.text.length == 0) {
        errMsg = @"手机号码不能为空！";
    } else if (![RegExpValidate validateMobile:self.PhoneNumberTF.text]) {
        errMsg = @"手机号码格式不正确";
    } else if (self.codeTF.text == 0) {
        errMsg = @"验证码不能为空！";
    } else if (![self.codeTF.text isEqualToString:smsCode]) {
        errMsg = @"验证码不正确！";
    } else if (self.passWordTF.text.length == 0 || self.passWord2TF.text.length == 0) {
        errMsg = @"密码不能为空！";
    } else if (self.passWordTF.text.length<6 || self.passWord2TF.text.length<6) {
        errMsg = @"密码不能少于6位！";
    } else if (![self.passWordTF.text isEqualToString:self.passWord2TF.text]) {
        errMsg = @"两次密码不一致！";
    }
    
    if (errMsg) {
        [BWMMBProgressHUD showTitle:errMsg toView:self.view.window hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    } else {
        [self changePwd];
    }
}

#pragma mark- 修改密码事情 !important
-(void)changePwd {
    NSString * phone = self.PhoneNumberTF.text;
    NSString * pwd = [self.passWordTF.text bwm_MD5String];
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //创建一个请求地址
    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=updatepwd"];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //修改请求 方式  ****以下为post请求
    
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"phone=%@&pwd=%@",phone,pwd] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
    
    //发出请求 并且得到响应数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:Nil];
    
    if(data==nil)
    {
        
        NSString*  message = @"获取数据失败请检查你的网络";
        
        [self showAlertViewForTitle:nil AndMessage:message];
        
    } else {
        
        NSLog(@"data不等于空");
        
        NSError *error=nil;
        
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
        [self performSelector:@selector(changePwd:) withObject:dict afterDelay:0.2f];
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)changePwd:(NSMutableDictionary*)dict {
    NSString * status = [dict objectForKey:@"status"];
    int statusInt = [status intValue];
    
    if (statusInt == false) {
        
        NSString * error = [dict objectForKey:@"error"];
        [self showAlertViewForTitle:@"修改失败" AndMessage:error];
    } else {
        [self showAlertViewForTitle:@"修改成功" AndMessage:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
