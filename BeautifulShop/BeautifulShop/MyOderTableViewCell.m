//
//  MyOderTableViewCell.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-16.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MyOderTableViewCell.h"
#import "UIView+BWMExtension.h"

@implementation MyOderTableViewCell

- (void)awakeFromNib {
    [_bgView drawingDefaultStyleShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
