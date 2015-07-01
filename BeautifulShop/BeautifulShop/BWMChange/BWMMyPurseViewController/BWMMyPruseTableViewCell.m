//
//  BWMMyPruseTableViewCell.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyPruseTableViewCell.h"
#import "BWMMyDealInfoModel.h"

@interface BWMMyPruseTableViewCell()

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *datetimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BWMMyPruseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithModel:(BWMMyDealInfoModel *)model {
    _titleLabel.text = model.remark;
    _datetimeLabel.text = model.date;
    _priceLabel.text = model.moneyString;
}

+ (CGFloat)height {
    return 58.0f;
}

@end
