//
//  GuestMessageModel.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-26.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuestMessageModel : NSObject
@property(nonatomic)int customerId;
@property(nonatomic,strong)NSString * msg;
@property(nonatomic)int Count;
@property(nonatomic,strong)NSString * nickName;
@property(nonatomic,strong)NSString * shopkeeperId;
@property(nonatomic,strong)NSString * ts;
@end
