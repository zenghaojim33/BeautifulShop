//
//  QRCodeViewController.h
//  BeautifulShop
//
//  Created by BeautyWay on 14-11-12.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>
@interface QRCodeViewController : UIViewController
<
AVAudioPlayerDelegate
>
{
       BOOL upOrdown;
       AVAudioPlayer *avPlayer;
}
@property (weak, nonatomic) IBOutlet ZBarReaderView *readerView;
@property (weak, nonatomic) IBOutlet UIView *redLine;

@end
