//
//  O2OUserModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface O2OUserModel : MTLModel <MTLJSONSerializing>
@property(nonatomic, copy) NSString *userID;//用户ID
@property(nonatomic)int userType;//用户类型
@property(nonatomic)BOOL isDataOK;//用户资料是否完善
@property(nonatomic)BOOL isFirtLogin;//是否第一次登录
@property(nonatomic)BOOL isPaid;//是否付费
@property(nonatomic,strong)NSString * name;//商户名称
@property(nonatomic,strong)NSString * phone;//手机
@property(nonatomic,strong)NSString * password;//密码
@property(nonatomic, strong)NSString *realPassword;
@property(nonatomic,strong)NSString * regFee;//注册费
@property(nonatomic,strong)NSString * uimg;//图片

@property(nonatomic,strong)NSString * parentId;//老板ID
@property(nonatomic,strong)NSString * parentName;//老板名称
@property (nonatomic, strong)NSString *token;
@property (nonatomic, assign) BOOL status; // 登录状态 true or false

//状态

//是否绑定,
@property(nonatomic)int siLogin;
//信息数
@property(nonatomic)int msgNumber;
//订单数
@property(nonatomic)int orderNumber;
//客户数
@property(nonatomic)int userNumber;
//产品数
@property(nonatomic)int productNumber;

// 小米RegId
@property(nonatomic,strong)NSString * udid;

@end
