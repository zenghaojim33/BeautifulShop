//
//  ChangePriceTBHeaderView.m
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ChangePriceTBCellHeaderView.h"

@implementation ChangePriceTBCellHeaderView

+ (CGFloat)height {
    return 60.0f;
}

- (void)changeState {
    [UIView animateWithDuration:1.0f animations:^{
        self.titleLabel.textColor = [UIColor whiteColor];
        self.descLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.9];
    }];
}

- (void)reverseState {
    [UIView animateWithDuration:1.0f animations:^{
        self.titleLabel.textColor = [UIColor blackColor];
        self.descLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }];
}

@end
