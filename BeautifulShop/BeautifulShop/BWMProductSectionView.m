//
//  BWMProductSectionView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMProductSectionView.h"
#import "UIView+BWMExtension.h"

@interface BWMProductSectionView() {
    
}
@property (strong, nonatomic) IBOutlet UIButton *putawayBtn;
@property (strong, nonatomic) IBOutlet UIButton *salesBtn;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end

@implementation BWMProductSectionView

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    [_containerView drawingDefaultStyleShadow];
}

- (IBAction)buttonClicked:(UIButton *)sender {
    if (sender == nil) return;
    [UIView animateWithDuration:0.5 animations:^{
        _bottomLine.center = CGPointMake(sender.center.x, _bottomLine.center.y);
    }];
    
    [[self p_buttons] enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL *stop) {
        obj.selected = obj == sender;
    }];
    
    if (_delegate) {
        if (sender == _putawayBtn) {
            [_delegate sectionView:self putawayBtnClicked:sender];
        } else {
            [_delegate sectionView:self salesBtnClicked:sender];
        }
    }
}

- (NSArray *)p_buttons {
    return @[self.putawayBtn, self.salesBtn];
}

+ (instancetype)sectionViewWithDelegate:(id<BWMProductSectionViewDelegate>)delegate {
    BWMProductSectionView *sectionView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    sectionView.delegate = delegate;
    return sectionView;
}

+ (CGFloat)height {
    return 44.0f;
}

@end
