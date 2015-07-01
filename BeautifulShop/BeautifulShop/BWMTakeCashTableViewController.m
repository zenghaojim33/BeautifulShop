//
//  BWMTakeCashTableViewController.m
//  BeautifulShop
//
//  Created by btw on 15/3/25.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMTakeCashTableViewController.h"
#import "UIColorFactory.h"
#import "BWMAlertViewFactory.h"
#import "RegExpValidateFormat.h"
#import "BWMRequestCenter.h"
#import "BWMInputBankAccountViewController.h"
#import "BWMTakeCashPostModel.h"
#import "BWMBankCoder.h"
#import "BWMTakeCashInfoModel.h"
#import "BWMMBProgressHUD.h"

@interface BWMTakeCashTableViewController () {
    BWMTakeCashInfoModel *_takeCashInfoModel;
}

@property (strong, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *completeTipsLabel;
@property (strong, nonatomic) IBOutlet UIButton *takeCashButton;
@property (strong, nonatomic) IBOutlet UITextField *cashInputTextField;

@end

@implementation BWMTakeCashTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.title = @"提现到银行卡";
    
    [self p_takeCashButtonSetEnable:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
    
    self.bankNameLabel.hidden = YES;
    self.cardNumberLabel.hidden = YES;
    self.completeTipsLabel.hidden = YES;
}

- (void)loadData {
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.navigationController.view title:@"正在读取资料"];
    
    [BWMRequestCenter GET:[BWMTakeCashInfoModel API]
                 parameters:nil
                    success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                        NSDictionary *dict = responseObject[@"data"];
                        _takeCashInfoModel = [[BWMTakeCashInfoModel alloc] initWithDictionary:dict];
                        
                        _cardNumberLabel.text = [_takeCashInfoModel bankCardNumberAndPersonName];
                        _bankNameLabel.text = _takeCashInfoModel.bankName;
                        
                        [BWMMBProgressHUD hideHUD:HUD
                                            title:kBWMMBProgressHUDLoadSuccessMsg
                                        hideAfter:kBWMMBProgressHUDHideTimeInterval
                                          msgType:BWMMBProgressHUDMsgTypeSuccessful];
                        // 判断资料是否完善
                        if (![_takeCashInfoModel isCompletion]) {
                            self.completeTipsLabel.hidden = NO;
                        } else {
                            self.bankNameLabel.hidden = NO;
                            self.cardNumberLabel.hidden = NO;
                            self.completeTipsLabel.hidden = YES;
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [BWMMBProgressHUD hideHUD:HUD
                                            title:kBWMMBProgressHUDLoadErrorMsg
                                        hideAfter:kBWMMBProgressHUDHideTimeInterval
                                          msgType:BWMMBProgressHUDMsgTypeError];
                    }];
}

- (IBAction)cashInputTextFieldValueChanged:(UITextField *)sender {
    // 限制金钱字符串格式
    [RegExpValidateFormat formatToPriceStringWithTextField:sender];
    
    // 限制按钮可用状态
    BOOL validated = YES;
    float price = [sender.text floatValue];

    if ((sender.text.length == 0)  || (!(price >= 50)) ) {
        validated = NO;
    }
    
    [self p_takeCashButtonSetEnable:validated];
}

- (IBAction)takeCashButtonClicked:(UIButton *)sender {
    [_cashInputTextField resignFirstResponder];
//    if ([self p_errorMsg]) {
//        return;
//    }
    
    if (![_takeCashInfoModel isCompletion]) {
        [self p_alertWillCompletionInfo];
        return;
    }
    
    // 发送提现请求
    BWMTakeCashPostModel *postModel = [BWMTakeCashPostModel modelWithTotalString:_cashInputTextField.text];
    
    NSLog(@"%@", [postModel getParameterObject]);
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.navigationController.view title:kBWMMBProgressHUDLoadingMsg];
    // 发送请求
    [BWMRequestCenter POST:[BWMTakeCashPostModel API]
                  parameters:[postModel getParameterObject]
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         [BWMMBProgressHUD hideHUD:HUD hideAfter:0];
                         NSLog(@"%@", responseObject);
                         NSLog(@"%@", responseObject[@"errormsg"]);
                         if ([responseObject[@"status"] boolValue]) {
                             [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString
                                                        message:@"恭喜您！申请成功！我们将会在3个工作日内处理您的提现请求，请随时留意手机信息。"
                                                           type:BWMAlertViewTypeSuccess
                                                       targetVC:self
                                                      callBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }];
                         } else {
                             [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString
                                                        message:responseObject[@"errormsg"]
                                                           type:BWMAlertViewTypeInfo
                                                       targetVC:self
                                                      callBlock:nil];
                         }
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         [BWMMBProgressHUD hideHUD:HUD
                                             title:kBWMMBProgressHUDLoadErrorMsg
                                         hideAfter:kBWMMBProgressHUDHideTimeInterval
                                           msgType:BWMMBProgressHUDMsgTypeError];
                         
                         [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString
                                                    message:@"网络故障，申请提现失败！"
                                                       type:BWMAlertViewTypeError
                                                   targetVC:self
                                                  callBlock:nil];
                         
                     }];
}

//- (BOOL)p_errorMsg {
//    // 判断
//    NSString *errorMsg = nil;
//    if (_takeCashInfoModel.bankName.length == 0) {
//        errorMsg = @"银行名称不能为空";
//    } else if (![BWMBankCoder hasBankName:_takeCashInfoModel.bankName]) {
//        errorMsg = @"不支持此银行的提现！";
//    } else if (_takeCashInfoModel.bankUserName.length == 0) {
//        errorMsg = @"持卡人姓名不能为空！";
//    }
//    
//    if (errorMsg) {
//        [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString
//                                   message:errorMsg
//                                      type:BWMAlertViewTypeError
//                                  targetVC:self
//                                 callBlock:nil];
//        return YES;
//    }
//    
//    return NO;
//}

- (void)p_takeCashButtonSetEnable:(BOOL)enable {
    if (enable) {
        _takeCashButton.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
        _takeCashButton.enabled = YES;
    } else {
        _takeCashButton.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
        _takeCashButton.enabled = NO;
    }
}

- (void)p_alertWillCompletionInfo {
    [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString message:@"您需要补充银行卡资料，方便我们塞钱给你..." type:BWMAlertViewTypeInfo targetVC:self OKcallBlock:^(BWMAlertView<BWMAlertView> *alertView) {
        BWMInputBankAccountViewController *vc = [BWMInputBankAccountViewController viewController];
        [self.navigationController pushViewController:vc animated:YES];
    } CancelcallBlock:nil];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        BWMInputBankAccountViewController *vc = [BWMInputBankAccountViewController viewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
