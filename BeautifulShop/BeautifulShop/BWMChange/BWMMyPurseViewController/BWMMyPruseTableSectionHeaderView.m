//
//  BWMMyPruseTableSectionHeaderView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyPruseTableSectionHeaderView.h"
#import "UIColorFactory.h"

@interface BWMMyPruseTableSectionHeaderView() {
    UIView *_backgroundView;
    UIButton *_currentSelecteButton;
    UIButton *_firstButton;
}

@end

@implementation BWMMyPruseTableSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *buttonTitles = @[@"收入详情", @"提现详情", @"全部"];
        CGFloat width = self.frame.size.width/3.0f;
        CGFloat height = self.frame.size.height;
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _backgroundView.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
        [self addSubview:_backgroundView];
        
        [buttonTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(idx*width, 0, width, height);
            [button setTitle:title forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            button.tag = idx;
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            if (idx == 0) {
                _firstButton = button;
                _currentSelecteButton = button;
                [button setSelected:YES];
            }
        }];
        
        UIView *bottomLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        bottomLabelView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:bottomLabelView];
    }
    
    return self;
}

- (void)buttonClicked:(UIButton *)button {
    if (_currentSelecteButton == button) {
        return;
    }
    
    _currentSelecteButton.selected = NO;

    [UIView animateWithDuration:0.2 animations:^{
        _backgroundView.frame = button.frame;
        _backgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if (_delegate) [_delegate sectionHeaderView:self buttonClicked:button tag:button.tag];
        button.selected = YES;
        _currentSelecteButton = button;
    }];
}

+ (CGFloat)height {
    return 40.0f;
}

- (void)scrollToFirstElement {
    _currentSelecteButton.selected = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        _backgroundView.frame = _firstButton.frame;
        _backgroundView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        _firstButton.selected = YES;
        _currentSelecteButton = _firstButton;
    }];
}

@end
