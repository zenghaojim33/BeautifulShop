//
//  UpBossViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-11.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "UpBossViewController.h"
#import "UpInfoModel.h"
#import "MLIMGURUploader.h"

#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"

#import "UIColorFactory.h"
#import "NSAttributedString+BWMExtension.h"

#import "BWMAlertViewFactory.h"
#import "BWMMBProgressHUD.h"

@interface UpBossViewController ()
<
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>
{
    UpInfoModel * myModel;
    //判断是提交深证或营业执照
    BOOL isUserIDCard;
    //判断进入照相机或相册
    BOOL cream;

    UIImage * Filedata1;
    UIImage * Filedata2;
    
    BOOL isPaly;
    
    NSString * _tn;  //银联支付识别码
}

@property (strong, nonatomic) IBOutlet UIView *BGView;
@property (strong, nonatomic) IBOutlet UINavigationItem *UpInfoBth;
//@property (strong, nonatomic) IBOutlet UIImageView *Filedata1View;
//@property (strong, nonatomic) IBOutlet UIImageView *Filedata2View;

@property (strong, nonatomic) IBOutlet UILabel *StatusTitle;
@property (strong, nonatomic) IBOutlet UIButton *UpInfoButton;
@property (strong, nonatomic) IBOutlet UIButton *ImageButton;
@property (strong, nonatomic) IBOutlet UIButton *ImageButton2;
@property (strong, nonatomic) IBOutlet UITextView *myTextView;
@property (strong, nonatomic) IBOutlet UITextView *reasonTextView;

@end

@implementation UpBossViewController

-(void)UPPayPluginResult:(NSString*)result {
    NSLog(@"%@", result);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;

    self.BGView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView.layer.shadowOpacity = 0.2;
    
    
    [self GetUpInforData];
}
-(void)GetUpInforData
{
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    NSString * link = [NSString stringWithFormat:GetUpInfor,shareInfo.userModel.userID];
    
    [self dataRequest:link SucceedSelector:@selector(GetUpInforData:)];

}
-(void)GetUpInforData:(NSMutableDictionary*)dict
{
    self.BGView.hidden = NO;
    NSLog(@"dict:%@",dict);
    
    myModel = [[UpInfoModel alloc]init];
    
    myModel.upgradeId = [dict objectForKey:@"upgradeId"];
    myModel.fee = [dict objectForKey:@"fee"];
    myModel.profit = [[dict objectForKey:@"profit"]intValue];
    myModel.statu = [[dict objectForKey:@"statu"]intValue];
    myModel.succed = [[dict objectForKey:@"succed"]intValue];
    myModel.userType = [[dict objectForKey:@"userType"]intValue];
    myModel.remark = dict[@"remark"];

    
    //当前不是老板
    self.title = @"升级为店主";
    self.myTextView.alpha = 1;
    self.StatusTitle.alpha = 1;
    self.ImageButton.alpha = 1;
    self.ImageButton2.alpha = 1;
    self.UpInfoButton.alpha = 1;

    isPaly= NO;
    NSString * messages = [NSString stringWithFormat:@"店主看过来：\n       首先提交营业执照、法人身份证照片（注：必须是营业执照上的法人）；审核通过，凭系统生成的二维码给店长扫描。duang~~~就可以获得店长分店的10%%销售额。"];
    
    self.myTextView.attributedText = [NSAttributedString attributedStringWithSourceText:messages
                                                                    willChangeTextArray:@[@"10%"]
                                                                                  color:[UIColor redColor]];
    self.myTextView.font = [UIFont systemFontOfSize:15.0f];
        
        if (myModel.statu ==2 || myModel.statu == 3) {
            
            self.UpInfoButton.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
            self.UpInfoButton.userInteractionEnabled = NO;
            
            self.ImageButton.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
            self.ImageButton.userInteractionEnabled = NO;
            
            self.ImageButton2.backgroundColor = [UIColorFactory createColorWithType:UIColorFactoryColorTypeDisable];
            self.ImageButton2.userInteractionEnabled = NO;
            
            if (myModel.statu == 2)
            {
                self.StatusTitle.text = @"已提交资料，等待审核";
                isPaly = NO;
            }else{
                self.StatusTitle.text = @"申请通过，等待付款";
               
                self.UpInfoButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
                self.UpInfoButton.userInteractionEnabled = YES;
                [self.UpInfoButton setTitle:@"付款" forState:UIControlStateNormal];
                
                isPaly = YES;
                [self.UpInfoButton setBackgroundColor:[UIColorFactory createColorWithType:UIColorFactoryColorTypePurple]];

            }
        }
        
        if (myModel.statu<2)
        {
            self.StatusTitle.text = @"未提交申请";
            isPaly = NO;
        }
        
        if (myModel.statu == 4)
        {
            isPaly = NO;
            self.StatusTitle.text = @"申请未通过，请重新提交";
            
            self.reasonTextView.hidden = NO;
            self.reasonTextView.text = [NSString stringWithFormat:@"原因：%@", myModel.remark];
        }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.BGView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUpPhoto:(UIButton *)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc]
                                   initWithTitle:@"选择照片"
                                   delegate:nil
                                   cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:@"拍照"
                                   otherButtonTitles:@"选取现有的",nil];
    actionSheet.delegate=self;
    
    actionSheet.tag = sender.tag;
    
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet.tag:%d",(int)actionSheet.tag);
  
    if (actionSheet.tag == 0) {
        
        isUserIDCard = NO;
        NSLog(@"提交营业执照");
        
    }else{
        isUserIDCard = YES;
        NSLog(@"提交身份证");
        
    }
    
    if (buttonIndex==0) {
        
        NSLog(@"您选择了拍照");
        
        /*跳转系统相机*/
        
        //从系统当中获取图片
        UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
        
        //跳转到照相机
        [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        //编辑模式
        ipc.allowsEditing = YES;//多选时不能多选
        
        
        ipc.showsCameraControls  = YES;//下方工具栏
        //此delegate需要实现两个协议
        ipc.delegate = self;
        
        [self presentViewController:ipc animated:YES completion:nil];

        
        
    }else if (buttonIndex==1){
        
        NSLog(@"您选择了选取现有的");
        
        //从系统当中获取图片
        UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
        
        //跳转到相机胶卷
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        //  ipc.允许编辑
        ipc.allowsEditing = NO;//多选时不能多选
        

        //此delegate需要实现两个协议
        ipc.delegate = self;
        
        
        
        [self presentViewController:ipc animated:YES completion:nil];
        
    }else{
        
        NSLog(@"您选择了取消");
 
    }
};

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"点击图片时调用");
    NSLog(@"info = %@",info);
    
    
    UIImage* original_image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (cream ==YES) {
        UIImageWriteToSavedPhotosAlbum(original_image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    }
    
    if (isUserIDCard == NO)
    {
        Filedata1 = original_image;
//        self.Filedata1View.image = Filedata1;
        [self.ImageButton setTitle:@"提交营业执照图片(已添加)" forState:UIControlStateNormal];
        
        
        
    }else{
        Filedata2 = original_image;
//        self.Filedata2View.image = Filedata2;
        [self.ImageButton2 setTitle:@"提交身份证图片(已添加)" forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"图片保存成功");
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
- (IBAction)TouchUpInfo:(UIButton *)sender
{
    
    if (isPaly == YES) {
        ShareInfo * shareInfo = [ShareInfo shareInstance];
        NSString * link = [NSString stringWithFormat:@"http://server.mallteem.com/json/mobilepay/purchase.aspx?userid=%@",shareInfo.userModel.userID];
        
        [self dataRequest:link SucceedSelector:@selector(UpMobilepayData:)];
        
    } else {
        if (Filedata1==nil) {
            [self showAlertViewForTitle:@"请提交身份证图片" AndMessage:nil];
        } else if (Filedata2==nil) {
            [self showAlertViewForTitle:@"请提交营业执照图片" AndMessage:nil];
        } else {
        
            MBProgressHUD *HUD = [BWMMBProgressHUD showHUDAddedTo:self.view title:@"正在上存资料"];
            

            ShareInfo * shareInfo = [ShareInfo shareInstance];
            
            NSString * userid = [NSString  stringWithFormat:@"%@    ",shareInfo.userModel.userID];
            
            NSData *imageData1 = UIImageJPEGRepresentation(Filedata1, 1.0f);
            NSData *imageData2 = UIImageJPEGRepresentation(Filedata2, 1.0f);
            
            [MLIMGURUploader UpInfoFiledata1:imageData1 Filedata2:imageData2 userid:userid completionBlock:^(NSString *result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [BWMMBProgressHUD hideHUD:HUD hideAfter:0.0f];
                    [BWMAlertViewFactory showWithTitle:kAlertViewTipsTitleString
                                               message:@"上存资料成功，请等待审核！"
                                                  type:BWMAlertViewTypeSuccess
                                              targetVC:self callBlock:^(BWMAlertView<BWMAlertView> *alertView) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              }];
                });
            } failureBlock:^(NSURLResponse *response, NSError *error, NSInteger status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    [BWMMBProgressHUD hideHUD:HUD
                                        title:@"上存失败，请重试！"
                                    hideAfter:kBWMMBProgressHUDHideTimeInterval
                                      msgType:BWMMBProgressHUDMsgTypeError];
                });
            }];
            
            
        }
    }
    
    
}
#pragma mark 获取tn
-(void)UpMobilepayData:(NSMutableDictionary*)dict
{
    NSLog(@"dict:%@",dict);
    
    _tn = [dict objectForKey:@"tn"];
    [self performSegueWithIdentifier:@"pay" sender:self];
    
    
    
   //  [UPPayPlugin startPay:tn mode:@"00" viewController:self delegate:self];

}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pay"]) {
//        PayChooseViewController * pvc = segue.destinationViewController;
//        NSString * fee = myModel.fee;
//        NSString * upgradeId = myModel.upgradeId;
//        pvc.fee=fee;
//        pvc.upgradeId = upgradeId;
//        pvc.tn = _tn;
    }

}


@end
