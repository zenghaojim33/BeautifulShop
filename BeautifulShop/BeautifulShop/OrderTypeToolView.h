//
//  OrderTypeToolView.h
//  Test
//
//  Created by 伟明 毕 on 15/4/5.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderTypeToolView;

@protocol OrderTypeToolViewDelegate <NSObject>

- (void)toolView:(OrderTypeToolView *)toolView didSelectRow:(NSInteger)row button:(UIButton *)button title:(NSString *)title;

@end

/** 按钮选项卡滚动视图（对BWMTabCardView的具体应用） */
@interface OrderTypeToolView : UIView

/** STEP1、按钮的标题数组 */
@property (strong, nonatomic, readwrite) NSArray *buttonTitles;

@property (weak, nonatomic, readwrite) id<OrderTypeToolViewDelegate> delegate;

/** STEP2、创建UI */
- (void)createUI;

/** 创建OrderTypeToolView */
+ (OrderTypeToolView *)createWithFrame:(CGRect)frame
                              delegate:(id<OrderTypeToolViewDelegate>)delegate;

@end
