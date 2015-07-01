//
//  NSString+BWMExtension.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/28.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "NSString+BWMExtension.h"

@implementation NSString (BWMExtension)

- (NSString *)bwm_bankCardNumberString {
    if (self.length == 0) {
        return self;
    }
    
    static const int kFormatBlankIndex = 4;
    static NSString * const kFormatSymbol = @" ";
    
    NSMutableString *bankCode = [NSMutableString stringWithString:self];
 
    int length = (int)bankCode.length;
    for (int i = kFormatBlankIndex; i <= length; i += kFormatBlankIndex + 1) {
        [bankCode insertString:kFormatSymbol atIndex:i];
    }
    return bankCode;
}

- (NSString *)bwm_clearAllWhiteSpaceCharacters {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)bwm_MD5String {
    if (self.length == 0) {
        return self;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)bwm_wechatURLString {
    NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)self, nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
    
    // e-soon.cn Required
    encodedValue = [NSString stringWithFormat:@"http://server.e-soon.cn/weixinpay/Handler.aspx?targetUrl=%@", encodedValue];
    encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                         (CFStringRef)encodedValue, nil,
                                                                                         (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
    // 如果是测试state=123_test，正是环境state=123
    NSString *wechatURLStr = [NSString stringWithFormat:@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx03e7b6f8002c136c&redirect_uri=%@&response_type=code&scope=snsapi_base&state=123_test&connect_redirect=1#wechat_redirect", encodedValue];
    
    return wechatURLStr;
}

+ (NSString *)bwm_deviceUDID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

- (NSString *)bwm_URLEncodeString {
    NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                   (CFStringRef)self, nil,
                                                                                                   (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
    return encodedValue;
}

+ (NSString *)bwm_phoneEncodeString {
    NSString *phone = [ShareInfo shareInstance].userModel.phone;
    if(phone.length != 0) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return phone;
    }
    
    return nil;
}

@end
