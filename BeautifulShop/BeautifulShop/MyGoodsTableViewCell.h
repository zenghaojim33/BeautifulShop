//
//  MyGoodsTableViewCell.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-14.
//  Copyright (c) 2014年 jenk. All rights reserved.
//
@protocol MyGoodsCellDelegate;
#import <UIKit/UIKit.h>

@interface MyGoodsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *BGView1;
@property (strong, nonatomic) IBOutlet UIView *BGView2;
@property (strong, nonatomic) IBOutlet UIImageView *GoodImageView;
@property (strong, nonatomic) IBOutlet UILabel *GoodTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *TextView;

// 新添加的属性
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *storeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *weiPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *marketPriceLabel;


@property (strong, nonatomic) IBOutlet UIView *containerView;

@property(nonatomic,strong)id<MyGoodsCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *AddBth;
@property (strong, nonatomic) IBOutlet UIButton *CopyBth;
@property (strong, nonatomic) IBOutlet UIButton *ShareBth;
@end

@protocol MyGoodsCellDelegate <NSObject>

-(void)TouchAddButtonForTag:(int)tag IsBool:(BOOL)isTouch AndButton:(UIButton*)button;
-(void)TouchCellForTag:(int)tag;
-(void)TouchShareForCellTag:(int)tag;
-(void)TouchCopyForCellTag:(int)tag;

@end
