//
//  UIButton+Extension.m
//  ControlBeauty
//
//  Created by Bi Weiming on 15/4/9.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)cb_setDefaultStyleButton {
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:0.3].CGColor;
    self.layer.borderWidth = 1.0f;
}

@end
