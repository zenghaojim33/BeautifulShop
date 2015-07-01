//
//  NSBundle+BWM_Bundle.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (BWMBundle)

/** 从XIB中加载一个视图 */
+ (id)loadViewWithNibNamed:(NSString *)nibNamed;

@end
