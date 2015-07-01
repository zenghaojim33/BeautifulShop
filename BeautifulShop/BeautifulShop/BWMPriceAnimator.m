//
//  BWMPriceAnimater.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMPriceAnimator.h"

@interface BWMPriceAnimator() {
    NSTimeInterval _steperNumber;
    float _originalPrice;
    float _currentNumber;
}

@end

@implementation BWMPriceAnimator

- (instancetype)init {
    if (self = [super init]) {
        self.animationDuration = 1.0f;
        _currentNumber = 0.0f;
    }
    return self;
}

+ (void)animatorExecuteWithLables:(NSArray *)lables {
    [lables enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        BWMPriceAnimator *animator = [[BWMPriceAnimator alloc] initWithTargetLabel:label animationDuration:2.0f willCutoffMoneySymbol:@"￥"];
        [animator startAscendingAnimation];
    }];
}

- (instancetype)initWithTargetLabel:(UILabel *)targetLabel animationDuration:(NSTimeInterval)animationDuration willCutoffMoneySymbol:(NSString *)willCutoffMoneySymbol {
    if (self = [self init]) {
        self.targetLabel = targetLabel;
        self.animationDuration = animationDuration;
        self.willCutoffMoneySymbol = willCutoffMoneySymbol;
        
        _originalPrice = [[self.targetLabel.text stringByReplacingOccurrencesOfString:willCutoffMoneySymbol withString:@""] floatValue];
        _steperNumber = _animationDuration / _originalPrice;
        
    }
    
    return self;
}

- (void)startAscendingAnimation {
    _timer = [NSTimer scheduledTimerWithTimeInterval:_steperNumber target:self selector:@selector(p_priceAnimation:) userInfo:nil repeats:YES];
}

- (void)p_priceAnimation:(NSTimer *)timer {
    _currentNumber += 20.01f;
    if (_currentNumber >= _originalPrice) {
        [timer invalidate];
        _timer = nil;
        self.targetLabel.text = [NSString stringWithFormat:@"%@%.2f", _willCutoffMoneySymbol, _originalPrice];
        return;
    }
    
    self.targetLabel.text = [NSString stringWithFormat:@"%@%.2f", _willCutoffMoneySymbol, _currentNumber];
}

- (void)dealloc {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}


@end
