//
//  OrderInfoTableViewCell.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-13.
//  Copyright (c) 2014年 jenk. All rights reserved.
//
@protocol OrderInfoCellDelegate;
#import <UIKit/UIKit.h>

@interface OrderInfoTableViewCell : UITableViewCell
@property (strong, nonatomic)id<OrderInfoCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIImageView *productImg;
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *size;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *allPrice;
@property (strong, nonatomic) IBOutlet UIButton *WLButton;
@end

@protocol OrderInfoCellDelegate <NSObject>

-(void)setEmsForTag:(int)tag;
-(void)setBGViewForTag:(int)tag;

@end
