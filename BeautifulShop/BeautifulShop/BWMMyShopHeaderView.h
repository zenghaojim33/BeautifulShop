//
//  BWMMyShopHeaderView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BWMMyShopHeaderView;

@protocol BWMMyShopHeaderViewDelegate <NSObject>

- (void)headerView:(BWMMyShopHeaderView *)headerView editBtnClicked:(UIButton *)button;
- (void)headerView:(BWMMyShopHeaderView *)headerView cpyBtnClicked:(UIButton *)button;
- (void)headerView:(BWMMyShopHeaderView *)headerView shareBtnClicked:(UIButton *)button;
- (void)headerView:(BWMMyShopHeaderView *)headerView searchTextFieldTaped:(UITextField *)textField;
- (void)headerView:(BWMMyShopHeaderView *)headerView myIconTaped:(UIImageView *)myIcon;
- (void)headerView:(BWMMyShopHeaderView *)headerView searchCloseBtnClicked:(UIButton *)button;

@end

@interface BWMMyShopHeaderView : UIView

@property (weak, nonatomic) id<BWMMyShopHeaderViewDelegate> delegate;
@property (strong, nonatomic) NSString *searchText;

/** 刷新视图 */
- (void)refresh;

- (void)showCloseBtn;
- (void)hideCloseBtn;

+ (instancetype)headerViewWithDelegate:(id<BWMMyShopHeaderViewDelegate>)delegate;

@end
