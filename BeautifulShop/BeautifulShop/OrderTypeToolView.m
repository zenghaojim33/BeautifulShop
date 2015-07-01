//
//  OrderTypeToolView.m
//  Test
//
//  Created by 伟明 毕 on 15/4/5.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "OrderTypeToolView.h"
#import "BWMTabCardView.h"

@interface OrderTypeToolView() <BWMTabCardViewDataSource, BWMTabCardViewDelegate> {
    UIButton *_selectedButton;
}

@end

@implementation OrderTypeToolView

+ (OrderTypeToolView *)createWithFrame:(CGRect)frame
                              delegate:(id<OrderTypeToolViewDelegate>)delegate {
    OrderTypeToolView *toolView = [[OrderTypeToolView alloc] initWithFrame:frame];
    toolView.delegate = delegate;
    toolView.buttonTitles = @[@"未付款", @"待发货", @"待签收", @"已到货", @"申请退货", @"同意退货", @"不同意退货", @"退货成功", @"完成订单"];
    [toolView createUI];
    return toolView;
}

- (void)createUI {
    BWMTabCardView *tabCardView = [[BWMTabCardView alloc] initWithFrame:self.bounds];
    tabCardView.backgroundColor = [UIColor clearColor];
    tabCardView.delegate = self;
    tabCardView.dataSource = self;
    [self addSubview:tabCardView];
}

#pragma mark- BWMTabCardViewDataSource
- (NSInteger)numberOfRowsInTabCardView:(BWMTabCardView *)tabCardView {
    return _buttonTitles.count;
}

- (UIView *)tabCardView:(BWMTabCardView *)tabCardView viewForRow:(NSInteger)row {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    CGFloat width = 79.4;
    button.frame = CGRectMake(0, 1, width, self.frame.size.height-2);
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    [button setTitle:_buttonTitles[row] forState:UIControlStateNormal];
    
    if (row == 0) {
        button.selected = YES;
        _selectedButton = button;
    }
    
    return button;
}

- (CGFloat)tabCardView:(BWMTabCardView *)tabCardView separatorLineWidthForRow:(NSInteger)row {
    return 1.0f;
}

#pragma mark- BWMTabCardViewDelegate
- (void)tabCardView:(BWMTabCardView *)tabCardView didSelectRow:(NSInteger)row view:(UIView *)view {
    UIButton *button = (UIButton *)view;
    
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    
    if(_delegate) [_delegate toolView:self didSelectRow:row button:button title:_buttonTitles[row]];
}

@end
