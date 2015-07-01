//
//  RegExpValidateFormat.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/7.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "RegExpValidateFormat.h"
#import "RegExpValidate.h"

@implementation RegExpValidateFormat

+ (void)formatToPriceStringWithTextField:(UITextField *)textField {
    if (![RegExpValidate validateMoney:textField.text] && textField.text.length > 0) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
}

+ (BOOL)formatToBankCardNumberStringWithTextField:(UITextField *)textField replacementString:(NSString *)string {
    if (![string isEqualToString:@""] && [[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] >= 19) {
        return NO;
    }
    
    if (textField.text.length>0 && (![string isEqualToString:@""]) && (textField.text.length+1) % 5 == 0) {
        textField.text = [textField.text stringByAppendingString:@" "];
    }
    return YES;
}

@end
