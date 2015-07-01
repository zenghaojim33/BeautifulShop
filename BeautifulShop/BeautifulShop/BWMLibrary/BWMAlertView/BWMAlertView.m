//
//  BWMAlertView.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/28.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMAlertView.h"

@implementation BWMAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message type:(BWMAlertViewType)type targetVC:(UIViewController *)targetVC {
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.type = type;
        self.targetViewController = targetVC;
    }
    return self;
}

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"BWMAlertView dealloc");
}
#endif

@end
