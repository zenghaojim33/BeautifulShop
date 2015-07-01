//
//  GuestManagementTableViewCell.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GuestManagementTableViewCell.h"
#import "UIView+BWMExtension.h"

@implementation GuestManagementTableViewCell

- (void)awakeFromNib {
    [_BGView drawingDefaultStyleShadow];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
