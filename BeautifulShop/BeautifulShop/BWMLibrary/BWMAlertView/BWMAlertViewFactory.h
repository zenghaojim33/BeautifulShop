//
//  BWMAlertViewFactory.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMAlertView.h"

/** 生产BWMAlertView的简单工厂 */
@interface BWMAlertViewFactory : NSObject

/** 创建一个BWMAlertView */
+ (BWMAlertView<BWMAlertView> *)createWithTitle:(NSString *)title
                                       message:(NSString *)message
                                          type:(BWMAlertViewType)alertViewType
                                      targetVC:(UIViewController *)vc;

/** 显示一个有确认的按钮的提示框 */
+ (BWMAlertView<BWMAlertView> *)showMessage:(NSString *)message;

/** 显示一个包含确定按钮和回调的提示框 */
+ (BWMAlertView<BWMAlertView> *)showWithTitle:(NSString *)title
                                      message:(NSString *)message
                                         type:(BWMAlertViewType)type
                                     targetVC:(UIViewController *)targetVC
                                    callBlock:(BWMAlertViewTaskBlock)callBlock;

/** 显示一个包含确定和取消按钮和带回调的提示框 */
+ (BWMAlertView<BWMAlertView> *)showWithTitle:(NSString *)title
                                      message:(NSString *)message
                                         type:(BWMAlertViewType)type
                                     targetVC:(UIViewController *)targetVC
                                    OKcallBlock:(BWMAlertViewTaskBlock)OKcallBlock
                                  CancelcallBlock:(BWMAlertViewTaskBlock)CancelcallBlock;

@end