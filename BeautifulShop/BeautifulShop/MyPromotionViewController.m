//
//  MyPromotionViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-16.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "MyPromotionViewController.h"
#import "qrencode.h"
#import "BWMUmengManager.h"
#import "NSAttributedString+BWMExtension.h"
#import "BWMTextViewBox.h"

@interface MyPromotionViewController ()<UMSocialUIDelegate, BWMTextViewBoxDelegate>
{
    NSString * codeStr;
    IBOutlet UITextView *_headerTextView;
}
@property (strong, nonatomic) IBOutlet UIImageView *ImageView;
enum {
    qr_margin = 3
};
@property (strong, nonatomic) IBOutlet UIView *BGView;
@end

@implementation MyPromotionViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"我要推广";
}

#pragma mark 弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initCode];
    
    self.BGView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView.layer.shadowOpacity = 0.2;
    
    _headerTextView.attributedText = [NSAttributedString attributedStringWithSourceText:_headerTextView.text
                                                                    willChangeTextArray:@[@"10%", @"5%"]
                                                                                  color:[UIColor redColor]];
    _headerTextView.font = [UIFont systemFontOfSize:13.0f];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [av show];
        
        //Because November is luck month
    }
}

#pragma mark 马上推广
- (IBAction)shareCode:(UIButton *)sender {
    BWMTextViewBox *textViewBox = [BWMTextViewBox boxWithTitle:@"好久不见，我在开店！"
                                                       content:@"我开了个美店，我觉得也会适合你。点开看看咯。常联系！"
                                                  buttonTitles:@[@"确定", @"取消"]
                                                      delegate:self];
    [textViewBox show];
}

#pragma mark- BWMTextViewBoxDelegate
- (void)textViewBox:(BWMTextViewBox *)textViewBox buttonIndex:(int)buttonIndex {
    if (buttonIndex == 0) {
        //微信图片类型
        [BWMUmengManager settingWXShareTypeWeb];
        [BWMUmengManager sharingWithController:self
                                    shareTitle:textViewBox.titleValue
                                   shareDetail:textViewBox.contentValue
                                    shareImage:[UIImage imageNamed:@"TheIcon"]
                                     shareLink:[NSString stringWithFormat:@"http://web.mallteem.com/ShareQRcode.html#%@", codeStr]
                                      delegate:self];
    }
    [textViewBox close];
}

#pragma  mark 分享连接
- (IBAction)ShareUrl:(UIButton *)sender {
    NSString *shareText = @"美店二维码";             //分享内嵌文字
    UIImage *shareImage = self.ImageView.image;     //分享内嵌图片
    
    //微信网页类型
    [BWMUmengManager settingWXShareTypeWeb];
    [BWMUmengManager sharingWithController:self
                                shareTitle:shareText
                               shareDetail:shareText
                                shareImage:shareImage
                                 shareLink:codeStr
                                  delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
}

-(void)initCode {
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    codeStr = [NSString stringWithFormat:@"http://server.mallteem.com/json/web/register.html?parentid=%@",shareInfo.userModel.userID];
    
    UIImage * Code = [MyPromotionViewController qrImageForString:[NSString stringWithFormat:@"http://web.mallteem.com/ShareQRcode.html#%@", codeStr] imageSize:self.ImageView.frame.size.width];
    
    UIImage * NewCode = [self addImage:[UIImage imageNamed:@"CodeBG.jpg"] toImage:Code];
    
    self.ImageView.image = NewCode;
}

+ (void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size {
    unsigned char *data = 0;
    int width;
    data = code->data;
    width = code->width;
    float zoom = (double)size / (code->width + 2.0 * qr_margin);
    CGRect rectDraw = CGRectMake(0, 0, zoom, zoom);
    
    // draw
    CGContextSetFillColor(ctx, CGColorGetComponents([UIColor blackColor].CGColor));
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake((j + qr_margin) * zoom,(i + qr_margin) * zoom);
                CGContextAddRect(ctx, rectDraw);
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
}
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size {
    if (![string length]) {
        return nil;
    }
    
    QRcode *code = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    if (!code) {
        return nil;
    }
    
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
    
    // draw QR on this context
    [MyPromotionViewController drawQRCode:code context:ctx size:size];
    
    // get image
    CGImageRef qrCGImage = CGBitmapContextCreateImage(ctx);
    UIImage * qrImage = [UIImage imageWithCGImage:qrCGImage];
    
    // some releases
    CGContextRelease(ctx);
    CGImageRelease(qrCGImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(code);
    
    return qrImage;
}

@end
