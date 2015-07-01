//
//  ChangeInfoViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-10.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "ChangeInfoViewController.h"
#import "BranksViewController.h"
#import "SDWebImage/SDWebImageManager.h"
#import "MLIMGURUploader.h"
#import "UIStoryboard+BWMStoryboard.h"
#import "CNCityPickerView.h"
#import "CustomIOS7AlertView.h"
#import "UIView+BWMExtension.h"
#import "UIButton+WebCache.h"
#import "RegExpValidate.h"
#import "RegExpValidateFormat.h"
#import "BWMAlertViewFactory.h"
#import "BWMBankCoder.h"
#import "BWMMBProgressHUD.h"
#import "NSString+BWMExtension.h"
#import "BeautifulShop-Swift.h"
#import "BWMCaptchaView.h"
#import "BWMAlertView.h"
#import "BWMBindAccountViewController.h"

@interface ChangeInfoViewController ()
<UITextFieldDelegate,BrandDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
    BWMCardIOViewControllerDelegate,
    BWMCaptchaViewDelegate,
    BWMBindAccountViewControllerDelegate
>
{
    IBOutlet UIView *_bgView;
    IBOutlet UITextField *_descAddressTF;
    //省、市、县
    NSString *_provincesString,* _citiesString,*_areasString;
    int touchPickInt;
    int index;
    
    NSURL *_iconImageURL;
    
    NSString * brankName;
    
    CGRect initFrame;
    
    UIImage * myImage;
    //判断进入照相机或相册
    
    NSString *_bankName;
    NSString *_bankNumber;
    NSString *_bankAccountName;
    
    BOOL cream;
    
    BWMBindAccountViewController *_accordBindVC; // 主动点击绑定视图控制器
}
@property (strong, nonatomic) IBOutlet UIButton *ImageButton;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UITextField *EamilTF;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;

@property (strong, nonatomic) IBOutlet UITextField *bankTF;
@property (strong, nonatomic) IBOutlet UITextField *bankNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTF;
@property (strong, nonatomic) IBOutlet UIView *bindAccountView;

@end

@implementation ChangeInfoViewController

- (void)resignFirstResponders {
    [_addressTF resignFirstResponder];
    [_EamilTF resignFirstResponder];
    [_bankTF resignFirstResponder];
    [_bankNumberTF resignFirstResponder];
    [_name resignFirstResponder];
    [_shopNameTF resignFirstResponder];
    [_descAddressTF resignFirstResponder];
}

+ (instancetype)viewController {
    ChangeInfoViewController *vc = [UIStoryboard initVCOnMainStoryboardWithID:@"ChangeInfoViewController"];
    return vc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    self.nameLabel.text = shareInfo.userModel.name;
    self.phoneLabel.text = [NSString bwm_phoneEncodeString];
    
    if (self.isChange == YES) {
       
        self.title = @"编辑资料";
        
    }else{
    
        self.title = @"完善资料";
        
    }
    
    initFrame = self.view.frame;

}

// 点击了省、市、区选择按钮
- (IBAction)touchCityPickerBtn:(UIButton *)sender {
    [self resignFirstResponders];
    __block NSString *_province;
    __block NSString *_city;
    __block NSString *_area;
    
    CNCityPickerView *cityPickerView = [CNCityPickerView createPickerViewWithFrame:CGRectMake(0, 0, 305, 300) valueChangedCallback:^(NSString *province, NSString *city, NSString *area) {
        _province = province;
        _city = city;
        _area = area;
    }];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setContainerView:cityPickerView];
    [alertView setButtonTitles:@[@"确认修改", @"取消"]];
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
        if (0 == buttonIndex) {
            _provincesString = _province;
            _citiesString = _city;
            _areasString = _area;
            _descAddressTF.text = [NSString stringWithFormat:@"%@ %@ %@", _provincesString, _citiesString, _areasString];
        }
        [alertView close];
    }];
    
    [alertView show];
}

- (IBAction)touchPick:(UIButton *)sender {
    [self goToBrandView];
}

-(void)goToBrandView
{
    [self resignFirstResponders];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    BranksViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BranksViewController"];
    
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)setBrandName:(NSString *)brandName {
    self.bankTF.text = brandName;
}

#pragma mark - Table view data source

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bindAccountView.hidden = [ShareInfo shareInstance].userModel.phone.length != 0;
    
    self.addressTF.delegate = self;
    self.EamilTF.delegate = self;
    self.bankNumberTF.delegate = self;
    self.name.delegate = self;
    
    
    if (self.isChange == YES) {
        [self UpUserData];
    }
 
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:@"NO" forKey:@"isChangeInfo"];
    
    [_bgView drawingDefaultStyleShadow];
}

- (void)UpUserData
{
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/index.ashx?aim=getmyinfor&userid=%@", shareInfo.userModel.userID];
    
    [self dataRequest:link SucceedSelector:@selector(UpUserData:)];
    
}

- (void)UpUserData:(NSMutableDictionary*)dict
{
    NSString * status =[dict objectForKey:@"status"];
    NSLog(@"dict:%@",dict);
    int statusInt = [status intValue];
    
    if (statusInt == false) {
        NSString * error = [dict objectForKey:@"error"];
        NSLog(@"error:%@",error);
    }else{
      
        NSDictionary * dataDit = [dict objectForKey:@"data"];
        _provincesString = [dataDit objectForKey:@"province"];
        _citiesString = [dataDit objectForKey:@"city"];
        _areasString = [dataDit objectForKey:@"county"];

        if (_provincesString.length>0) {
            _descAddressTF.text = [NSString stringWithFormat:@"%@ %@ %@", _provincesString, _citiesString, _areasString];
        }
        self.shopNameTF.text = [dataDit objectForKey:@"name"];
        self.addressTF.text = [dataDit objectForKey:@"area"];
        self.EamilTF.text = [dataDit objectForKey:@"email"];
        self.bankTF.text = [dataDit objectForKey:@"bankName"];
        self.bankNumberTF.text = [[dataDit objectForKey:@"bankCode"] bwm_bankCardNumberString];
        self.name.text = [dataDit objectForKey:@"bankUser"];
        
        _bankName = [dataDit objectForKey:@"bankName"];
        _bankAccountName = [dataDit objectForKey:@"bankUser"];
        _bankNumber = [[dataDit objectForKey:@"bankCode"] bwm_bankCardNumberString];
        
        NSString * uimg = [dataDit objectForKey:@"uimg"];
        NSString *imagePath = nil;
        if ([uimg hasPrefix:@"http:"]) {
            imagePath = uimg;
        } else {
            imagePath = [NSString stringWithFormat:@"http://server.mallteem.com%@",uimg];
        }
        NSURL *imageURL = [NSURL URLWithString:imagePath];
        _iconImageURL = imageURL;
        
        [self.ImageButton sd_setBackgroundImageWithURL:imageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"测试头像"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                myImage = image;
            }
        }];
    }
}

- (IBAction)Done:(UIButton *)sender {
    [self resignFirstResponders];
    
    NSString *bankNumber = [_bankNumberTF.text bwm_clearAllWhiteSpaceCharacters];

    NSString *errorMsg = nil;
//    if (self.shopNameTF.text.length == 0) {
//        errorMsg = @"店铺名称不能为空！";
//    } else if (self.addressTF.text.length == 0) {
//        errorMsg = @"详细地址字段不能为空！";
//    } else if (_descAddressTF.text.length == 0) {
//        errorMsg = @"请选择省份区域！";
//    } else if (self.EamilTF.text.length>0 && ![RegExpValidate validateEmail:self.EamilTF.text]) {
//        errorMsg = @"电子邮件格式错误！";
//    } else if (bankNumber.length == 0) {
//        errorMsg = @"银行卡号码不能为空";
//    } else if (![RegExpValidate validateBankAccountNumber:bankNumber]) {
//        errorMsg = @"银行卡号码格式不正确！";
//    } else if (_bankTF.text.length == 0) {
//        errorMsg = @"开户银行名称不能为空！";
//    } else if (_name.text.length == 0) {
//        errorMsg = @"开户人姓名不能为空!";
//    }
    if (self.shopNameTF.text.length == 0) {
        errorMsg = @"店铺名称不能为空！";
    } else if (self.EamilTF.text.length>0 && ![RegExpValidate validateEmail:self.EamilTF.text]) {
        errorMsg = @"电子邮件格式错误！";
    } else if (bankNumber.length>0 && ![RegExpValidate validateBankAccountNumber:bankNumber]) {
        errorMsg = @"银行卡号码格式不正确！";
    }
    
    if (errorMsg) {
        [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleErrorString
                                   message:errorMsg
                                      type:BWMAlertViewTypeError
                                  targetVC:self
                                 callBlock:nil];
        return;
    }
    
    // 如果银行资料有改动
    if (![self.bankTF.text isEqualToString:_bankName] ||
        ![self.name.text isEqualToString:_bankAccountName] ||
        ![self.bankNumberTF.text isEqualToString:_bankNumber]) {
        
        if ([ShareInfo shareInstance].userModel.phone.length == 0) {
            [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString message:@"请先绑定手机号码和密码" type:BWMAlertViewTypeWarning targetVC:self callBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                BWMBindAccountViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"BWMBindAccountViewController"];
                VC.delegate = self;
                [self.navigationController pushViewController:VC animated:YES];
            }];
            return;
        }
        
        BWMCaptchaView *captchaView = [BWMCaptchaView captchaViewWithDelegate:self];
        [captchaView show];
        return;
    }
    
    [self Change];
}

#pragma mark- BWMBindAccountViewControllerDelegate
- (void)bindAccountViewController:(BWMBindAccountViewController *)viewController didSuccessfulBindingPhone:(NSString *)phone {
    if (_accordBindVC == viewController) {
        self.bindAccountView.hidden = YES;
        self.phoneLabel.text = [NSString bwm_phoneEncodeString];
    } else {
        BWMCaptchaView *captchaView = [BWMCaptchaView captchaViewWithDelegate:self];
        [captchaView show];
    }
    
}

#pragma mark- BWMCaptchaViewDelegate
- (void)captchaView:(BWMCaptchaView *)captchaView didSuccessfulValidateCaptcha:(NSString *)captcha {
    [self Change];
}

#pragma mark Change
-(void)Change
{
    MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"正在修改资料..."];
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];

    NSString * userID = shareInfo.userModel.userID;
    NSString * pwd = shareInfo.userModel.password;
    NSString * phone = shareInfo.userModel.phone;
    NSString * name = self.shopNameTF.text;
    NSString * province = _provincesString;
    NSString * city = _citiesString;
    NSString * county = _areasString;
    NSString * area = self.addressTF.text;
    NSString * email = self.EamilTF.text;
    NSString * bankUser = self.name.text;
    NSString * bankName = self.bankTF.text;
    NSString * bankCode = [self.bankNumberTF.text bwm_clearAllWhiteSpaceCharacters];
    NSString * bankNumber = [BWMBankCoder bankCodeWithName:bankName]; // 银行编号
    
    NSString * clientID = @"测试？";

    
    NSString *description = [NSString stringWithFormat:@"id=%@&pwd=%@&phone=%@&name=%@&province=%@&city=%@&county=%@&area=%@&email=%@&bankUser=%@&bankName=%@&bankCode=%@&bankNumber=%@",userID,pwd,phone,name,province,city,county,area,email,bankUser,bankName,bankCode,bankNumber];
    
    
    NSLog(@"description:%@",description);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = myImage;
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
        
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:_iconImageURL];
        
        [MLIMGURUploader ChangeUserInfo:imageData userID:userID pwd:pwd phone:phone name:name province:province city:city county:county area:area email:email bankUser:bankUser bankName:bankName bankCode:bankCode bankNumber:bankNumber imgurClientID:clientID completionBlock:^(NSString *result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [BWMMBProgressHUD hideHUD:HUD hideAfter:0.0f];
                
                NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
                
                NSString * isChangeInfo = [ud objectForKey:@"isChangeInfo"];
                
                if ([isChangeInfo isEqualToString:@"YES"]) {
                    if (self.isChange == YES) {
                       [self.navigationController popViewControllerAnimated:YES];
                        if([_delegate respondsToSelector:@selector(changeInfoViewControllerDidSuccessfulChangeInfo:)]) {
                            [_delegate changeInfoViewControllerDidSuccessfulChangeInfo:self];
                        }
                    } else {
                        UINavigationController * Nav = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerNav"];
                        Nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [self presentViewController:Nav animated:YES completion:nil];
                    }
                    shareInfo.userModel.name = self.shopNameTF.text;
                }
            });
        } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
            
            NSLog(@"****************");
            NSLog(@"status:%d",(int)status);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [BWMMBProgressHUD hideHUD:HUD title:@"修改失败，请重试！" hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
            });
        }];

        
    });
    
    
   }
#pragma mark NoChange
-(void)NoChange
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    NSString * userID = shareInfo.userModel.userID;
    NSString * phone = shareInfo.userModel.phone;
    NSString * UserName = shareInfo.userModel.name;
    NSString * pwd = shareInfo.userModel.password;
    NSString * province = _provincesString;
    NSString * city = _citiesString;
    NSString * county = _areasString;
    NSString * area = self.addressTF.text;
    NSString * email = self.EamilTF.text;
    NSString * bankUser = self.name.text;
    NSString * bankName = self.bankTF.text;
    NSString * bankCode = [self.bankNumberTF.text bwm_clearAllWhiteSpaceCharacters];
    NSString * bankNumber = [BWMBankCoder bankCodeWithName:bankName]; // 银行编号
 
    
    //创建一个请求地址
    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=updatemyinfor"];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //修改请求 方式  ****以下为post请求
    
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"id=%@&phone=%@&name=%@&pwd=%@&province=%@&city=%@&county=%@&area=%@&email=%@&bankUser=%@&bankName=%@&bankCode=%@&bankNumber=%@",userID,phone,UserName,pwd,province,city,county,area,email,bankUser,bankName,bankCode,bankNumber] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
    
    //发出请求 并且得到响应数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:Nil];
    
    if(data==nil)
    {
        
        NSString*  message = @"获取数据失败请检查你的网络";
        
        [self showAlertViewForTitle:nil AndMessage:message];
        
    }else{
        
        NSLog(@"data不等于空");
        
        NSError *error=nil;
        
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        
        
        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
        
        
        [self performSelector:@selector(UpData:) withObject:dict afterDelay:0.2f];
        
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

}

-(void)UpData:(NSMutableDictionary*)dict
{
    NSString * status =[dict objectForKey:@"status"];
    int statusInt = [status intValue];
    
    if (statusInt == false) {
        NSString * error = [dict objectForKey:@"error"];
        [self showAlertViewForTitle:@"提交错误" AndMessage:error];
    }else{
        if (self.isChange == YES) {
            [BWMMBProgressHUD showTitle:@"修改成功"
                                 toView:self.navigationController.view
                              hideAfter:kBWMMBProgressHUDHideTimeInterval
                                msgType:BWMMBProgressHUDMsgTypeSuccessful];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showAlertViewForTitle:@"提交成功" AndMessage:nil];
            
            UINavigationController * Nav = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewControllerNav"];
            Nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:Nav animated:YES completion:nil];
        }
    }
}

#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}

- (void)dataRequest:(NSString *)url SucceedSelector:(SEL)selector{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *link = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",link);
        id jsonObject = [JSONData JSONDataValue:link];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *message = nil;
            if(jsonObject==nil)
            {
                
                message = @"获取数据失败请检查你的网络";
                [self showAlertViewForTitle:message AndMessage:nil];
            }
            else
            {
                
                [self performSelector:selector withObject:jsonObject afterDelay:0.2f];
                
            }
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
        });
        
    });
    
}

// 摄像头扫描识别银行卡点击事件
- (IBAction)cameraBtnClicked:(UIButton *)sender {
    BWMCardIOViewController *cardIOViewController = [BWMCardIOViewController createWithDelegate:self];
    [self presentViewController:cardIOViewController animated:YES completion:nil];
}

#pragma mark- 
- (void)cardIOViewCtroller:(BWMCardIOViewController * __nonnull)cardIOViewCtroller didScanCard:(NSString * __nonnull)cardNumber {
    self.bankNumberTF.text = [cardNumber bwm_bankCardNumberString];
}

- (IBAction)TFDidEndOnExit:(UITextField *)sender {
    [sender resignFirstResponder];
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _descAddressTF) {
        [self touchCityPickerBtn:nil];
        return NO;
    } else if (textField == _bankTF) {
        [self touchPick:nil];
        return NO;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _bankNumberTF) {
        return [RegExpValidateFormat formatToBankCardNumberStringWithTextField:textField replacementString:string];
    }
    return YES;
}

- (IBAction)TouchImageButton:(UIButton *)sender {
    
    UIActionSheet * actionSheet =
    [[UIActionSheet alloc]initWithTitle:@"选择照片"
                               delegate:nil
                      cancelButtonTitle:@"取消"
                 destructiveButtonTitle:@"拍照"
                      otherButtonTitles:@"选取现有的",nil];
    actionSheet.delegate=self;
    
    actionSheet.tag = sender.tag;
    
    [actionSheet showInView:self.view];

    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"actionSheet.tag:%ld",(long)actionSheet.tag);
    
    if (buttonIndex==0) {
        
        NSLog(@"您选择了拍照");
        
        /*跳转系统相机*/
        
        //从系统当中获取图片
        UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
        
        //跳转到照相机
        [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //编辑模式
        ipc.allowsEditing = YES;//多选时不能多选
        
        //此delegate需要实现两个协议
        ipc.delegate = self;
        
        [self presentViewController:ipc animated:YES completion:nil];
        
    } else if (buttonIndex==1){
        
        NSLog(@"您选择了选取现有的");
        
        //从系统当中获取图片
        UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
        
        //跳转到相机胶卷
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        //  ipc.允许编辑
        ipc.allowsEditing = YES;//多选时不能多选
        
        //此delegate需要实现两个协议
        ipc.delegate = self;
        
        
        
        [self presentViewController:ipc animated:YES completion:nil];
        
    }else{
        
        NSLog(@"您选择了取消");
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"点击图片时调用");
    NSLog(@"info = %@",info);
    
    
    UIImage* original_image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = nil;
    if (UIImagePNGRepresentation(original_image) == nil) {
        imageData = UIImageJPEGRepresentation(original_image, 1);
    } else {
        imageData = UIImagePNGRepresentation(original_image);
    }
    original_image = [[UIImage alloc] initWithData:imageData];
    
    if (cream ==YES) {
        UIImageWriteToSavedPhotosAlbum(original_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
    
    [self.ImageButton setBackgroundImage:original_image forState:UIControlStateNormal];
    
    myImage = original_image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSLog(@"图片保存成功");
}

// 绑定手机号码和密码
- (IBAction)tapedBindPhone:(UITapGestureRecognizer *)sender {
    _accordBindVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BWMBindAccountViewController"];
    _accordBindVC.delegate = self;
    [self.navigationController pushViewController:_accordBindVC animated:YES];
}

@end
