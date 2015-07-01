//
//  BWMProductSectionView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMProductSectionView;

@protocol BWMProductSectionViewDelegate <NSObject>

- (void)sectionView:(BWMProductSectionView *)sctionView putawayBtnClicked:(UIButton *)button;
- (void)sectionView:(BWMProductSectionView *)sctionView salesBtnClicked:(UIButton *)button;

@end

@interface BWMProductSectionView : UIView

@property (weak, nonatomic) id<BWMProductSectionViewDelegate> delegate;

+ (instancetype)sectionViewWithDelegate:(id<BWMProductSectionViewDelegate>)delegate;

+ (CGFloat)height;

@end
