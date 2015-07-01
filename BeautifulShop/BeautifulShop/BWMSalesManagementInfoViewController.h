//
//  BWMSalesManagementInfoViewController.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/23.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMViewController.h"

/** 销售管理详情页的类型 */
typedef NS_ENUM(NSUInteger, BWMSalesManagementInfoType){
    /** 每日订单 */
    BWMSalesManagementInfoTypeDailyOrder,
    /** 成交金额 */
    BWMSalesManagementInfoTypeOrderPrice,
    /** 每日访客 */
    BWMSalesManagementInfoTypeVisiterCount
};

@protocol BWMSalesManagementInfoViewController <NSObject>

- (UIColor *)color;
- (BOOL)hasFloat;
- (NSString *)theTitle;
- (NSString *)aimString;
- (NSString *)apiReturnKey;
- (NSString *)sectionHeaderRightText;

@end

/** 销售管理详情 */
@interface BWMSalesManagementInfoViewController : BWMViewController

+ (BWMSalesManagementInfoViewController<BWMSalesManagementInfoViewController> *)createWithbInfoType:(BWMSalesManagementInfoType)infoType;

@end
