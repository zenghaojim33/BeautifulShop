//
//  BWMWelfareViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/29.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMWelfareViewController.h"

@interface BWMWelfareViewController ()

@end

@implementation BWMWelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店主福利";
}

- (BWMProductModelType)APIRequestType {
    return BWMProductModelTypeWelfare;
}


@end
