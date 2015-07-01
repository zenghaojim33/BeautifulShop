//
//  BWMTabCardView.h
//  Test
//
//  Created by 伟明 毕 on 15/4/5.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMTabCardView;

@protocol BWMTabCardViewDelegate <NSObject>
@optional
- (void)tabCardView:(BWMTabCardView *)tabCardView didSelectRow:(NSInteger)row view:(UIView *)view;

@end

@protocol BWMTabCardViewDataSource <NSObject>

- (NSInteger)numberOfRowsInTabCardView:(BWMTabCardView *)tabCardView;
- (UIView *)tabCardView:(BWMTabCardView *)tabCardView viewForRow:(NSInteger)row;
- (CGFloat)tabCardView:(BWMTabCardView *)tabCardView separatorLineWidthForRow:(NSInteger)row;

@end

/** 选项卡视图，主要功能是点击其中的view会自动滚动到此view的中间，具体的应用请查看OrderTypeToolView */
@interface BWMTabCardView : UIView

@property (weak, nonatomic, readwrite) id<BWMTabCardViewDataSource> dataSource;
@property (weak, nonatomic, readwrite) id<BWMTabCardViewDelegate> delegate;
@property (strong, nonatomic, readonly) UIScrollView *scrollView;

- (void)reloadData;

@end
