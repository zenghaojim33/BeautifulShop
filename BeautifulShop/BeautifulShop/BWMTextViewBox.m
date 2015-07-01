//
//  BWMTextViewBox.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/5.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMTextViewBox.h"
#import "CustomIOS7AlertView.h"

@interface BWMTextViewBox() {
    CustomIOS7AlertView *_alertView;
}
@property (strong, nonatomic) IBOutlet UITextField *titleField;
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation BWMTextViewBox

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _alertView = [[CustomIOS7AlertView alloc] init];
        [_alertView setUseMotionEffects:TRUE];
        _alertView.containerView = self;
        __weak __typeof(&*self)weakSelf = self;
        [_alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            if (weakSelf.delegate) {
                [weakSelf.delegate textViewBox:weakSelf buttonIndex:buttonIndex];
            }
        }];
    }
    return self;
}

- (void)awakeFromNib {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_contentTextView becomeFirstResponder];
    });
}


- (void)show {
    [_alertView show];
}

+ (instancetype)boxWithTitle:(NSString *)title content:(NSString *)content buttonTitles:(NSArray *)buttonTitles delegate:(id<BWMTextViewBoxDelegate>)delegate {
    BWMTextViewBox *textViewBox = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    textViewBox.title = title;
    textViewBox.content = content;
    textViewBox.buttonTitles = buttonTitles;
    textViewBox.delegate = delegate;
    return textViewBox;
}

- (void)close {
    [_alertView close];
}

#pragma mark- Override Private Methods
- (void)setTitle:(NSString *)title {
    _title = title;
    _titleField.text = title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _contentTextView.text = content;
}

- (void)setButtonTitles:(NSArray *)buttonTitles {
    _buttonTitles = buttonTitles;
    [_alertView setButtonTitles:buttonTitles];
}

- (NSString *)titleValue {
    return _titleField.text;
}

- (NSString *)contentValue {
    return _contentTextView.text;
}

@end
