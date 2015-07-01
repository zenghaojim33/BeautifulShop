//
//  BossCodeViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-20.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "BossCodeViewController.h"
#import "qrencode.h"
#import "BWMUmengManager.h"

@interface BossCodeViewController ()<UMSocialUIDelegate>
{
BOOL isCode;
NSString * codeStr;

UIImage * QRCode;
}
enum {
    qr_margin = 3
};
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *BGView;
@end

@implementation BossCodeViewController
#pragma mark 弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
    // Do any additional setup after loading the view.
    
    self.BGView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView.layer.shadowOpacity = 0.2;
    
    
    self.title = @"店主二维码";
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    codeStr = [NSString stringWithFormat:@"http://server.mallteem.com/json/web/login.html?parentid=%@",shareInfo.userModel.userID];
    
    UIImage * Code = [BossCodeViewController qrImageForString:codeStr imageSize:self.imageView.frame.size.width];
    
    UIImage * NewCode = [self addImage:[UIImage imageNamed:@"CodeBG.jpg"] toImage:Code];
    
    self.imageView.image = NewCode;
    
    QRCode = NewCode;

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
    CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace,  (CGBitmapInfo) kCGImageAlphaPremultipliedLast);
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -size);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
    
    // draw QR on this context
    [BossCodeViewController drawQRCode:code context:ctx size:size];
    
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

- (IBAction)TouchButton:(id)sender {
    // 微信网页类型
    [BWMUmengManager settingWXShareTypeWeb];
    [BWMUmengManager sharingWithController:self
                                shareTitle:kDefaultShareQRCodeText
                               shareDetail:kDefaultShareQRCodeText
                                shareImage:self.imageView.image
                                 shareLink:codeStr
                                  delegate:self];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        // 得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [av show];
        
        //Because November is luck month
    }
}

@end
