//
//  BWMMyPruseTableSectionHeaderView.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/26.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMMyPruseTableSectionHeaderView;

@protocol BWMMyPruseTableSectionHeaderViewDelegate <NSObject>

- (void)sectionHeaderView:(BWMMyPruseTableSectionHeaderView *)sectionHeaderView buttonClicked:(UIButton *)button tag:(NSInteger)tag;

@end

@interface BWMMyPruseTableSectionHeaderView : UIView

@property (weak, nonatomic, readwrite) id<BWMMyPruseTableSectionHeaderViewDelegate> delegate;

- (void)scrollToFirstElement;

+ (CGFloat)height;

@end
