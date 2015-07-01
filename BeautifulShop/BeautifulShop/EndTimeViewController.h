//
//  EndTimeViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-31.
//  Copyright (c) 2014年 jenk. All rights reserved.
//
@protocol EndTimeDelegate;
#import <UIKit/UIKit.h>

@interface EndTimeViewController : UIViewController
@property(nonatomic,strong)NSString *StartTimeStr;
@property(nonatomic,strong)id<EndTimeDelegate>delegate;
@end
@protocol EndTimeDelegate <NSObject>

-(void)SetEndTimeStr:(NSString*)endTimeStr;

@end