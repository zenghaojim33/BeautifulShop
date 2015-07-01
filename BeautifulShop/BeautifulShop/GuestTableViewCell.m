//
//  GuestTableViewCell.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-21.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GuestTableViewCell.h"
#import "UIView+BWMExtension.h"

@implementation GuestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_BGView drawingDefaultStyleShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
