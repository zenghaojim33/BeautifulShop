//
//  UITableView+BWMTableView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "UITableView+BWMTableView.h"

static const NSInteger p_viewTag = 765;
static const NSInteger p_viewTag2 = 766;

@implementation UITableView (BWMTableView)

- (void)bwm_registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
}

- (void)bwm_hideSeparatorLines {
    if(self.tableFooterView == nil)
    self.tableFooterView = [[UIView alloc] init];
}

- (UIView *)bwm_addViewToCenter:(UIView *)view {
    [self bwm_removeView];
    view.tag = p_viewTag2;
    [self addSubview:view];
    
    view.center = CGPointMake(self.center.x, self.center.y + 10);
    view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        view.center = self.center;
        view.alpha = 1.0f;
    }];
    
    return view;
}

- (UIView *)bwm_addView:(UIView *)view toPoint:(CGPoint)point {
    [self bwm_removeView];
    view.tag = p_viewTag2;
    [self addSubview:view];
    
    view.center = CGPointMake(point.x, point.y + 10);
    view.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        view.center = point;
        view.alpha = 1.0f;
    }];
    
    return view;
}

- (UILabel *)bwm_addLabelToCenterWithText:(NSString *)text {
    [self bwm_removeView];
    UILabel *label = [self p_labelWithText:text];
    label.center = CGPointMake(self.center.x, self.center.y + 10);
    label.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        label.center = self.center;
        label.alpha = 1.0f;
    }];
    
    return label;
}

- (UILabel *)bwm_addLabelWithText:(NSString *)text toPoint:(CGPoint)point {
    [self bwm_removeView];
    UILabel *label = [self p_labelWithText:text];
    label.center = CGPointMake(point.x, point.y + 10);
    label.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        label.center = point;
        label.alpha = 1.0f;
    }];
    
    return label;
}

- (void)bwm_removeView {
    [self p_moveTheView:[self viewWithTag:p_viewTag]];
    [self p_moveTheView:[self viewWithTag:p_viewTag2]];
}

- (UIView *)bwm_addTipsViewWithTitle:(NSString *)title height:(CGFloat)height{
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), height)];
    tipsView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [self p_labelWithText:title];
    [tipsView addSubview:label];

    CGPoint myCenter = tipsView.center;
    myCenter.y += 10;
    
    label.center = myCenter;
    label.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        label.center = tipsView.center;
        label.alpha = 1.0f;
    }];
    self.tableFooterView = tipsView;
    return tipsView;
}

- (void)bwm_removeTipsView {
    self.tableFooterView = nil;
}

#pragma mark- Private Methods

- (void)p_moveTheView:(UIView *)view {
    if (view) {
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0.0f;
            view.transform = CGAffineTransformMakeRotation(-M_PI * 0.5);
            view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            [view removeFromSuperview];
        }];
    }
}

- (UILabel *)p_labelWithText:(NSString *)text {
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    label.tag = p_viewTag;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.text = text;
    return label;
}

@end
