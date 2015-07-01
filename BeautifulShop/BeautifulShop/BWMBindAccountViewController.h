//
//  BWMBindAccountViewController.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/12.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMViewController.h"

@class BWMBindAccountViewController;

@protocol BWMBindAccountViewControllerDelegate <NSObject>

- (void)bindAccountViewController:(BWMBindAccountViewController *)viewController didSuccessfulBindingPhone:(NSString *)phone;

@end

@interface BWMBindAccountViewController : BWMViewController

@property (weak, nonatomic) id<BWMBindAccountViewControllerDelegate> delegate;

@end
