//
//  BWMPutawayViewController.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/17.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMViewController.h"

@class BWMPutawayViewController;

@protocol BWMPutawayViewControllerDelegate <NSObject>

- (void)putawayViewControllerDidGoodsShelvesEnd:(BWMPutawayViewController *)viewController;

@end

@interface BWMPutawayViewController : BWMViewController

@property (nonatomic, strong) NSString *BrandStr;
@property (nonatomic, strong) NSString *TypeStr;
@property (nonatomic, strong) NSString *scarchStr;

@property (nonatomic, weak) id<BWMPutawayViewControllerDelegate> delegate;

@end
