//
//  HGUser.swift
//  CLSDK
//
//  Created by eport on 2024/5/17.
//

import Foundation


class HGUser: NSObject {
    
    ///父控制器
    private var vc: UIViewController?
    
    /// H5回调
    private var sCompletionHandler: JSCallback?
    
    /// 回调
    @objc public var getUserInfoCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /// 获取登录用户的信息
    /// { \
    /// "code":0, \
    /// "msg":"成功", \
    /// "data":{ \
    /// "userId":"userId", \
    /// "userTypecd":"userTypecd", \"loginType":"loginType" \
    /// } \
    /// }
    @objc func getUserInfo(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGUser getUserInfo")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getUserInfoCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 结果传给H5
    /// - Parameter dic: 字典
    public func setGetUserInfoResultToH5(_ dic: NSDictionary) {
        print("HGUser getUserInfo setResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
}
