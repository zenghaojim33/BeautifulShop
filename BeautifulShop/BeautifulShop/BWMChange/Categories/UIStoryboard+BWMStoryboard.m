//
//  UIStoryboard+BWMStoryboard.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/3/31.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "UIStoryboard+BWMStoryboard.h"

@implementation UIStoryboard (BWMStoryboard)

+ (id)initVCOnMainStoryboardWithID:(NSString *)identitier {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identitier];
}

+ (id)initVCOnBWMStoryboardWithID:(NSString *)identitier {
    return [[UIStoryboard storyboardWithName:@"BWMStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:identitier];
}

@end
