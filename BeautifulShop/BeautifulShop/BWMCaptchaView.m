//
//  BWMCaptchaView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/13.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMCaptchaView.h"
#import "CustomIOS7AlertView.h"
#import "UIColorFactory.h"
#import "BWMRequestCenter.h"
#import "BWMMBProgressHUD.h"
#import "NSString+BWMExtension.h"

@interface BWMCaptchaView() {
    NSString *_captcha;
}

@end

@implementation BWMCaptchaView

- (void)awakeFromNib {
    [super awakeFromNib];
    [_requestBtn addTarget:self action:@selector(requestBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_captchaTF addTarget:self action:@selector(captchaTFAllEditing:) forControlEvents:UIControlEventAllEditingEvents];
    [_closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    _confirmBtn.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
    [self p_requestCaptcha];
}

- (void)p_requestCaptcha {
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self title:@"正在发送验证码"];
    self.tipsLabel.text = @"正在发送验证码...";
    [BWMRequestCenter POST:sendSmsCode parameters:@{@"phone" : [ShareInfo shareInstance].userModel.phone} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if ([[responseObject objectForKey:@"status"] boolValue]) {
            _captcha = responseObject[@"data"][@"code"];
            
            if ([_delegate respondsToSelector:@selector(captchaView:didReceiveCaptcha:)]) [_delegate captchaView:self didReceiveCaptcha:_captcha];
            
            [BWMMBProgressHUD hideHUD:HUD title:@"验证码发送成功" hideAfter:kBWMMBProgressHUDHideTimeInterval];
            self.tipsLabel.text = [NSString stringWithFormat:@"验证码已经发送到手机：%@，请注意查收。", [NSString bwm_phoneEncodeString]];
            
            [self startTime];
        } else {
            if (responseObject[@"errormsg"] == nil) {
                [BWMMBProgressHUD hideHUD:HUD title:@"验证码发送失败" hideAfter:kBWMMBProgressHUDHideTimeInterval];
            } else {
                [BWMMBProgressHUD hideHUD:HUD title:responseObject[@"errormsg"] hideAfter:kBWMMBProgressHUDHideTimeInterval];
            }
            self.tipsLabel.text = @"验证码发送失败，请重新获取...";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD hideHUD:HUD title:@"网络故障，请求失败。" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
        self.tipsLabel.text = @"验证码发送失败，请重新获取...";
    }];
}

#pragma mark- Event
- (void)requestBtnClicked:(UIButton *)button {
    [self p_requestCaptcha];
}

- (void)confirmBtnClicked:(UIButton *)button {
    NSString *errorMsg = nil;
    if (self.captchaTF.text.length == 0) {
        errorMsg = @"验证码不能为空！";
    } else if (![self.captchaTF.text isEqualToString:_captcha]) {
        errorMsg = @"验证码不正确！";
    }
    
    if (errorMsg) {
        [BWMMBProgressHUD showTitle:errorMsg toView:self hideAfter:2.0f];
    } else {
        [self p_close];
        if ([_delegate respondsToSelector:@selector(captchaView:didSuccessfulValidateCaptcha:)]) {
            [_delegate captchaView:self didSuccessfulValidateCaptcha:_captcha];
        }
    }
}

- (void)captchaTFAllEditing:(UITextField *)textField {
    
}

- (void)closeBtnClicked:(UIButton *)button {
    [self p_close];
}

#pragma mark-
- (void)show {
    [_alertView show];
}

- (void)p_close {
    [_alertView close];
}

- (void)startTime{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置 特别注明：UI的改变一定要在主线程中进行
                [self.requestBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.requestBtn.enabled = YES;
                [self.requestBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:145/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
            });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置界面的按钮显示 根据自己需求设置
                [self.requestBtn setTitle:[NSString stringWithFormat:@"重新获取(%@)",strTime] forState:UIControlStateNormal];
                [self.requestBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.requestBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)setAlertView:(CustomIOS7AlertView *)alertView {
    _alertView = alertView;
    alertView.containerView = self;
}

+ (instancetype)captchaViewWithDelegate:(id<BWMCaptchaViewDelegate>)delegate {
    BWMCaptchaView *captchaView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    captchaView.layer.cornerRadius = 5.0f;
    captchaView.layer.masksToBounds = YES;
    captchaView.delegate = delegate;
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    alertView.buttonTitles = @[];
    captchaView.alertView = alertView;
    return captchaView;
}


@end
