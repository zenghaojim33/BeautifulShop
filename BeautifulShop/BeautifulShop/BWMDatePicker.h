//
//  BWMDatePicker.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/17.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMDatePicker;

@protocol BWMDatePickerDelegate <NSObject>

- (void)datePicker:(BWMDatePicker *)datePicker didSelectedDate:(NSString *)dateStr sender:(UIButton *)sender;
@optional
- (void)datePicker:(BWMDatePicker *)datePicker didCancelBtnClicked:(UIButton *)cancelBtn;

@end

@interface BWMDatePicker : UIView

@property (weak, nonatomic) id<BWMDatePickerDelegate> delegate;

- (void)show;
- (void)close;

+ (instancetype)pickerWithDelegate:(id<BWMDatePickerDelegate>)delegate;

@end
