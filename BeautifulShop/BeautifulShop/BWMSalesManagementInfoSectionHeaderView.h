//
//  BWMBWMSalesManagementInfoSctionHeaderView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWMSalesManagementInfoSectionHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *leftlabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

+ (CGFloat)height;
+ (instancetype)create;

@end
