//
//  BWMTipsView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/15.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMTipsView;

extern NSString * kTipsViewNoProductTips;
extern NSString * kTipsViewNoSearchResultTips;

@protocol BWMTipsViewDelegate <NSObject>

- (void)tipsViewTaped:(BWMTipsView *)tipsView;

@end

@interface BWMTipsView : UIView

@property (nonatomic, strong) NSString *imageNamed;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, weak) id<BWMTipsViewDelegate> delegate;

+ (instancetype)tipsViewWithImageNamed:(NSString *)imageNamed
                                 title:(NSString *)title
                              delegate:(id<BWMTipsViewDelegate>)delegate;

+ (instancetype)putawayTipsViewWithDelegate:(id<BWMTipsViewDelegate>)delegate;

@end
