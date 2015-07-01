//
//  BWMMyPrusePersonlTableHeaderView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyPrusePersonTableHeaderView.h"
#import "FormatStringFactory.h"
#import "BWMMyInComeSimplePreviewModel.h"
#import "BWMPriceAnimator.h"

@implementation BWMMyPrusePersonTableHeaderView

- (void)updateWithModel:(BWMMyInComeSimplePreviewModel *)model {
    self.ourIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.sProfit];
    self.firstIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.rProfit];
    self.totalIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.sumProfit];
    self.totalWithdrawalLabel.text = [FormatStringFactory priceStringWithFloat:model.moneyOut];
    
    [BWMPriceAnimator animatorExecuteWithLables:@[
                                                  self.ourIncomeLabel,
                                                  self.firstIncomeLabel,
                                                  self.totalIncomeLabel,
                                                  self.totalWithdrawalLabel
                                                  ]];
}

@end
