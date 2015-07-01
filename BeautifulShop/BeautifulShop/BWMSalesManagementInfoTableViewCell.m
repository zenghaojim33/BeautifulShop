//
//  BWMSalesManagementInfoTableViewCell.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMSalesManagementInfoTableViewCell.h"

@interface BWMSalesManagementInfoTableViewCell() {
    
    IBOutlet UILabel *_dateLabel;
    IBOutlet UILabel *_amountLabel;
}

@end

@implementation BWMSalesManagementInfoTableViewCell

- (void)updateWithLeftLabelText:(NSString *)leftLabelText rightLabelText:(NSString *)rightLabelText {
    _dateLabel.text = leftLabelText;
    _amountLabel.text = rightLabelText;
}

@end
