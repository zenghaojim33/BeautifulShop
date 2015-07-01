//
//  UITableView+BWMTableView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 此分类，用于添加指定视图到TableView */
@interface UITableView (BWMTableView)

/** 添加视图到TableView的中间 */
- (UIView *)bwm_addViewToCenter:(UIView *)view;

/** 添加视图到的TableView指定的Point */
- (UIView *)bwm_addView:(UIView *)view toPoint:(CGPoint)point;

/** 添加一个Label到中间，通常用于消息提示 */
- (UILabel *)bwm_addLabelToCenterWithText:(NSString *)text;

/** 添加一个Label到指定的Point，通常用于消息提示 */
- (UILabel *)bwm_addLabelWithText:(NSString *)text toPoint:(CGPoint)point;

/** 添加一个提示视图到的tableFooterView，通常用于消息提示  */
- (UIView *)bwm_addTipsViewWithTitle:(NSString *)title height:(CGFloat)height;

/** 移除TipsView */
- (void)bwm_removeTipsView;

/** 移除附加上去的View */
- (void)bwm_removeView;

/** 隐藏分割线 */
- (void)bwm_hideSeparatorLines;

/** 注册Cell */
- (void)bwm_registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier;

@end
