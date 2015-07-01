//
//  PhoneViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-20.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "PhoneViewController.h"
#import "RegisteredViewController.h"
#import "UIView+BWMExtension.h"
#import "BWMMBProgressHUD.h"
#import "RegExpValidate.h"

@interface PhoneViewController ()
{
}
@property (strong, nonatomic) IBOutlet UITextField *myTF;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation PhoneViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.myTF becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册验证";
    [self.bgView drawingDefaultStyleShadow];
}

- (IBAction)TFDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
}


- (IBAction)Next:(id)sender {
    [self.myTF resignFirstResponder];
    BOOL isPhone = [RegExpValidate validateMobile:self.myTF.text];
    
    if (isPhone == NO) {
        [self showAlertViewForTitle:@"手机号码不合法" AndMessage:nil];
    } else {
        MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view.window title:@"正在验证手机号码"];
        [HUD showWhileExecuting:@selector(loadData) onTarget:self withObject:nil animated:YES];
    }
}

- (void)loadData {
    NSString * phone = self.myTF.text;
    
    // 创建一个请求地址
    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=checkphone"];
    // 创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // 修改请求 方式  ****以下为post请求
    
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"phone=%@",phone] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
    
    // 发出请求 并且得到响应数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:Nil];
    
    if (data==nil) {
        NSString*  message = @"获取数据失败请检查你的网络";
        
        [self showAlertViewForTitle:nil AndMessage:message];
        
    } else {
        
        NSLog(@"data不等于空");
        
        NSError *error=nil;
        
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        
        
        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
        
        NSString * status = [dict objectForKey:@"status"];
        int statusInt = [status intValue];
        
        if (statusInt == YES) {
            
            RegisteredViewController * vc= [self.storyboard instantiateViewControllerWithIdentifier:@"RegisteredViewController"];
            vc.phone = self.myTF.text;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            [self showAlertViewForTitle:[dict objectForKey:@"error"] AndMessage:nil];
            
        }
    }

}

#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}
@end
