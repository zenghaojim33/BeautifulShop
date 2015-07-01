//
//  aboutBeautifulShopViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-18.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "aboutBeautifulShopViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface aboutBeautifulShopViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation aboutBeautifulShopViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"关于美店";
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView.contentSize = CGSizeMake(self.view.frame.size.width, 1000);
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 2;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
