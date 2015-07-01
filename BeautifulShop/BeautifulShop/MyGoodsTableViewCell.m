//
//  MyGoodsTableViewCell.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-14.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MyGoodsTableViewCell.h"
#import "UIView+BWMExtension.h"
#import "BeautifulShop-Swift.h"

@implementation MyGoodsTableViewCell

- (void)awakeFromNib {
    [_containerView drawingDefaultStyleShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)TouchAdd:(UIButton *)sender {
    NSLog(@"TouchAdd");
    
    if(sender.selected == NO) {
        sender.selected = YES;
        [self.GoodImageView bwm_transferToPoint:CGPointMake(270, 30)];
    } else {
        sender.selected = NO;
    }
    
    [self.delegate TouchAddButtonForTag:(int)self.tag IsBool:sender.selected AndButton:sender];
}

- (IBAction)TouchCopy:(UIButton *)sender {
    NSLog(@"TouchCopy");
    [self.delegate TouchCopyForCellTag:(int)self.tag];
}

- (IBAction)TouchShare:(UIButton *)sender {
    NSLog(@"TouchShare");
    [self.delegate TouchShareForCellTag:(int)self.tag];
}

- (IBAction)TouchCell:(UIButton *)sender {
    [self.delegate TouchCellForTag:(int)self.tag];
}

@end
