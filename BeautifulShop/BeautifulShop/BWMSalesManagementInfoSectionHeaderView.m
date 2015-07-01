//
//  BWMBWMSalesManagementInfoSctionHeaderView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMSalesManagementInfoSectionHeaderView.h"

@implementation BWMSalesManagementInfoSectionHeaderView

+ (instancetype)create {
    BWMSalesManagementInfoSectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"BWMSalesManagementInfoSectionHeaderView" owner:nil options:nil] lastObject];
    return headerView;
}

+ (CGFloat)height {
    return 45.0f;
}

@end
