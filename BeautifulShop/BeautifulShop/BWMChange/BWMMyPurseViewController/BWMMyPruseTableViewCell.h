//
//  BWMMyPruseTableViewCell.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMMyDealInfoModel;

@interface BWMMyPruseTableViewCell : UITableViewCell

- (void)updateWithModel:(BWMMyDealInfoModel *)model;

+ (CGFloat)height;

@end
