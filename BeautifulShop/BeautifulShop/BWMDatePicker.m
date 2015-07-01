//
//  BWMDatePicker.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/17.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMDatePicker.h"
#import "UIColorFactory.h"

static int kShowYearBetween = 10;

@interface BWMDatePicker() <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSMutableArray *_yearsArray;
    NSMutableArray *_monthArray;
    NSArray *_currentMonthArray;
    NSString *_selectedYearStr;
    NSString *_selectedMonthStr;
}

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIPickerView *datePicker;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation BWMDatePicker

- (instancetype)init {
    NSAssert(NO, @"please use -pickerWithDelegate");
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _yearsArray = [NSMutableArray new];
        _monthArray = [NSMutableArray new];
    }
    return self;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.confirmBtn.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypePurple];
    self.closeBtn.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
    _datePicker.delegate = self;
    _datePicker.dataSource = self;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"M"];
    NSString *currentMonth = [dateFormatter stringFromDate:[NSDate date]];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    for (int i = kShowYearBetween; i>=0; i--) {
        NSString *yearStr = [formatter stringFromNumber:@([currentYear integerValue] - i)];
        [_yearsArray addObject:yearStr];
        
        NSMutableArray *monArray = [NSMutableArray new];
        for (int j = 1; j <= 12; j++) {
            if (i == 0) {
                if (j <= [currentMonth integerValue]) {
                    [monArray addObject:[formatter stringFromNumber:@(j)]];
                }
            } else {
                [monArray addObject:[formatter stringFromNumber:@(j)]];
            }
        }
        [_monthArray addObject:monArray];
    }
    
    _currentMonthArray = [_monthArray lastObject];
    
    [_datePicker selectRow:kShowYearBetween inComponent:0 animated:YES];
    [_datePicker selectRow:[currentMonth integerValue]-1 inComponent:1 animated:YES];
    _selectedYearStr = currentYear;
    _selectedMonthStr = currentMonth;
}

- (IBAction)confirmBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(datePicker:didSelectedDate:sender:)]) {
        NSString *finalStr = [NSString stringWithFormat:@"%@-%.2d", _selectedYearStr, [_selectedMonthStr intValue]];
        [_delegate datePicker:self didSelectedDate:finalStr sender:sender];
    }
}

- (IBAction)closeBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(datePicker:didCancelBtnClicked:)]) {
        [_delegate datePicker:self didCancelBtnClicked:sender];
    }
}

+ (instancetype)pickerWithDelegate:(id<BWMDatePickerDelegate>)delegate {
    BWMDatePicker *picker = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    picker.frame = [UIScreen mainScreen].bounds;
    picker.delegate = delegate;
    return picker;
}

- (void)close {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)show {
    if (self.superview == nil) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        }];
    }
}

#pragma mark- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        return _yearsArray.count;
    } else {
        return _currentMonthArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        return [_yearsArray[row] stringByAppendingString:@"年"];
    } else {
        return [_currentMonthArray[row] stringByAppendingString:@"月"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == component) {
        _currentMonthArray =  _monthArray[row];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        _selectedMonthStr = @"1";
        _selectedYearStr = _yearsArray[row];
    } else {
        _selectedMonthStr = _currentMonthArray[row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34.0f;
}

@end
