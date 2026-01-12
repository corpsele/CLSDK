//
//  HGLogin.swift
//  CLSDK
//
//  Created by eport on 2024/5/17.
//

import Foundation


class HGLogin: NSObject {
    
    ///父控制器
    private var vc: UIViewController?
    
    /// H5回调
    private var sCompletionHandler: JSCallback?
    
    /// 回调
    @objc public var getUpdateLoginTimeCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /// 小应用访问会刷新jsessionId有效期的url之后，调用此接口更新原生记录的登录时间节点
    /// { \
    /// "code":0, \
    /// "msg":"成功" \
    /// }
    @objc func updateLoginTime(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGLogin updateLoginTime")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getUpdateLoginTimeCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 结果传给H5
    /// - Parameter dic: 字典
    public func setUpdateLoginTimeResultToH5(_ dic: NSDictionary) {
        print("HGLogin updateLoginTime setResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
}
