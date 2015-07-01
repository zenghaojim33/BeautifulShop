//
//  QRCodeViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-12.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()
<
    ZBarReaderViewDelegate
>
{
    CGFloat y;

    NSTimer * timer;
}
@end

@implementation QRCodeViewController
#define FPS 40.0
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.readerView.readerDelegate = self;
    y = self.redLine.frame.origin.y;
   timer = [NSTimer scheduledTimerWithTimeInterval:1/FPS
                                     target:self
                                   selector:@selector(animate:)
                                   userInfo:nil
                                    repeats:YES];
    upOrdown = NO;
    [self initScan];
    
    self.title = @"绑定店主";
}
#pragma mark 初始化扫描界面
-(void)animate:(id)sender
{
    //当前值 =   上一次的值 + （目标值 - 上一次的值）*（渐进因子）
    CGRect center = self.redLine.frame;
    NSLog(@"%.2f",center.origin.y);
    if (center.origin.y>240) {
        center.origin.y =20;
    }else{
    center.origin.y +=1;
    }
    self.redLine.frame = center;
}
-(void)initScan
{
    //不显示跟踪框
    _readerView.tracksSymbols = NO;
    //关闭闪关灯
    _readerView.torchMode = 0;
    //二维码拍摄的屏幕大小
    CGRect rvBounsRect = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
    //二维码拍摄时，可扫描区域的大小
    CGRect scanCropRect = CGRectMake(0, 0, 320, 295);
    //设置ZBarReaderView的scanCrop属性
    _readerView.scanCrop = [self getScanCrop:scanCropRect readerViewBounds:rvBounsRect];
    //定时器使基准线闪动
}

//设置可扫描区的scanCrop的方法
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)rvBounds
{
    CGFloat _x,_y,_width,_height;
    _x = rect.origin.y / rvBounds.size.height;
    _y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    _width = (rect.origin.y + rect.size.height) / rvBounds.size.height;
    _height = 1 - rect.origin.x / rvBounds.size.width;
    return CGRectMake(_x, _y, _width, _height);
}

-(void)viewDidAppear:(BOOL)animated {
    [self.readerView start];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.readerView stop];
    [timer invalidate];
}

#pragma mark 处理扫描结果
- (void) readerView: (ZBarReaderView*) view didReadSymbols: (ZBarSymbolSet*) syms fromImage: (UIImage*) img {
    //处理扫描结果
    ZBarSymbol *sym =nil;
    for(sym in syms)
        break;
    //停止扫描
    [self.readerView stop];
    [self CheckString:sym.data];
    NSLog(@"sym.data:%@", sym.data);
}

-(void)CheckString:(NSString *)string {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (string.length<48) {
        NSLog(@"检测不到店主二维码");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        UIAlertView * av= [[UIAlertView alloc]initWithTitle:@"扫描失败" message:nil delegate:self cancelButtonTitle:@"重新扫描" otherButtonTitles:@"返回", nil];
        av.tag = 888;
        
        [av show];
        
    } else {
        //点击声音
        [NSThread detachNewThreadSelector:@selector(playClickSound) toTarget:self withObject:nil];
        
        if([string rangeOfString:@"login.html?parentid="].location != NSNotFound) {
            NSString *BossID = [string substringFromIndex:string.length-12];
            [ShareInfo shareInstance].userModel.parentId = BossID;
            NSLog(@"检测店主ID为:%@", BossID);
            
            [self sendBossIDLinkBoss:BossID];
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        } else {
            NSLog(@"检测不到店主二维码");
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            UIAlertView * av= [[UIAlertView alloc] initWithTitle:@"扫描失败"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"重新扫描"
                                               otherButtonTitles:@"返回", nil];
            av.tag = 888;
            
            [av show];
        }
    }

}
- (void)sendBossIDLinkBoss:(NSString*)BossId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ShareInfo * shareInfo = [ShareInfo shareInstance];
    
    //创建一个请求地址
    NSURL *url = [NSURL URLWithString:@"http://server.mallteem.com/json/index.ashx?aim=linkbos"];
    //创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //修改请求 方式  ****以下为post请求
    
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"userid=%@&parent=%@",shareInfo.userModel.userID,BossId] dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestBody];
    
    //发出请求 并且得到响应数据
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:Nil];
    
    if(data==nil) {
        NSString*  message = @"获取数据失败请检查你的网络";
        [self showAlertViewForTitle:nil AndMessage:message];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } else {
        NSLog(@"data不等于空");
        NSError *error=nil;
        id JsonObject=[NSJSONSerialization JSONObjectWithData:data
                                                      options:NSJSONReadingAllowFragments
                                                        error:&error];
        NSMutableDictionary *dict = (NSMutableDictionary *)JsonObject;
        [self performSelector:@selector(UpData:) withObject:dict afterDelay:0.2f];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

-(void)UpData:(NSMutableDictionary*)dict {
    NSString * status = [dict objectForKey:@"status"];
    int statusInt = [status intValue];
    if (statusInt==true) {
        UIAlertView * av= [[UIAlertView alloc]initWithTitle:@"绑定成功" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        av.tag = 889;
        [av show];
        
        ShareInfo * shareInfo = [ShareInfo shareInstance];
        shareInfo.userModel.parentName = [dict objectForKey:@"parentName"];

    } else {
        
        NSString * error = [dict objectForKey:@"error"];
        
        UIAlertView * av= [[UIAlertView alloc]initWithTitle:@"绑定失败" message:error delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        av.tag = 890;
        
        [av show];
    }
}
#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message {
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag ==888) {
        if (buttonIndex==0) {
              [self.readerView start];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag ==889) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag ==890) {
        if (buttonIndex==0) {
          [self.readerView start];
            timer = [NSTimer scheduledTimerWithTimeInterval:1/FPS
                                                     target:self
                                                   selector:@selector(animate:)
                                                   userInfo:nil
                                                    repeats:YES];
        }
    }
}

//点击播放声音
-(void)playClickSound{
    @autoreleasepool {
        if (!avPlayer) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"click4" ofType:@"wav"];
            avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
            // 调节音量 (范围从0到1)
            avPlayer.volume = 1.0f;
            avPlayer.delegate=self;
        } else {
            [avPlayer stop];
        }
        
        if (GetVersion) {
            [avPlayer prepareToPlay];
        }
        
        [avPlayer play];
    }
}

@end
