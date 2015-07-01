//
//  BWMGuideDirector.m
//  BeautifulShop
//
//  Created by btw on 15/3/10.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMGuideDirector.h"
#import "BWMSystemConfigurationManager.h"
#import "BWMGuideViewController.h"

static BWMGuideDirector *_guideDirector = nil;

@interface BWMGuideDirector() {
    BWMSystemConfigurationManager *_systemConfigManager;
}
@end

@implementation BWMGuideDirector

- (instancetype)initWithViewController:(UIViewController *)targetViewController {
    if (self = [self init]) {
        _targetViewController = targetViewController;
        NSLog(@"%@", NSHomeDirectory());
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _systemConfigManager = [BWMSystemConfigurationManager sharedSystemConfigurationManager];
    }
    return self;
}

- (void)showGuideViewController {
    if ([_systemConfigManager isFirstLaunching]) {
        [self presentViewController];
    }
}

- (void)showGuideViewControllerAlway {
    [self presentViewController];
}

- (void)presentViewController {
    UIViewController *guideViewController = [[BWMGuideViewController alloc] init];
    [_targetViewController presentViewController:guideViewController animated:NO completion:nil];
}

@end
