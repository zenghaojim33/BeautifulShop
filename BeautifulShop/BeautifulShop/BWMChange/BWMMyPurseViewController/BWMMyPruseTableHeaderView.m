//
//  BWMMyPruseTableHeaderView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMMyPruseTableHeaderView.h"
#import "ShareInfo.h"
#import "BWMMyInComeSimplePreviewModel.h"
#import "FormatStringFactory.h"

@interface BWMMyPruseTableHeaderView() <BWMMyPruseTableHeaderView> {
    
}
@end

@implementation BWMMyPruseTableHeaderView


- (IBAction)inputAccountBtnClicked:(UIButton *)sender {
    if (_delegate) [_delegate headerView:self inputAccountBtnClicked:sender];
}

- (IBAction)takeCashBtnClicked:(UIButton *)sender {
    if (_delegate) [_delegate headerView:self takeCashBtnClicked:sender];
}

+ (BWMMyPruseTableHeaderView<BWMMyPruseTableHeaderView> *)createView {
    NSString *headerViewClassString = nil;
//    if ([ShareInfo shareInstance].userModel.userType == 3) {
//        headerViewClassString = @"BWMMyPruseBossTableHeaderView";
//    } else {
//        headerViewClassString = @"BWMMyPrusePersonTableHeaderView";
//    }
    headerViewClassString = @"BWMMyPruseNormalTableHeaderView";
    BWMMyPruseTableHeaderView<BWMMyPruseTableHeaderView> *view = [[[NSBundle mainBundle] loadNibNamed:headerViewClassString owner:nil options:nil] lastObject];
    return view;
}

- (void)updateWithModel:(BWMMyInComeSimplePreviewModel *)model {}

@end
