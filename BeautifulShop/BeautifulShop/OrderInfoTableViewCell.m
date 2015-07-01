//
//  OrderInfoTableViewCell.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-13.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderInfoTableViewCell.h"

@implementation OrderInfoTableViewCell

- (IBAction)TouchEmsButton:(id)sender {
    [self.delegate setEmsForTag:(int)self.tag];
}
- (IBAction)TouchBGview:(id)sender {
    [self.delegate setBGViewForTag:(int)self.tag];
}

@end
