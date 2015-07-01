//
//  SirenManager.swift
//  SwiftJSONTest
//
//  Created by 伟明 毕 on 15/5/10.
//  Copyright (c) 2015年 Bi Weiming. All rights reserved.
//

import Foundation

/*** 版本检测器 */
@objc class BWMSirenManager : NSObject {
    // 需要检测的Apple Store APP ID
    private static let AppID:String = "914430432"
    
    // 对应的BundleID，如果BundleID不一致，不会调用版本检测器
    private static let BundleID:String = "com.AppStore.BeautifulShop.BeautifulShop"
    
    private class func p_defaultSiren() -> Siren? {
        var bundleID:NSString = NSBundle.mainBundle().bundleIdentifier!
        if (bundleID.isEqualToString(BundleID)) {
            let theSiren:Siren! =  Siren.sharedInstance
            theSiren.appID = self.AppID
            theSiren.alertType = SirenAlertType.Option;
            return theSiren
        } else {
            return nil
        }
    }
    
    /**
    调用版本检测
    
    :param: checkType 检测频率类型
    :param: delegate  事件回调delegate
    */
    class func run(versionCheckType checkType:SirenVersionCheckType, withDelegate delegate:SirenDelegate?) {
        if(self.p_defaultSiren() != nil) {
            let theSiren:Siren = self.p_defaultSiren()!
            theSiren.checkVersion(checkType)
            theSiren.delegate = delegate
        }
    }
    
    /**
    获取当前版本
    
    :returns: 返回当前版本字符串
    */
    class func currentVersion() -> NSString? {
        var infoDict:NSDictionary = NSBundle.mainBundle().infoDictionary as NSDictionary!
        let version:NSString? = infoDict.objectForKey("CFBundleShortVersionString") as? NSString
        return version
    }
    
    /**
    获取最新版本
    
    :returns: 返回最新版本字符串
    */
    class func newVersion() -> NSString? {
        let url:NSURL = NSURL(string: "http://itunes.apple.com/lookup?id=\(self.AppID)")!
        if let data:NSData? = NSData(contentsOfURL: url) {
            let dict:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            if (dict["results"]?.count > 0) {
                let version:NSString? = dict["results"]?[0]?["version"] as? NSString
                if (version == nil) {
                    return "1.0.0"
                } else {
                    return version
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private override init() {}
}
