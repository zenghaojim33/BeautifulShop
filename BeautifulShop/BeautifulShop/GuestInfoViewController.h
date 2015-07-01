//
//  GuestInfoViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuestModel.h"
#import "DealProductModel.h"
@interface GuestInfoViewController : UIViewController
@property(nonatomic,strong)GuestModel * myModel;
@property(nonatomic,strong)NSString * weixinNo;
@end
