//
//  ChangePriceTBCell.h
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChangePriceRequestSingleModel;

@interface ChangePriceTBCell : UITableViewCell

+ (CGFloat)height;

- (void)updateWithModel:(ChangePriceRequestSingleModel *)model;

@end
