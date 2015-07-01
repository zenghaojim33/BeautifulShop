//
//  BWMSoundManager.m
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/21.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import "BWMSoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

static NSString * const kReceiveNotificationSoundFileNamed = @"DoorbellSound";
static NSString * const kReceiveNewVersionAlertSoundFileNamed = @"Ding-Dong";

@implementation BWMSoundManager

+ (instancetype)sharedManager {
    static BWMSoundManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BWMSoundManager alloc] init];
    });
    return manager;
}

- (void)playSoundWithFileNamed:(NSString *)fileNamed {
    static SystemSoundID shake_sound_male_id = 0;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileNamed ofType:@"wav"];
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    
    // 播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    AudioServicesPlaySystemSound(shake_sound_male_id);
    
    // 让手机震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)playReceiveNotificationSound {
    [[BWMSoundManager sharedManager] playSoundWithFileNamed:kReceiveNotificationSoundFileNamed];
}

+ (void)playReceiveNewVersionAlertSound {
    [[BWMSoundManager sharedManager] playSoundWithFileNamed:kReceiveNewVersionAlertSoundFileNamed];
}

@end
