//
//  BWMRedButton.h
//  BeautifulShop
//
//  Created by btw on 15/3/12.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWMRedButton : UIButton

+ (BWMRedButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector;

- (void)drawingButtonOfTick;
- (void)setUnactivity;
- (void)setActivity;

@end
