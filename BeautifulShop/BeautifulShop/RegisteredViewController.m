//
//  RegisteredViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "RegisteredViewController.h"
#import "BWMRequestCenter.h"
#import "UIColorFactory.h"
#import "UIView+BWMExtension.h"
#import "BWMMBProgressHUD.h"
#import "NSString+BWMExtension.h"

@interface RegisteredViewController ()
{
    NSString * smsCode;
}
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UITextField *userNameTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) IBOutlet UITextField *passWord2TF;

@property (strong, nonatomic) IBOutlet UITextField *PhoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *codeTF;
@property (strong, nonatomic) IBOutlet UIButton *smsBth;
@property(nonatomic)int times;
@property(nonatomic,weak)NSTimer * timer;
@end

@implementation RegisteredViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"注册";
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    self.PhoneNumberTF.text = self.phone;
    self.PhoneNumberTF.textColor = [UIColor lightGrayColor];
    self.PhoneNumberTF.userInteractionEnabled = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_bgView drawingDefaultStyleShadow];
}
#define FPS 30.0
#pragma mark 获取验证码
- (IBAction)GetCodeNumber:(UIButton *)sender
{
    
//    self.PhoneNumberTF.text = @"13450224306";
    
    [self.userNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
    [self.passWord2TF resignFirstResponder];
    [self.PhoneNumberTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    
    

  

        [self.smsBth setBackgroundColor:[UIColor lightGrayColor]];
        self.smsBth.userInteractionEnabled = NO;
        self.times = 60;
        self.timer =[NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(animate:)
                                                   userInfo:nil
                                                    repeats:YES];
        
        
//        NSString * link = [NSString stringWithFormat:sendSmsCode,self.PhoneNumberTF.text];
    
//        [self dataRequest:link SucceedSelector:@selector(upDataSmsCode:)];

    [BWMRequestCenter POST:sendSmsCode parameters:@{@"phone" : self.PhoneNumberTF.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if([responseObject[@"status"] boolValue]) {
            smsCode = [responseObject[@"data"][@"code"] copy];
            [BWMMBProgressHUD showTitle:@"验证码发送成功！" toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeSuccessful];
        } else {
            [BWMMBProgressHUD showTitle:responseObject[@"errormsg"] toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD showTitle:@"网络连接失败！" toView:self.navigationController.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
    
}

-(void)upDataSmsCode:(NSMutableDictionary*)dict
{
    NSLog(@"dict:%@",dict);
    if ([[dict objectForKey:@"succesed"]boolValue])
    {
        [self showAlertViewForTitle:@"发送成功" AndMessage:@"请注意查收验证码"];
        smsCode = [[NSString alloc]init];
        smsCode = [dict objectForKey:@"code"];
        
    }else{
        [self showAlertViewForTitle:@"发送失败" AndMessage:nil];
    }
}
-(void)animate:(id)sender
{
    self.times --;
    [self.smsBth setTitle:[NSString stringWithFormat:@"重新获取(%d)",self.times] forState:UIControlStateNormal];
    if (self.times==0) {
        self.smsBth.userInteractionEnabled = YES;
        [self.smsBth setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.smsBth setBackgroundColor:[UIColorFactory createColorWithType:UIColorFactoryColorTypePurple]];
        [self.timer invalidate];
    }
}

#pragma mark 点击马上注册
- (IBAction)TouchRegisteredBth:(UIButton *)sender {
    
    
//    self.userNameTF.text = @"Jenk";
//    self.passWordTF.text = @"123456";
//    self.codeTF.text = smsCode;
    
    [self.userNameTF resignFirstResponder];
    [self.passWordTF resignFirstResponder];
      [self.passWord2TF resignFirstResponder];
    [self.PhoneNumberTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    
    NSString *errorMsg = nil;
    if (self.codeTF.text.length == 0) {
        errorMsg = @"验证码不能为空！";
    } else if (self.passWordTF.text.length == 0 || self.passWord2TF.text.length == 0) {
        errorMsg = @"密码不能为空！";
    } else if (self.passWordTF.text.length < 6 || self.passWord2TF.text.length < 6) {
        errorMsg = @"密码不能少于6位！";
    } else if (self.userNameTF.text.length == 0) {
        errorMsg = @"店铺名称不能为空！";
    } else if (![self.passWordTF.text isEqualToString:self.passWord2TF.text]) {
        errorMsg = @"两次输入的密码不一致！";
    } else if (![self.codeTF.text isEqualToString:smsCode]) {
        errorMsg = @"验证码错误";
    }
    
    if (errorMsg) {
        [BWMMBProgressHUD showTitle:errorMsg
                             toView:self.view.window
                          hideAfter:1.5
                            msgType:BWMMBProgressHUDMsgTypeError];
    } else {
        [self Registered];
    }

}
#pragma mark 注册
- (void)Registered
{
    
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString * name = self.userNameTF.text;
    NSString * phone = self.PhoneNumberTF.text;
    NSString * pwd = [self.passWordTF.text bwm_MD5String];
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"请稍候..." animated:YES];
    
    [BWMRequestCenter
     POST:@"http://server.mallteem.com/json/index.ashx?aim=register"
     parameters:@{@"name" : name, @"phone" : phone, @"pwd" : pwd}
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [BWMMBProgressHUD hideHUD:HUD hideAfter:kBWMMBProgressHUDHideTimeInterval];
         NSDictionary *dict = responseObject;
         [self performSelector:@selector(UpRegisteredData:) withObject:dict afterDelay:0.2f];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:@"获取数据失败请检查你的网络" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
    }];
    
//    //创建一个请求地址
//    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=register"];
//    //创建请求对象
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    //修改请求 方式  ****以下为post请求
//    
//    [request setHTTPMethod:@"POST"];
    
//    NSData *requestBody = [[NSString stringWithFormat:@"name=%@&phone=%@&pwd=%@",name,phone,pwd] dataUsingEncoding:NSUTF8StringEncoding];
//    
//    [request setHTTPBody:requestBody];
    
    //发出请求 并且得到响应数据
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:Nil];
    
//    if(data==nil)
//    {
//        
//        NSString*  message = @"获取数据失败请检查你的网络";
//        
//        [self showAlertViewForTitle:nil AndMessage:message];
//        
//    }else{
//        
//        NSLog(@"data不等于空");
//    
//        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
//                                                      options:0
//                                                        error:nil];
//
//        NSLog(@"%@", JsonObject);
//        
//        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
//
//        
//        [self performSelector:@selector(UpRegisteredData:) withObject:dict afterDelay:0.2f];
//        
//    }
    
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
-(void)UpRegisteredData:(NSMutableDictionary*)dict
{
    NSLog(@"dict:%@",dict);
    
    NSString * status = [dict objectForKey:@"status"];
    int statusInt = [status intValue];
    if (statusInt == false) {
        NSString * error = [dict objectForKey:@"error"];
        [self showAlertViewForTitle:@"注册失败" AndMessage:error];
        
    }else{

        [self showAlertViewForTitle:@"注册成功" AndMessage:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (IBAction)TFDidEndOnExit:(UITextField *)sender {
    
    switch (sender.tag) {
        case 1:
            [self.passWordTF becomeFirstResponder];
            break;
        case 2:
            [self.passWord2TF becomeFirstResponder];
            break;
        case 3:
            [self.PhoneNumberTF becomeFirstResponder];
            break;
        case 4:
            [self.codeTF becomeFirstResponder];
            break;
        default:
            [self.userNameTF resignFirstResponder];
            [self.passWordTF resignFirstResponder];
            [self.passWord2TF resignFirstResponder];
            [self.PhoneNumberTF resignFirstResponder];
            [self.codeTF resignFirstResponder];
            break;
    }
    
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


@end
