//
//  ChangeInfoViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BWMViewController.h"

@class ChangeInfoViewController;

@protocol ChangeInfoViewControllerDelegate <NSObject>

@optional
- (void)changeInfoViewControllerDidSuccessfulChangeInfo:(ChangeInfoViewController *)viewController;

@end

@interface ChangeInfoViewController : BWMViewController
@property(nonatomic)BOOL isChange;

@property (weak, nonatomic) id<ChangeInfoViewControllerDelegate> delegate;

+ (instancetype)viewController;
@end
