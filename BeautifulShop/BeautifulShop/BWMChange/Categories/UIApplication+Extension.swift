//
//  UIApplication+Extension.swift
//  BeautifulShop
//
//  Created by 伟明 毕 on 15/5/10.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

import UIKit

extension UIApplication {
    /*** 注册远程推送 */
    func registerRemotePush() -> Void {
        if((UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0) {
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
            var settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: (UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound), categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        } else {
            self.registerForRemoteNotificationTypes((UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound))
        }
    }
}