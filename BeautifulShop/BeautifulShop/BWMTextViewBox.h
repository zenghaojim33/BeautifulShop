//
//  BWMTextViewBox.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/5.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BWMTextViewBox;

@protocol BWMTextViewBoxDelegate <NSObject>

- (void)textViewBox:(BWMTextViewBox *)textViewBox buttonIndex:(int)buttonIndex;

@end

@interface BWMTextViewBox : UIView

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic, readonly) NSString *titleValue;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic, readonly) NSString *contentValue;
@property (strong, nonatomic) NSArray *buttonTitles;
@property (weak, nonatomic) id<BWMTextViewBoxDelegate> delegate;

+ (instancetype)boxWithTitle:(NSString *)title
                             content:(NSString *)content
                        buttonTitles:(NSArray *)buttonTitles
                            delegate:(id<BWMTextViewBoxDelegate>)delegate;

- (void)show;
- (void)close;

@end
