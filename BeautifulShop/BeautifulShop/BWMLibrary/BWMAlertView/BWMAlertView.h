//
//  BWMAlertView.h
//  BWMAlertView
//
//  Created by 伟明 毕 on 15/3/28.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMAlertView;
@protocol BWMAlertView;

static NSString * const kAlertViewTipsTitleString = @"温馨提示";
static NSString * const kAlertViewTipsTitleErrorString = @"错误提示";
static NSString * const kAlertViewOkeyBtnString = @"确定";
static NSString * const kAlertViewCancelBtnString = @"取消";

#define SafeSelf(safeSelf) __weak typeof(&*self)safeSelf = self

/** BWMAlertViewType也就是AlertView的用途，类型 */
typedef NS_ENUM(NSUInteger, BWMAlertViewType) {
    BWMAlertViewTypeSuccess = 0,
    BWMAlertViewTypeInfo,
    BWMAlertViewTypeWarning,
    BWMAlertViewTypeError
};

/** BWMAlertViewButtonType 按钮的类型 */
typedef NS_ENUM(NSUInteger, BWMAlertViewButtonType) {
    BWMAlertViewButtonTypeOKey,
    BWMAlertViewButtonTypeCancel
};

typedef void(^BWMAlertViewTaskBlock)(BWMAlertView<BWMAlertView> *alertView);

@protocol BWMAlertView <NSObject>

/** 添加按钮，上限两个。并且BWMAlertViewButtonTypeOKey、BWMAlertViewButtonTypeCancel只能有且限一个 */
- (void)addButtonWithTitle:(NSString *)title buttonType:(BWMAlertViewButtonType)buttonType callBlock:(BWMAlertViewTaskBlock)callBlock;

/** 显示 */
- (void)show;

/** 消散 */
- (void)dismiss;

@end

// BWMAlertView目前正在火热加入各种第三方AlertView中，请Q我724849296 By Bi Weiming
/** BWMAlertView集成了N个AlertView，他们接口统一，无限切换。它针对抽象编程，符合里氏代换原则、依赖倒置原则。 */
@interface BWMAlertView : NSObject

@property (strong, nonatomic, readwrite) NSString *title;
@property (strong, nonatomic, readwrite) NSString *message;
@property (assign, nonatomic, readwrite) BWMAlertViewType type;
@property (weak, nonatomic, readwrite) UIViewController *targetViewController;

/** 初始化BWMAlertView */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                         type:(BWMAlertViewType)type
                     targetVC:(UIViewController *)targetVC;

@end
