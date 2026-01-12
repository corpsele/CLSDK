//
//  File.swift
//  CLSDK
//
//  Created by eport on 2024/5/17.
//

import Foundation

class HGApp: NSObject {
    
    ///父控制器
    private var vc: UIViewController?
    
    /// H5回调
    private var sCompletionHandler: JSCallback?
    
    /// 回调
    @objc public var getAppInfoCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /// 获取小应用的信息，包含字段详见参数。
    /// { \
    /// "code":0, \
    /// "msg":"成功", \
    /// "data":{ \
    /// "appCategory":"appCategory" \
    /// } \
    /// }
    @objc func getAppInfo(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGApp getAppInfo")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getAppInfoCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 结果传给H5
    /// - Parameter dic: 字典
    public func setGetAppInfoResultToH5(_ dic: NSDictionary) {
        print("HGApp getAppInfo setResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
}
