//
//  BWMTextField.m
//  BeautifulShop
//
//  Created by btw on 15/3/9.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMTextField.h"

@implementation BWMTextField

//  控制 placeHolder 的位置，左右缩 20
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds , 10 , 0 );
}

//  控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds , 10 , 0 );
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0f;
}

@end
