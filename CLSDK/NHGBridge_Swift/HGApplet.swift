//
//  HGApplet.swift
//  CLSDK
//
//  Created by  on 2022/2/17.
//

import Foundation

class HGApplet: NSObject {
    
    /// 父控制器
    private var vc: UIViewController?
    
    /// 跳转小程序代理
    @objc public var jumpAppletCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 小程序H5回调
    private var bCompletionHander: JSCallback?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    
    /// 跳转小程序
    @objc func openWeChatApplet(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var appId = ""
        var path = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            appId = dic["originalId"] as? String ?? ""
            print("HGApplet openWeChatApplet appId = \(appId )")
            path = dic["path"] as? String ?? ""
            print("HGApplet openWeChatApplet path = \(path)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            appId = dic["originalId"] as? String ?? ""
            print("HGApplet openWeChatApplet appId = \(appId )")
            path = dic["path"] as? String ?? ""
        }
        if let block = jumpAppletCallBack {
            bCompletionHander = completionHandler
            block(dic as! [String : Any], completionHandler)
        }
    }
    
    // MARK: 微信小程序跳回结果传给H5
    /// - Parameter dic: 小程序传回的字典
    public func setWeChatResultToH5(_ dic: NSDictionary) {
        bCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
}
