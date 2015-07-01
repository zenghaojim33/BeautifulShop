//
//  SFVCProtocol.h
//  SeafoodHome
//
//  Created by btw on 15/2/17.
//  Copyright (c) 2015年 beautyway. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 需要加载网络API的ViewController Protocol */
@protocol BWMNetVCProtocol <NSObject>

@required
/**
 *  创建UI
 */
- (void)createUI;

@optional
/**
 *  创建数据
 */
- (void)createData;

/**
 *  刷新数据
 */
- (void)refreshData;

/**
 *  下拉加载更多
 */
- (void)loadMore;

/**
 *  解析数据
 *
 *  @param responseDict 传入数据字典
 */
- (void)analysisDataWithResponseDict:(NSDictionary *)responseDict;

@end
