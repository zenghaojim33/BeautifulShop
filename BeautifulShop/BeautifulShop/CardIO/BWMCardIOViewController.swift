//
//  BWMCardIOView.swift
//  ScanExample
//
//  Created by Bi Weiming on 15/5/19.
//  Copyright (c) 2015年 card.io. All rights reserved.
//

import UIKit

@objc protocol BWMCardIOViewControllerDelegate : NSObjectProtocol {
    /**
    当BWMCardIOViewController收到识别结果的时候回调
    
    :param: cardIOViewCtroller 回调此代理方法的BWMCardIOViewController
    :param: cardNumber         收到的识别结果卡号字符串
    */
    func cardIOViewCtroller(cardIOViewCtroller:BWMCardIOViewController, didScanCard cardNumber:String)
}

/**
*  @brief  一个用摄像头扫描识别长度为16位银行卡的视图控制器
*/
class BWMCardIOViewController : UIViewController {
    var cardIOView:CardIOView!
    weak var delegate:BWMCardIOViewControllerDelegate?
    private let _scanInstructions:String = "将银行卡放置在绿色框内。\n目前只能识别长度为16位的卡，\n其他卡请手动输入。"
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    class func createWithDelegate(delegate:BWMCardIOViewControllerDelegate) -> BWMCardIOViewController {
        var vc:BWMCardIOViewController = BWMCardIOViewController()
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        if (!CardIOUtilities.canReadCardWithCamera()) {
            UIAlertView(title: "无法访问设备的摄像头", message: nil, delegate: self, cancelButtonTitle: "确定").show()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.cardIOView = CardIOView(frame: CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20 - 60))
            self.cardIOView.delegate = self
            self.cardIOView.hideCardIOLogo = true
            self.cardIOView.scanInstructions = _scanInstructions
            self.view.addSubview(self.cardIOView)
            
            var cancelBtn:UIButton = UIButton(frame: CGRectMake(5, self.view.frame.size.height-50, self.view.frame.size.width-10, 50))
            cancelBtn.setTitle("< 返回 >", forState: UIControlState.Normal)
            cancelBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16.0)
            cancelBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            cancelBtn.addTarget(self, action: "cancelBtnClicked:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(cancelBtn)
        }
    }
    
    func cancelBtnClicked(sender:UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CardIOUtilities.preload()
    }
    
}

extension BWMCardIOViewController : UIAlertViewDelegate {
    // UIAlertViewDelegate
    func alertViewCancel(alertView: UIAlertView) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension BWMCardIOViewController : CardIOViewDelegate {
    // CardIOViewDelegate
    func cardIOView(cardIOView: CardIOView!, didScanCard cardInfo: CardIOCreditCardInfo!) {
        println("识别结果：\(cardInfo)")
        
        if cardInfo != nil {
            if self.delegate != nil {
                self.delegate?.cardIOViewCtroller(self, didScanCard: cardInfo.cardNumber)
            }
        } else {
            UIAlertView(title: "无法识别的银行卡", message: nil, delegate: self, cancelButtonTitle: "确定").show()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
