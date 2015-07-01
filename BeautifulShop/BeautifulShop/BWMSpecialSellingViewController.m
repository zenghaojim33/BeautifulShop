//
//  BWMSpecialSellingViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/29.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMSpecialSellingViewController.h"

@interface BWMSpecialSellingViewController ()

@end

@implementation BWMSpecialSellingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"品牌特卖";
}

- (BWMProductModelType)APIRequestType {
    return BWMProductModelTypeSpecialSelling;
}

@end
