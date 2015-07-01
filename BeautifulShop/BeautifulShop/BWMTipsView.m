//
//  BWMTipsView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/15.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMTipsView.h"

NSString * kTipsViewNoProductTips = @"您还没有上架货品，猛戳这里添加您的货品！" ;
NSString * kTipsViewNoSearchResultTips = @"暂无符合条件的商品";

@interface BWMTipsView() {
    
}
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end

@implementation BWMTipsView

- (void)awakeFromNib {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerViewTaped:)];
    [_containerView addGestureRecognizer:tap];
}

- (void)containerViewTaped:(UITapGestureRecognizer *)recognizer {
    if ([_delegate respondsToSelector:@selector(tipsViewTaped:)]) {
        [_delegate tipsViewTaped:self];
    }
}

- (void)setImageNamed:(NSString *)imageNamed {
    _imageNamed = imageNamed;
    _iconImageView.image = [UIImage imageNamed:imageNamed];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

+ (instancetype)tipsViewWithImageNamed:(NSString *)imageNamed
                                 title:(NSString *)title
                              delegate:(id<BWMTipsViewDelegate>)delegate
{
    BWMTipsView *tipsView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    tipsView.title = title;
    tipsView.imageNamed = imageNamed;
    tipsView.delegate = delegate;
    return tipsView;
}

+ (instancetype)putawayTipsViewWithDelegate:(id<BWMTipsViewDelegate>)delegate {
    return [[self class] tipsViewWithImageNamed:@"bwm_add_product_icon" title:kTipsViewNoProductTips delegate:delegate];
}

@end
