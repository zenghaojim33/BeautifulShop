//
//  ChangePriceTBCell.m
//  BeautifulShop
//
//  Created by btw on 15/3/18.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "ChangePriceTBCell.h"
#import "ChangePriceRequestSingleModel.h"
#import "BWMTextField.h"
#import "FormatStringFactory.h"
#import "RegExpValidateFormat.h"

@interface ChangePriceTBCell() <UITextFieldDelegate> {
    ChangePriceRequestSingleModel *_attributeModel;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet BWMTextField *changeTextFieldLabel;

@end

@implementation ChangePriceTBCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    self.changeTextFieldLabel.delegate = self;
    [self.changeTextFieldLabel addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)textFieldValueChanged:(UITextField *)sender {
    // 限制金钱字符串格式
    [RegExpValidateFormat formatToPriceStringWithTextField:sender];
    _attributeModel.price = [sender.text floatValue];
}

+ (CGFloat)height {
    return 90.0f;
}

- (void)updateWithModel:(ChangePriceRequestSingleModel *)model {
    _attributeModel = model;
    
    self.titleLabel.text = model.sizeTitle;
    self.priceLabel.text = [FormatStringFactory  priceStringWithFloat:model.basePrice];
    self.changeTextFieldLabel.text = [FormatStringFactory priceStringNotSymbolWithFloat:model.price];
}


@end
