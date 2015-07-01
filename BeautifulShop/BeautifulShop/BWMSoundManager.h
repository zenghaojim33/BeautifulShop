//
//  BWMSoundManager.h
//  BeautifulShop
//
//  Created by Bi Weiming on 15/4/21.
//  Copyright (c) 2015年 jenk. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 一个管理铃声的类 */
@interface BWMSoundManager : NSObject

/** A Singleton Of BWMSoundManager */
+ (instancetype)sharedManager;

/** 根据文件名（仅支持.wav）播放声音 */
- (void)playSoundWithFileNamed:(NSString *)fileNamed;

/** 播放接收到远程推送消息的声音 */
+ (void)playReceiveNotificationSound;

/** 播放接收到新版本提示的声音 */
+ (void)playReceiveNewVersionAlertSound;

@end