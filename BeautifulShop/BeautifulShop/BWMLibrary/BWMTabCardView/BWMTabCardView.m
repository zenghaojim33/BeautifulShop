//
//  BWMTabCardView.m
//  Test
//
//  Created by 伟明 毕 on 15/4/5.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMTabCardView.h"

typedef struct {
    unsigned int didSelectRow : 1;
}DelegateResponse;


@interface BWMTabCardView() {
    NSInteger _rowNumber;
    UIView *_reusingView;
    DelegateResponse _delegateResponse;
}
@end

@implementation BWMTabCardView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_scrollView];
    }
    
    return self;
}

- (void)reloadData {
    [_scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view removeFromSuperview];
    }];
    
    _rowNumber = [_dataSource numberOfRowsInTabCardView:self];
    
    for (NSInteger i = 0; i<_rowNumber; i++) {
        UIView *theView = [_dataSource tabCardView:self viewForRow:i];
        
        CGFloat prevX = -1.0f;
        if (i != 0) {
            UIView *prevView = [_scrollView.subviews objectAtIndex:i-1];
            prevX = prevView.frame.size.width + prevView.frame.origin.x;
        }
        
        
        CGRect theFrame = theView.frame;
        theFrame.origin.x = prevX + [_dataSource tabCardView:self separatorLineWidthForRow:i];
        theView.frame = theFrame;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_viewTaped:)];
        [theView addGestureRecognizer:tap];
        theView.tag = i;
        
        [_scrollView addSubview:theView];
        
        if (i == _rowNumber-1) {
            _scrollView.contentSize = CGSizeMake(theView.frame.size.width+theView.frame.origin.x, CGRectGetHeight(_scrollView.frame));
            _scrollView.bounces = NO;
            _scrollView.showsHorizontalScrollIndicator = NO;
        }
    }
}

- (void)p_viewTaped:(UITapGestureRecognizer *)recognizer {
    if (_delegateResponse.didSelectRow) {
        [_delegate tabCardView:self didSelectRow:recognizer.view.tag view:recognizer.view];
        
        CGFloat offsetX = recognizer.view.center.x - _scrollView.center.x;
        if (offsetX > _scrollView.contentSize.width-_scrollView.frame.size.width) {
            offsetX = _scrollView.contentSize.width-_scrollView.frame.size.width;
        } else if (offsetX < 0) {
            offsetX = 0;
        }
        CGPoint point = CGPointMake(offsetX, 0);
        [_scrollView setContentOffset:point animated:YES];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _scrollView.frame = frame;
}

- (void)setDelegate:(id<BWMTabCardViewDelegate>)delegate {
    _delegate = delegate;
    
    if ([_delegate respondsToSelector:@selector(tabCardView:didSelectRow:view:)]) {
        _delegateResponse.didSelectRow = YES;
    }
    [self reloadData];
}

- (void)setDataSource:(id<BWMTabCardViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}

@end
