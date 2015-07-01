//
//  BWMSCLAlertView.m
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/28.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMSCLAlertView.h"
#import "SCLAlertView.h"

static NSString * const kOkeyString = @"确定";

@interface BWMSCLAlertView() {
    SCLAlertView *_alertView;
}

@end

@implementation BWMSCLAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message type:(BWMAlertViewType)type targetVC:(UIViewController *)targetVC {
    if (self = [super initWithTitle:title message:message type:type targetVC:targetVC]) {
        _alertView = [[SCLAlertView alloc] init];
        [_alertView setShowAnimationType:SlideInToCenter];
        [_alertView setHideAnimationType:SlideOutFromCenter];
        [_alertView setBackgroundType:Shadow];
    }
    return self;
}

- (void)addButtonWithTitle:(NSString *)title buttonType:(BWMAlertViewButtonType)buttonType callBlock:(BWMAlertViewTaskBlock)callBlock {
    SafeSelf(safeSelf);
    [_alertView addButton:title actionBlock:^{
        if(callBlock) callBlock(safeSelf);
    }];
}

- (void)show {
    switch (self.type) {
        case BWMAlertViewTypeSuccess:
            [_alertView showSuccess:self.targetViewController title:self.title subTitle:self.message closeButtonTitle:nil duration:0.0f];
            break;
            
        case BWMAlertViewTypeWarning:
            [_alertView showWarning:self.targetViewController title:self.title subTitle:self.message closeButtonTitle:nil duration:0.0f];
            break;
            
        case BWMAlertViewTypeError:
            [_alertView showError:self.targetViewController title:self.title subTitle:self.message closeButtonTitle:nil duration:0.0f];
            break;
            
        case BWMAlertViewTypeInfo:
            [_alertView showInfo:self.targetViewController title:self.title subTitle:self.message closeButtonTitle:nil duration:0.0f];
            break;
    }
}

- (void)dismiss {
    [_alertView dismissViewControllerAnimated:YES completion:nil];
}

@end
