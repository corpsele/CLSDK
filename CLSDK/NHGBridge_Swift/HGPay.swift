//
//  HGPayment.swift
//  CLSDK
//
//  Created by eport on 2023/7/12.
//

import Foundation

class HGPay: NSObject {
    
    ///父控制器
    private var vc: UIViewController?
    
    /// 支付后H5回调
    private var sCompletionHandler: JSCallback?
    
    /// 支付回调
    @objc public var openPaymentAppCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /*
     支付接口
     */
    @objc func openPaymentApp(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGPayment openPaymentApp")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = openPaymentAppCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 支付结果传给H5
    /// - Parameter dic: 字典
    public func setOpenPaymentAppResultToH5(_ dic: NSDictionary) {
        print("HGPayment openPaymentApp setResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
}
