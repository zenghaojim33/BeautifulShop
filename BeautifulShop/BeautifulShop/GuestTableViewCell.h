//
//  GuestTableViewCell.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-21.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productNumber;
@property (strong, nonatomic) IBOutlet UILabel *productMoney;
@property (strong, nonatomic) IBOutlet UIImageView *productIMG;
@property (strong, nonatomic) IBOutlet UILabel *productUserName;
@property (strong, nonatomic) IBOutlet UILabel *productTime;
@property (strong, nonatomic) IBOutlet UILabel *productStatusLabel;
@property (strong, nonatomic) IBOutlet UIView *BGView;

@end
