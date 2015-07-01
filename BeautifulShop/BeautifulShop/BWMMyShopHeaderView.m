//
//  BWMMyShopHeaderView.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/6/14.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

#import "BWMMyShopHeaderView.h"

@interface BWMMyShopHeaderView() <UITextFieldDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UIImageView *myIcon;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *URLBtn;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *cpyLinkBtn;

@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation BWMMyShopHeaderView

- (void)awakeFromNib {
    [self refresh];
    _searchTF.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myIconTaped:)];
    [_myIcon addGestureRecognizer:tap];
    _closeBtn.hidden = YES;
}

- (void)refresh {
    NSString *uimg = [ShareInfo shareInstance].userModel.uimg;
    [self.myIcon sd_setImageWithURL:[NSURL URLWithString:uimg] placeholderImage:[UIImage imageNamed:@"product_placeholder"] options:SDWebImageRefreshCached];
    self.titleLabel.text = [ShareInfo shareInstance].userModel.name;
    NSString *url = [NSString stringWithFormat:@"http://web.mallteem.com/Shop.aspx?ShopId=%@", [ShareInfo shareInstance].userModel.userID];
    [self.URLBtn setTitle:url forState:UIControlStateNormal];
    
    _closeBtn.hidden = _searchText.length == 0;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(headerView:searchTextFieldTaped:)]) {
        [_delegate headerView:self searchTextFieldTaped:textField];
    }
    return NO;
}

- (void)myIconTaped:(UITapGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(headerView:myIconTaped:)]) {
        [_delegate headerView:self myIconTaped:(UIImageView *)sender.view];
    }
}

- (IBAction)editBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(headerView:editBtnClicked:)]) {
        [_delegate headerView:self editBtnClicked:sender];
    }
}

- (IBAction)cpyBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(headerView:cpyBtnClicked:)]) {
        [_delegate headerView:self cpyBtnClicked:sender];
    }
}

- (IBAction)shareBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(headerView:shareBtnClicked:)]) {
        [_delegate headerView:self shareBtnClicked:sender];
    }
}

- (IBAction)closeBtnClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(headerView:searchCloseBtnClicked:)]) {
        [_delegate headerView:self searchCloseBtnClicked:sender];
    }
}

- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    self.searchTF.text = searchText;
    if(searchText.length > 0) {
        _closeBtn.hidden = NO;
    } else {
        _closeBtn.hidden = YES;
    }
}

- (void)showCloseBtn {
    _closeBtn.hidden = NO;
}

- (void)hideCloseBtn {
    _closeBtn.hidden = YES;
}

+ (instancetype)headerViewWithDelegate:(id<BWMMyShopHeaderViewDelegate>)delegate {
    BWMMyShopHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    NSLog(@"%@", NSStringFromCGRect(headerView.frame));
    headerView.delegate = delegate;
    return headerView;
}

@end
