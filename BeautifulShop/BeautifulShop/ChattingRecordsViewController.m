//
//  ChattingRecordsViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "ChattingRecordsViewController.h"

@interface ChattingRecordsViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *_WebView;

@end

@implementation ChattingRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString * path = self.url;
    NSLog(@"path:%@",path);
    NSURL * url = [NSURL URLWithString:path];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self._WebView loadRequest:request];
}

@end
