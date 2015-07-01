//
//  ChangePriceTBHeaderView.h
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePriceTBCellHeaderView : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
+ (CGFloat)height;

- (void)changeState;
- (void)reverseState;

@end
