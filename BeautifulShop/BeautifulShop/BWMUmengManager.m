//
//  BWMUmengManager.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/13.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMUmengManager.h"
#import "UMSocialData.h"
#import "UMSocialYixinHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialTwitterHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialInstagramHandler.h"
#import "UMSocialWhatsappHandler.h"
#import "UMSocialLineHandler.h"
#import "UMSocialTumblrHandler.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMSocialAccountManager.h"
#import "NSString+BWMExtension.h"
// sina.552752e3fd98c5ee0c001f2c
static NSString * const kUMengAPPKey = @"54535491fd98c5fca100075d";

static NSString * const kWXAppId = @"wx13d0fdc20e062e68";
static NSString * const kWXAppSecret = @"68a1e47766dd89429ddc269ec82faa5f";
static NSString * const kWXURL = @"http://beautyway.com.cn";

static NSString * const kWBSSORedirectURL = @"http://sns.whalecloud.com/sina2/callback";

static NSString * const kQQAppId = @"1103439635";
static NSString * const kQQAppKey = @"8UpCkULYFgQNHLE6";
static NSString * const kQQURL = @"http://beautyway.com.cn";

NSString * const kDefaultShareDetailText = @"我开了个美店，我觉得也会适合你。点开看看咯。常联系！";
NSString * const kDefaultShareQRCodeText = @"美店二维码";
NSString * const kDefaultShareShopText = @"美店二维码";

static NSString * const kDefaultImageNamed = @"TheIcon";

@implementation BWMUmengManager

+ (void)initializeUMengShareComponent {
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUMengAPPKey];
    
    // 设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:kWXURL];
    
    // 打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:kWBSSORedirectURL];
    
    // 设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppKey url:kQQURL];
    
    // 设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    // 打开whatsapp
    [UMSocialWhatsappHandler openWhatsapp:UMSocialWhatsappMessageTypeImage];
    
    // 打开Tumblr
    [UMSocialTumblrHandler openTumblr];
    
    // 打开line
    [UMSocialLineHandler openLineShare:UMSocialLineMessageTypeImage];
    
}

+ (void)sharingWithController:(UIViewController *)controller
                   shareTitle:(NSString *)shareTitle
                  shareDetail:(NSString *)shareDetail
                   shareImage:(id)shareImage
                    shareLink:(NSString *)shareLink
                     delegate:(id <UMSocialUIDelegate>)delegate {
    
    [MBProgressHUD showHUDAddedTo:controller.view animated:YES];

    // 微信配置
    NSString *wechatLink = shareLink;
    if (([shareLink rangeOfString:@"Shop.aspx"].location != NSNotFound) || ([shareLink rangeOfString:@"ProductDetail.aspx"].location != NSNotFound)) {
        wechatLink = [shareLink bwm_wechatURLString];
    }
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = wechatLink;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = wechatLink;
    
    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@\n%@",shareDetail, shareLink];
    
    // QQ配置
    [UMSocialData defaultData].extConfig.qqData.url = shareLink;
    [UMSocialData defaultData].extConfig.qzoneData.url = shareLink;
    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
    
    // 新浪微博
    
    if ([shareImage isKindOfClass:[UIImage class]] || [shareImage isKindOfClass:[NSData class]]) {
        
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        [self p_sharingWithController:controller shareText:shareDetail shareImage:shareImage delegate:delegate];
        
    } else if([shareImage isKindOfClass:[NSString class]]) {
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:shareImage] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [MBProgressHUD hideHUDForView:controller.view animated:YES];
            [self p_sharingWithController:controller shareText:shareDetail shareImage:image delegate:delegate];
        }];
        
    } else if ([shareImage isKindOfClass:[NSURL class]]) {
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:shareImage options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [MBProgressHUD hideHUDForView:controller.view animated:YES];
            [self p_sharingWithController:controller shareText:shareDetail shareImage:image delegate:delegate];
        }];
        
    } else {
        
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        shareImage = [UIImage imageNamed:kDefaultImageNamed];
        [self p_sharingWithController:controller shareText:shareDetail shareImage:shareImage delegate:delegate];
   
    }
}

+ (void)settingWXShareTypeWeb {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
}

+ (void)settingWXShareTypeImage {
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
}

// 集成微信登录
+ (void)loginWeixinWithTargetViewController:(UIViewController *)targetController
                                 completion:(void(^)(NSDictionary *dataDict))completionCallBlock {
    // 在微信登录按钮中实现下面的方法
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];

    snsPlatform.loginClickHandler(targetController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@", snsAccount.userName, snsAccount.usid, snsAccount.accessToken, snsAccount.iconURL);
        }
    });
    
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession completion:^(UMSocialResponseEntity *response){
        if (completionCallBlock) {
            completionCallBlock(response.data);
        }
    }];
}

+ (void)p_sharingWithController:(UIViewController *)controller
                      shareText:(NSString *)shareText
                     shareImage:(id)shareImage
                       delegate:(id <UMSocialUIDelegate>)delegate {
    
    [UMSocialSnsService presentSnsIconSheetView:controller
                                         appKey:kUMengAPPKey
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:[self p_supportSnsNames]
                                       delegate:delegate];

}

+ (NSArray *)p_supportSnsNames {
    return @[UMShareToWechatSession,
             UMShareToWechatTimeline,
             UMShareToSina,
             UMShareToQQ,
             UMShareToQzone,
             UMShareToTencent];
}

@end
