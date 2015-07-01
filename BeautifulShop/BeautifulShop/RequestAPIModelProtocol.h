//
//  PostModelProtocol.h
//  BeautifulShop
//
//  Created by btw on 15/3/19.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestAPIModelProtocol <NSObject>

+ (NSString *)API;
- (id)getParameterObject;

@end
