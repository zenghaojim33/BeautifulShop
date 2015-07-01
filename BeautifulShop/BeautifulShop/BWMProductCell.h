//
//  BWMProductCell.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMProductModel;
@class BWMProductCell;

@protocol BWMProductCellDelegate <NSObject>

@optional
- (void)productCell:(BWMProductCell *)cell addBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model;
@required
- (void)productCell:(BWMProductCell *)cell requestLinkBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model;
- (void)productCell:(BWMProductCell *)cell shareBtnClicked:(UIButton *)addBtn model:(BWMProductModel *)model;
- (void)productCell:(BWMProductCell *)cell infoBgViewTaped:(UIView *)infoBgView model:(BWMProductModel *)model;

@end

@interface BWMProductCell : UITableViewCell

@property (weak ,nonatomic) id<BWMProductCellDelegate> delegate;

- (void)updateWithModel:(BWMProductModel *)model;

- (void)selectedAddBtn:(BOOL)selected;

+ (CGFloat)height;

@end
