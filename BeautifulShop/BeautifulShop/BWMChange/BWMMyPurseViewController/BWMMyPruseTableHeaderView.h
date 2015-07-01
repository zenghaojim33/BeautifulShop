//
//  BWMMyPruseTableHeaderView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMMyPruseTableHeaderView;
@class BWMMyInComeSimplePreviewModel;

@protocol BWMMyPruseTableHeaderView;
@protocol BWMMyPruseTableHeaderViewDelegate;

@interface BWMMyPruseTableHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *ourIncomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *firstIncomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalIncomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalWithdrawalLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;

@property (weak, nonatomic, readwrite) id<BWMMyPruseTableHeaderViewDelegate> delegate;

+ (BWMMyPruseTableHeaderView<BWMMyPruseTableHeaderView> *)createView;

@end

@protocol BWMMyPruseTableHeaderView <NSObject>

- (void)updateWithModel:(BWMMyInComeSimplePreviewModel *)model;

@end

@protocol BWMMyPruseTableHeaderViewDelegate <NSObject>

- (void)headerView:(BWMMyPruseTableHeaderView <BWMMyPruseTableHeaderView> *)headerView inputAccountBtnClicked:(UIButton *)inputAccountBtn;

- (void)headerView:(BWMMyPruseTableHeaderView <BWMMyPruseTableHeaderView> *)headerView takeCashBtnClicked:(UIButton *)takeCashBtn;

@end