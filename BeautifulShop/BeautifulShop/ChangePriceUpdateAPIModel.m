//
//  ChangePriceUpdateAPIModel.m
//  BeautifulShop
//
//  Created by btw on 15/3/19.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ChangePriceUpdateAPIModel.h"
#import "APIFactory.h"
#import "XMLDictionary.h"

@implementation ChangePriceUpdateAPIModel

+ (NSString *)API {
    return [APIFactory APICompletionServerURLStringWithSegment:@"/json/index.ashx?aim=updateprice"];
}

- (id)getParameterObject {
    NSMutableString *postString = [NSMutableString stringWithFormat:@"<xml u=\"%@\" p=\"%@\">", _bossID, _productID];
    [self.XMLNoteArray enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
        [postString appendString:@"<p>"];
        [postString appendFormat:@"<att>%@</att>", obj[@"att"]];
        [postString appendFormat:@"<prc>%.2f</prc>", [obj[@"prc"] floatValue]];
        [postString appendString:@"</p>"];
    }];
    [postString appendString:@"</xml>"];
    NSLog(@"%@", postString);
    
    return @{
             @"xml" : postString
             };
}

@end
