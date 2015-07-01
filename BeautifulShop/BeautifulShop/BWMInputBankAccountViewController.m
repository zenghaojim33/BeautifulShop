//
//  BWMInputBankAccountViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/8.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMInputBankAccountViewController.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "BranksViewController.h"
#import "BWMRedButton.h"
#import "BWMAlertViewFactory.h"
#import "RegExpValidate.h"
#import "RegExpValidateFormat.h"
#import "ShareInfo.h"
#import "BWMBankAccountChangeRequestModel.h"
#import "BWMRequestCenter.h"
#import "BWMMBProgressHUD.h"
#import "NSString+BWMExtension.h"
#import "UIColorFactory.h"
#import "BeautifulShop-Swift.h"
#import "BWMBindAccountViewController.h"
#import "BWMCaptchaView.h"

@interface BWMInputBankAccountViewController()
<
    BrandDelegate,
    UITextFieldDelegate,
    BWMCardIOViewControllerDelegate,
    BWMBindAccountViewControllerDelegate,
    BWMCaptchaViewDelegate
>
{
    IBOutlet UITextField *_ownerTF;
    IBOutlet UITextField *_numberTF;
    IBOutlet UITextField *_bankNameTF;
    IBOutlet BWMRedButton *_confirmBtn;
}

@end

@implementation BWMInputBankAccountViewController

+ (instancetype)viewController {
    BWMInputBankAccountViewController *vc = [UIStoryboard initVCOnMainStoryboardWithID:@"BWMInputBankAccountViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    _numberTF.delegate = self;
    
    _confirmBtn.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)loadData {
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=getmyinfor&userid=%@", shareInfo.userModel.userID];
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.navigationController.view title:@"正在获取银行资料"];
    [BWMRequestCenter GET:link
                 parameters:nil
                    success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                        
                        NSDictionary *dict = responseObject[@"data"];
                        _bankNameTF.text = dict[@"bankName"];
                        
                        NSString *bankCode = dict[@"bankCode"];
                        _numberTF.text = [bankCode bwm_bankCardNumberString];
                        
                        _ownerTF.text = dict[@"bankUser"];
                        
                        [BWMMBProgressHUD hideHUD:HUD title:@"获取成功" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeSuccessful];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [BWMMBProgressHUD hideHUD:HUD title:@"网络故障，获取失败！" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
                    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [RegExpValidateFormat formatToBankCardNumberStringWithTextField:textField replacementString:string];
}

- (IBAction)confirmBtnClicked:(BWMRedButton *)sender {
    [_ownerTF resignFirstResponder];
    [_numberTF resignFirstResponder];
    
    NSString *numberString = [_numberTF.text bwm_clearAllWhiteSpaceCharacters];
    NSString *errorMsg = nil;
    if (_ownerTF.text.length == 0) {
        errorMsg = @"持卡人姓名不能为空！";
    } else if (_bankNameTF.text.length == 0) {
        errorMsg = @"您还未选择开户银行！";
    } else if (numberString.length == 0) {
        errorMsg = @"您还没输入银行卡号！";
    } else if (![RegExpValidate validateBankAccountNumber:numberString]) {
        errorMsg = @"您输入的银行卡号不正确！";
    }
    
    if (errorMsg) {
        [BWMAlertViewFactory showWithTitle:@"错误提示"
                                   message:errorMsg
                                      type:BWMAlertViewTypeError
                                  targetVC:self
                                 callBlock:nil];
    } else {
        // 没有绑定手机号就需要用户绑定
        if ([ShareInfo shareInstance].userModel.phone.length == 0) {
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString message:@"您当前还没有绑定手机号码，请先绑定手机号码才能进行此操作！" type:BWMAlertViewTypeInfo targetVC:self OKcallBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                BWMBindAccountViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BWMBindAccountViewController"];
                VC.delegate = self;
                [self.navigationController pushViewController:VC animated:YES];
            } CancelcallBlock:nil];
        } else {
            // 显示验证码提示框要求输入验证码
            BWMCaptchaView *captchaView = [BWMCaptchaView captchaViewWithDelegate:self];
            [captchaView show];
        }
    }
}

- (void)p_changeBankAccount {
    NSString *numberString = [_numberTF.text bwm_clearAllWhiteSpaceCharacters];
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"正在请求修改"];
    
    BWMBankAccountChangeRequestModel *model = [BWMBankAccountChangeRequestModel modelWithbname:_bankNameTF.text
                                                                                         bcode:numberString
                                                                                         buser:_ownerTF.text];
    NSLog(@"%@", [model getParameterObject]);
    [BWMRequestCenter POST:[BWMBankAccountChangeRequestModel API]
                parameters:[model getParameterObject]
                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       [BWMAlertViewFactory showWithTitle:@"温馨提示"
                                                  message:@"修改收款帐号成功！"
                                                     type:BWMAlertViewTypeSuccess
                                                 targetVC:self
                                                callBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }];
                       
                       [BWMMBProgressHUD hideHUD:HUD hideAfter:kBWMMBProgressHUDHideTimeInterval];
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       
                       [BWMAlertViewFactory showWithTitle:@"错误提示"
                                                  message:@"网络故障，修改失败！请重试..."
                                                     type:BWMAlertViewTypeError
                                                 targetVC:self
                                                callBlock:nil];
                       [BWMMBProgressHUD hideHUD:HUD hideAfter:kBWMMBProgressHUDHideTimeInterval];
                   }];

}

- (IBAction)cameraBtnClicked:(UIButton *)sender {
    BWMCardIOViewController *cardIOViewController = [BWMCardIOViewController createWithDelegate:self];
    [self presentViewController:cardIOViewController animated:YES completion:nil];
}

#pragma mark- BWMCardIOViewControllerDelegate
- (void)cardIOViewCtroller:(BWMCardIOViewController * __nonnull)cardIOViewCtroller didScanCard:(NSString * __nonnull)cardNumber {
    _numberTF.text = [cardNumber bwm_bankCardNumberString];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        BranksViewController *vc = [BranksViewController viewController];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark- BranksViewControllerDelegate
- (void)setBrandName:(NSString *)brandName {
    _bankNameTF.text = brandName;
}

- (IBAction)textFieldTouchDone:(UITextField *)sender {
    [sender resignFirstResponder];
}

#pragma mark- BWMBindAccountViewControllerDelegate
- (void)bindAccountViewController:(BWMBindAccountViewController *)viewController didSuccessfulBindingPhone:(NSString *)phone {
    [self p_changeBankAccount];
}

#pragma mark- 
- (void)captchaView:(BWMCaptchaView *)captchaView didSuccessfulValidateCaptcha:(NSString *)captcha {
    [self p_changeBankAccount];
}

@end
