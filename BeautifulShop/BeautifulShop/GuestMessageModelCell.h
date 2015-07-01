//
//  GuestMessageModelCell.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestMessageModelCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *msg;
@property (strong, nonatomic) IBOutlet UILabel *nickName;
@property (strong, nonatomic) IBOutlet UIButton *Count;
@property (strong, nonatomic) IBOutlet UILabel *ts;

@end
