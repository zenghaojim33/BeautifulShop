//
//  MyOderTableViewCell.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-16.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOderTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *OderImageView;
@property (strong, nonatomic) IBOutlet UILabel *OderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *OderPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *OderTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *OderStatus;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@end
