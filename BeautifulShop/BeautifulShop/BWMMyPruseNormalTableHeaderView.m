//
//  BWMMyPruseNormalTableHeaderView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/5/20.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMMyPruseNormalTableHeaderView.h"
#import "FormatStringFactory.h"
#import "BWMMyInComeSimplePreviewModel.h"
#import "BWMPriceAnimator.h"

@interface BWMMyPruseNormalTableHeaderView()

@property (strong, nonatomic) IBOutlet UILabel *secondIncomeLabel;

@end

@implementation BWMMyPruseNormalTableHeaderView

- (void)updateWithModel:(BWMMyInComeSimplePreviewModel *)model {
    self.ourIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.sProfit];
    self.firstIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.rProfit];
    self.secondIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.rProfit_2];
    self.totalIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.sumProfit];
    self.balanceLabel.text = [FormatStringFactory priceStringWithFloat:model.balance];
    self.totalWithdrawalLabel.text = [FormatStringFactory priceStringWithFloat:model.moneyOut];
    
    [BWMPriceAnimator animatorExecuteWithLables:@[
                                                  self.ourIncomeLabel,
                                                  self.firstIncomeLabel,
                                                  self.secondIncomeLabel,
                                                  self.totalIncomeLabel,
                                                  self.totalWithdrawalLabel
                                                  ]];
}

@end
