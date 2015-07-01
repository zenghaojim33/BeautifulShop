//
//  UIStoryboard+BWMStoryboard.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (BWMStoryboard)

/** 从MainStoryboard里面加载一个ViewController */
+ (id)initVCOnMainStoryboardWithID:(NSString *)identitier;

/** 从BWMStoryboard里面加载一个ViewController */
+ (id)initVCOnBWMStoryboardWithID:(NSString *)identitier;

@end
