//
//  HGSystem.swift
//  CLSDK
//
//  Created by eport on 2024/5/17.
//

import Foundation


class HGSystem: NSObject {
    
    ///父控制器
    private var vc: UIViewController?
    
    /// H5回调
    private var sCompletionHandler: JSCallback?
    
    /// 打开第三方APP回调
    private var oCompletionHandler: JSCallback?
    
    /// 回调
    @objc public var getDialCallBack: (([String: Any]) -> ())?
    
    /// 通过schemeUrl打开第三方APP回调
    @objc public var getOpenAppWithSchemeCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /// 拨打电话功能，仅拨号，需要用户点击打电话按钮
    /// { \
    /// "code":0, \
    /// "msg":"成功" \
    /// }
    @objc func dial(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGSystem dial")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getDialCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 结果传给H5
    /// - Parameter dic: 字典
    public func setDialResultToH5(_ dic: NSDictionary) {
        print("HGSystem dial setResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    /// MARK: 通过schemeUrl打开第三方APP
    // {
    //    "scheme":"schemeUrl"
    //    }
    @objc func openAppWithScheme(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGSystem openAppWithScheme")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getOpenAppWithSchemeCallBack {
            oCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 通过schemeUrl打开第三方APP传给H5
    /// - Parameter dic: 字典
    public func setOpenAppWithSchemeResultToH5(_ dic: NSDictionary) {
        print("HGSystem openAppWithScheme setResultToH5")
        oCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
}
