//
//  BWMMyPruseBossTableHeaderView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyPruseBossTableHeaderView.h"
#import "BWMPriceAnimator.h"
#import "FormatStringFactory.h"
#import "BWMMyInComeSimplePreviewModel.h"

@interface BWMMyPruseBossTableHeaderView()

@property (strong, nonatomic) IBOutlet UILabel *employeeIncomeLabel;

@end

@implementation BWMMyPruseBossTableHeaderView

- (void)updateWithModel:(BWMMyInComeSimplePreviewModel *)model {
    self.ourIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.sProfit];
    self.firstIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.rProfit];
    self.totalIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.sumProfit];
    self.totalWithdrawalLabel.text = [FormatStringFactory priceStringWithFloat:model.moneyOut];
    self.employeeIncomeLabel.text = [FormatStringFactory priceStringWithFloat:model.pProfit];
    
    [BWMPriceAnimator animatorExecuteWithLables:@[
                                                  self.ourIncomeLabel,
                                                  self.firstIncomeLabel,
                                                  self.totalIncomeLabel,
                                                  self.totalWithdrawalLabel,
                                                  self.employeeIncomeLabel
                                                  ]];
}


@end
