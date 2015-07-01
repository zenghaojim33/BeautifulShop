//
//  APIManager.m
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "APIFactory.h"

@implementation APIFactory


+ (NSString *)imageServerURLString {
    return @"http://server.mallteem.com";
}

+ (NSURL *)imageCompletionURLWithSegment:(NSString *)segmentImageURLString {
    return [NSURL URLWithString:[self imageCompletionStringWithSegment:segmentImageURLString]];
}

+ (NSString *)imageCompletionStringWithSegment:(NSString *)segmentImageURLString {
    return [[self imageServerURLString] stringByAppendingString:segmentImageURLString];
}

+ (NSString *)APIServerURLString {
    return @"http://server.mallteem.com/";
}

+ (NSString *)APICompletionServerURLStringWithSegment:(NSString *)segmentURLString {
    return [[self APIServerURLString] stringByAppendingString:segmentURLString];
}

@end
