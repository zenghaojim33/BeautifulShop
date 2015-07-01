//
//  BWMPriceAnimater.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  价格上升的动画效果 BWMPriceAnimator
 */
@interface BWMPriceAnimator : NSObject

@property (weak, nonatomic, readwrite) UILabel *targetLabel;
@property (assign, nonatomic, readwrite) NSTimeInterval animationDuration;
@property (assign, nonatomic, readwrite) NSString *willCutoffMoneySymbol;
@property (strong, nonatomic, readonly) NSTimer *timer;

/**
 *  初始化BWMPriceAnimator实例
 *
 *  @param targetLabel           目标UILabel
 *  @param animationDuration     动画的持续时间
 *  @param willCutoffMoneySymbol 特殊字符
 *
 *  @return BWMPriceAnimator实例
 */
- (instancetype)initWithTargetLabel:(UILabel *)targetLabel
                  animationDuration:(NSTimeInterval)animationDuration
              willCutoffMoneySymbol:(NSString *)willCutoffMoneySymbol;

/**
 *  开始动画
 */
- (void)startAscendingAnimation;

/**
 *  轮询执行BWMPriceAnimator
 *
 *  @param lables UILabel的组成的数组
 */
+ (void)animatorExecuteWithLables:(NSArray *)lables;

@end
