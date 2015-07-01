//
//  BWMProductCell.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMProductCell.h"
#import "UIView+BWMExtension.h"
#import "BWMProductModel.h"
#import "BeautifulShop-Swift.h"

@interface BWMProductCell() {
    BWMProductModel *_model;
}

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *weiPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UIButton *reqeustLinkBtn;
@property (strong, nonatomic) IBOutlet UIButton *shareBtn;

@property (strong, nonatomic) IBOutlet UIView *infoBgView;
@end

@implementation BWMProductCell

- (void)awakeFromNib {
    [_containerView drawingDefaultStyleShadow];
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(infoBgViewTaped:)];
    [self.infoBgView addGestureRecognizer:tap];
}

- (void)infoBgViewTaped:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(productCell:infoBgViewTaped:model:)]) {
        [_delegate productCell:self infoBgViewTaped:tap.view model:_model];
    }
}

- (void)updateWithModel:(BWMProductModel *)model {
    _model = model;
    
    [_myImageView sd_setImageWithURL:model.imageURL
                    placeholderImage:[UIImage imageNamed:@"product_placeholder"]
                             options:SDWebImageRefreshCached];
    
    self.titleLabel.text = model.productName;
    self.sizeLabel.text = model.size;
    self.storeCountLabel.text = model.storeCountString;
    self.weiPriceLabel.text = model.weiPriceString;
    self.marketPriceLabel.attributedText = model.marketPriceAttributeString;
}

- (IBAction)addBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        [_myImageView bwm_transferToPoint:CGPointMake(270, 30)];
    }
    
    if ([_delegate respondsToSelector:@selector(productCell:addBtnClicked:model:)]) {
        [_delegate productCell:self addBtnClicked:sender model:_model];
    }
}

- (IBAction)requestLinkBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(productCell:requestLinkBtnClicked:model:)]) {
        [_delegate productCell:self requestLinkBtnClicked:sender model:_model];
    }
}

- (IBAction)shareBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(productCell:shareBtnClicked:model:)]) {
        [_delegate productCell:self shareBtnClicked:sender model:_model];
    }
}

- (void)selectedAddBtn:(BOOL)selected {
    self.addBtn.selected = selected;
}

+ (CGFloat)height {
    return 148.0f;
}

@end
