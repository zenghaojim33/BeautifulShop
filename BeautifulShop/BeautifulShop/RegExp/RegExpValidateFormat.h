//
//  RegExpValidateFormat.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/7.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExpValidateFormat : NSObject

/** 
 传递一个UITextField的指针，限制成金钱的字符串格式。
 只能在action:target: UIControlEventAllEditingEvents中调用
 */
+ (void)formatToPriceStringWithTextField:(UITextField *)textField;

/** 
 在UITextField代理方法中 - textField:shouldChangeCharactersInRange:replacementString: 使用。
 用于格式化输入的字符串为银行卡号码格式，并且返回BOOL值用于该代理方法的回调。
 */
+ (BOOL)formatToBankCardNumberStringWithTextField:(UITextField *)textField replacementString:(NSString *)string;

@end
