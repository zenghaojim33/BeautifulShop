//
//  StartTimeViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-31.
//  Copyright (c) 2014年 jenk. All rights reserved.
//
@protocol StartimeDelegate;
#import <UIKit/UIKit.h>

@interface StartTimeViewController : UIViewController
@property(nonatomic,strong)id<StartimeDelegate>delegate;
@end
@protocol StartimeDelegate <NSObject>

-(void)SetStartTimteStr:(NSString*)startTimeStr;

@end