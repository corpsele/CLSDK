//
//  HGQRCode.swift
//  CLSDK
//
//  Created by  on 2021/11/15.
//

import Foundation
import UIKit

class HGScanner: NSObject {
    ///父控制器
    private var vc: UIViewController?
    
    /// 扫码回调
    @objc public var scannerCallBack: (([String: Any]) -> ())?
    /// 扫码取消回调
    @objc public var scannerCancelCallBack: (() -> ())?
    
    /// 扫码后回调
    private var sCompletionHandler: JSCallback?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    // MARK: 扫码后结果传给H5
    /// - Parameter dic: 字典
    public func setScannerResultToH5(_ dic: NSDictionary) {
        print("HGScanner openScanner setScannerResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    // MARK: 条形扫描接口
    @objc func openScanner(_ params: Any, completionHandler: @escaping JSCallback) {
        print("HGScanner openScanner")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = scannerCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
//        showScannerView(completionHandler: completionHandler)
    }
    /*
    // MARK: 显示扫码界面并回调
    private func showScannerView(completionHandler: @escaping JSCallback) {
        let vc = IUMQRCodeViewController()
        vc.tintMsg = "扫描报关单二维码条形码\n查询报关单最新状态"
        vc.scannerType = .both
//        vc.qrcodeCancelBlock = scannerCancelCallBack
        self.vc?.present(vc, animated: true) {
            
        }
        vc.qrcodeFinishBlock = {[weak self] str in
            if let strongSelf = self {
                if let b = strongSelf.scannerCallBack {
                    let _ = b()
                }
            }
            print("扫描结果 \(String(describing: str))  个数\(str?.count) 包含星号\(str?.hasPrefix("*"))")
            let json = getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功", "result": ["content": str]])
            completionHandler(json, true);
            vc.dismiss(animated: true) {
                let pStrFlag = str?.hasPrefix("*") ?? false
//                let pStr = "*"
                if pStrFlag && str?.count == 20 {
                    //报关单状态查询
                }else if str?.count == 0 {
                    print("未检测到正确的报关单号二维码或条形码")
                }else{
                    print("请扫描正确的报关单号")
                }
            }
            
        }
        vc.qrcodeCancelBlock = { [weak self] in
            print("vc qrcodeCancelBlock")
            if let strongSelf = self {
                if let b = strongSelf.scannerCancelCallBack {
                    print("webview scannerCancelCallBack")
                    b()
                }
            }
            let json = getJSONStringFromDictionary(dictionary: ["responseCode": "2", "responseMsg": "扫码取消", "code": "2", "msg": "扫描取消", "result": ["content": ""]])
            completionHandler(json, true)
        }
    }
     */
}
