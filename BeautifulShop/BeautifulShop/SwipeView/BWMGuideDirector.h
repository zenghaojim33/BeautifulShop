//
//  BWMGuideDirector.h
//  BeautifulShop
//
//  Created by btw on 15/3/10.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWMGuideDirector : NSObject

@property (weak, nonatomic) UIViewController *targetViewController;

/** 初始化BWMGuideDirector */
- (instancetype)initWithViewController:(UIViewController *)targetViewController;

/** 应用第一次启动的时候显示ViewController */
- (void)showGuideViewController;

/** 无条件显示ViewController */
- (void)showGuideViewControllerAlway;

@end
