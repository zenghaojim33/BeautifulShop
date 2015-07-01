//
//  GuestManagementTableViewCell.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestManagementTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *GuestName;
@property (strong, nonatomic) IBOutlet UIImageView *GuestImage;
@property (strong, nonatomic) IBOutlet UILabel *LsatDealTime;
@property (strong, nonatomic) IBOutlet UILabel *turnover;
@property (strong, nonatomic) IBOutlet UIView *BGView;
@property (strong, nonatomic) IBOutlet UILabel *GuestImagePlaceholderLabel;
// 下单时间
@property (strong, nonatomic) IBOutlet UILabel *orderTimeLabel;

@end
