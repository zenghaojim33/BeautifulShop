//
//  UITextField+Extension.m
//  ControlBeauty
//
//  Created by Bi Weiming on 15/4/9.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

- (void)cb_setDefaultStyleTextField {
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:0.3].CGColor;
    self.layer.cornerRadius = 8.0f;
}

@end
