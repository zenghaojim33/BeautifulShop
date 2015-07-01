//
//  BWMEditInfoTableViewController.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/10.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMEditInfoTableViewController.h"

@interface BWMEditInfoTableViewController ()

@end

@implementation BWMEditInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return 20;
    }
    
    return [super tableView:tableView heightForHeaderInSection:section];
}

@end
