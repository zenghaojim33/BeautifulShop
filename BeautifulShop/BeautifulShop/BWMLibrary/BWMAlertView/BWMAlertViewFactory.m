//
//  BWMAlertViewFactory.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMAlertViewFactory.h"

// 所使用的AlertView的类名
static NSString * const kCalssName = @"BWMSCLAlertView";

@implementation BWMAlertViewFactory
+ (BWMAlertView<BWMAlertView> *)createWithTitle:(NSString *)title
                                       message:(NSString *)message
                                          type:(BWMAlertViewType)alertViewType
                                      targetVC:(UIViewController *)vc{
    
    BWMAlertView<BWMAlertView> *alertView = [[NSClassFromString(kCalssName) alloc] initWithTitle:title message:message type:alertViewType targetVC:vc];
    return alertView;
}

+ (BWMAlertView<BWMAlertView> *)showMessage:(NSString *)message {
    BWMAlertView<BWMAlertView> *alertView = [[NSClassFromString(kCalssName) alloc] initWithTitle:@"提示" message:message type:BWMAlertViewTypeInfo targetVC:nil];
    [alertView addButtonWithTitle:@"确定" buttonType:BWMAlertViewButtonTypeOKey callBlock:nil];
    [alertView show];
    return alertView;
}

+ (BWMAlertView<BWMAlertView> *)showWithTitle:(NSString *)title
                                      message:(NSString *)message
                                         type:(BWMAlertViewType)type
                                     targetVC:(UIViewController *)targetVC
                                    callBlock:(BWMAlertViewTaskBlock)callBlock {
    
    BWMAlertView<BWMAlertView>* alertView = [self createWithTitle:title message:message type:type targetVC:targetVC];
    [alertView addButtonWithTitle:kAlertViewOkeyBtnString buttonType:BWMAlertViewButtonTypeOKey callBlock:callBlock];
    [alertView show];
    return alertView;
}

+ (BWMAlertView<BWMAlertView> *)showWithTitle:(NSString *)title
                                      message:(NSString *)message
                                         type:(BWMAlertViewType)type
                                     targetVC:(UIViewController *)targetVC
                                  OKcallBlock:(BWMAlertViewTaskBlock)OKcallBlock
                              CancelcallBlock:(BWMAlertViewTaskBlock)CancelcallBlock {
    
    BWMAlertView<BWMAlertView>* alertView = [self createWithTitle:title message:message type:type targetVC:targetVC];
    [alertView addButtonWithTitle:kAlertViewOkeyBtnString buttonType:BWMAlertViewButtonTypeOKey callBlock:OKcallBlock];
    [alertView addButtonWithTitle:kAlertViewCancelBtnString buttonType:BWMAlertViewButtonTypeCancel callBlock:CancelcallBlock];
    [alertView show];
    return alertView;
}

@end
