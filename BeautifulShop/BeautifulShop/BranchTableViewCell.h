//
//  BranchTableViewCell.h
//  BeautifulShop
//
//  Created by Anson on 14/12/11.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BranchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *BranchId;
@property (weak, nonatomic) IBOutlet UILabel *BranchName;
@property (weak, nonatomic) IBOutlet UILabel *Phone;
@property (weak, nonatomic) IBOutlet UILabel *AllProfit;

@end
