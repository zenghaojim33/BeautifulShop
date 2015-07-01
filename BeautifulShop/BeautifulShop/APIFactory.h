//
//  APIManager.h
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIFactory : NSObject

/** 图片服务器地址 */
+ (NSString *)imageServerURLString;

/** API服务器地址 */
+ (NSString *)APIServerURLString;

/** 拼接的完整API地址 */
+ (NSString *)APICompletionServerURLStringWithSegment:(NSString *)segmentURLString;

/** 拼接的完整图片地址URL */
+ (NSURL *)imageCompletionURLWithSegment:(NSString *)segmentImageURLString;

/** 拼接的完整图片地址String */
+ (NSString *)imageCompletionStringWithSegment:(NSString *)segmentImageURLString;

@end
