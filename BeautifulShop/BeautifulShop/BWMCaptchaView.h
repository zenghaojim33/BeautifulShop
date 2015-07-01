//
//  BWMCaptchaView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/13.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomIOS7AlertView;
@class BWMCaptchaView;

@protocol BWMCaptchaViewDelegate <NSObject>

@optional
- (void)captchaView:(BWMCaptchaView *)captchaView didReceiveCaptcha:(NSString *)captcha;

@required
- (void)captchaView:(BWMCaptchaView *)captchaView didSuccessfulValidateCaptcha:(NSString *)captcha;

@end

/**
 *  @brief  短信验证码视图
 */
@interface BWMCaptchaView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UITextField *captchaTF;
@property (strong, nonatomic) IBOutlet UIButton *requestBtn;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) id<BWMCaptchaViewDelegate> delegate;
@property (strong, nonatomic) CustomIOS7AlertView *alertView;

+ (instancetype)captchaViewWithDelegate:(id<BWMCaptchaViewDelegate>)delegate;

- (void)show;

@end
