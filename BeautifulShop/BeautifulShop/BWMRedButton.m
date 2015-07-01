//
//  BWMRedButton.m
//  BeautifulShop
//
//  Created by btw on 15/3/12.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMRedButton.h"
#import "UIColorFactory.h"

@implementation BWMRedButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configUI];
}

- (void)configUI {
    self.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2.5f;
}

+ (BWMRedButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target selector:(SEL)selector {
    BWMRedButton *button = [[BWMRedButton alloc] initWithFrame:frame];
    [button configUI];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)setUnactivity {
    self.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
    self.enabled = NO;
}

- (void)setActivity {
    self.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
    self.enabled = YES;
}

- (void)drawingButtonOfTick {
    [self setImage:[UIImage imageNamed:@"上方按钮_确定.png"] forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, -3, -2, 0)];
}

@end
