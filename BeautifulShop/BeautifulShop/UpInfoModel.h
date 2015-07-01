//
//  UpInfoModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-7.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpInfoModel : NSObject
@property(nonatomic,strong)NSString * fee;//升级付费
@property(nonatomic)int profit;//分润百分比
@property(nonatomic)int userType;//当前用户类型
@property(nonatomic)int statu;//申请步骤
@property(nonatomic)int succed;//是否存在
@property (nonatomic,strong)NSString * upgradeId;

@property (strong, nonatomic) NSString *remark;
@end
