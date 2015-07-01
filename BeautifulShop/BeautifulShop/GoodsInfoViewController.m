//
//  GoodsInfoViewController.m
//  BeautifulShop
//
//  Created by BeautyWay on 14-10-15.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "BWMMBProgressHUD.h"
#import "MWPhotoBrowser.h"
#import "UIWebView+AFNetworking.h"
#import "NSString+BWMExtension.h"
#import "BWMRequestCenter.h"

@interface GoodsInfoViewController () <UIWebViewDelegate, MWPhotoBrowserDelegate, UINavigationControllerDelegate> {
    MBProgressHUD *_HUD;
    MWPhotoBrowser *_photoBrowser;
    NSURL *_imageURL;
    NSArray *_imagesURLArray;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GoodsInfoViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.title == nil) {
        self.title = @"请稍后..";
    }
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [backButton addTarget:self action:@selector(backItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftBarButtomItem;
    
    UIBarButtonItem *closeBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnItemClicked:)];
    self.navigationItem.rightBarButtonItem = closeBtnItem;
}

- (void)closeBtnItemClicked:(UIBarButtonItem *)btnItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backItemClicked {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ShareInfo *shareInfo = [ShareInfo shareInstance];
    NSString *link = [NSString stringWithFormat:LoginO2O, [ShareInfo shareInstance].userModel.phone, [ShareInfo shareInstance].userModel.password, [ShareInfo shareInstance].userModel.udid];
    [BWMRequestCenter GET:link parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        shareInfo.userModel = [MTLJSONAdapter modelOfClass:[O2OUserModel class] fromJSONDictionary:responseObject error:nil];
        NSLog(@"刷新用户数据成功！");
        [ShareInfo saveUserModel];
        [self loadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [BWMMBProgressHUD showTitle:@"加载失败" toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval msgType:BWMMBProgressHUDMsgTypeError];
        self.title = kBWMMBProgressHUDLoadErrorMsg;
    }];

}

- (void)loadData {
    NSURL * url = [NSURL URLWithString:self.url];
    NSLog(@"%@", self.url);
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    
    [self setCookie];
    
    MBProgressHUD *HUD = [BWMMBProgressHUD showDeterminateHUDTo:self.view];
    
    [self.webView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        [HUD setProgress:(float)totalBytesWritten/totalBytesExpectedToWrite];
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        [HUD hide:YES];
        return HTML;
    } failure:^(NSError *error) {
        [HUD hide:YES];
        [BWMMBProgressHUD showTitle:kBWMMBProgressHUDLoadErrorMsg toView:self.view hideAfter:kBWMMBProgressHUDHideTimeInterval];
        self.title = kBWMMBProgressHUDLoadErrorMsg;
    }];

}

//设置cookie
- (void)setCookie {
    [self deleteCookie];
    NSString *tokenValue = [ShareInfo shareInstance].userModel.token;
    NSString *shopIDValue = [ShareInfo shareInstance].userModel.userID;
   
    NSHTTPCookie *tokenCookie = [self p_cookiePropertiesDictionaryWithKey:@"TOKEN" value:tokenValue];
    NSHTTPCookie *isApp = [self p_cookiePropertiesDictionaryWithKey:@"isApp" value:@"1"];
    NSHTTPCookie *shopID = [self p_cookiePropertiesDictionaryWithKey:@"ShopId" value:shopIDValue];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:tokenCookie];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:isApp];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:shopID];
}

- (NSHTTPCookie *)p_cookiePropertiesDictionaryWithKey:(NSString *)key value:(NSString *)value {
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    [cookiePropertiesUser setObject:key forKey:NSHTTPCookieName];
    [cookiePropertiesUser setObject:value forKey:NSHTTPCookieValue];
    [cookiePropertiesUser setObject:@"web.mallteem.com" forKey:NSHTTPCookieDomain];
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];
    // set expiration to one month from now or any NSDate of your choosing
    // this makes the cookie sessionless and it will persist across web sessions and app launches
    /// if you want the cookie to be destroyed when your app exits, don't set this
    [cookiePropertiesUser setObject:[[NSDate date] dateByAddingTimeInterval:99629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    return cookieuser;
}

// 清除cookie
- (void)deleteCookie{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookieAry = [cookieJar cookiesForURL:[NSURL URLWithString:self.url]];
    
    for (cookie in cookieAry) {
        NSLog(@"%@", cookie);
        [cookieJar deleteCookie: cookie];
    }
}

#pragma mark- UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.title = @"请稍后..";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = theTitle;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 获取请求网址
    NSString *urlString = request.URL.absoluteString;
    // 如果请求网址是图片的话...
    if ([urlString hasSuffix:@".png"] || [urlString hasSuffix:@".jpg"] || [urlString hasSuffix:@".gif"] || [urlString hasSuffix:@".jpeg"] || [urlString hasSuffix:@".bmp"]) {
        
        if (_imagesURLArray == nil) {
            NSString *imgs = [webView stringByEvaluatingJavaScriptFromString:
                              @"function requestImages() {"
                              "var re = new RegExp(/_\\.png$/);"
                              "var imgs = document.getElementsByTagName('img');"
                              "var imgsArray = new Array();"
                              "for (var i=0; i<imgs.length; i++) {"
                              "if ((i != 0) && (!imgs[i].src.match(re)) && (imgs[i].src!=''))"
                              "imgsArray.push(imgs[i].src);"
                              "}"
                              "imgsArray.shift();"
                              "return imgsArray.toString();"
                              "}"
                              "requestImages();"
                              ];
            _imagesURLArray = [NSMutableArray arrayWithArray:[imgs componentsSeparatedByString:@","]];
        }
        
        [self p_openPhotoBrowser];
        
        NSInteger currentIndex = [_imagesURLArray indexOfObject:urlString];
        [_photoBrowser setCurrentPhotoIndex:currentIndex];
        
        return NO;
    }
    return YES;
}

// 打开PhotoBrowser
- (void)p_openPhotoBrowser {
    // 创建photoBrowser
    if (!_photoBrowser) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.enableGrid = YES;              // 采用表格视图
        _photoBrowser.enableSwipeToDismiss = NO;    // 不采用滑动Dismiss
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.delayToHideElements = 1.5;
        _photoBrowser.alwaysShowControls = NO;
    }
    // 刷新数据
    [_photoBrowser reloadData];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_photoBrowser];
    [self presentViewController:nav animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
}

#pragma mark- MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _imagesURLArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSURL *url = [NSURL URLWithString:_imagesURLArray[index]];
    MWPhoto *photo = [MWPhoto photoWithURL:url];
    photo.caption = @"图片预览";
    return photo;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    NSURL *url = [NSURL URLWithString:_imagesURLArray[index]];
    MWPhoto *photo = [MWPhoto photoWithURL:url];
    return photo;
}

@end
