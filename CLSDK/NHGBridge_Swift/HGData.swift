//
//  HGData.swift
//  CLSDK
//
//  Created by  on 2022/3/16.
//

import Foundation

class HGData: NSObject {
    /// 父控制器
    private var vc: UIViewController?
    
    /// 数据加密回调block
    @objc public var dataEncryptCallBack: (([String: Any], JSCallback) -> ())?
    
    /// 数据加密的H5回调
    private var bCompletionHander: JSCallback?
    
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    
    /// 数据加密接口
    /// - Parameters:
    ///   - params: H5参数
    ///   - completionHandler: 回调给H5
    @objc func dataEncrypt(_ params: Any, completionHandler: @escaping JSCallback) {
        
            var dic = NSDictionary()
            var data = ""
            if (params is String){
                dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
                data = dic["data"] as? String ?? ""
                print("HGData dataEncrypt = \(data)")
            }else if(params is NSDictionary) {
                dic = params as? NSDictionary ?? NSDictionary()
                data = dic["data"] as? String ?? ""
                print("HGData dataEncrypt = \(data)")
            }
            
        if let block = dataEncryptCallBack {
            bCompletionHander = completionHandler
            block(dic as! [String : Any], completionHandler)
        }

    }
    
    // MARK: 结果传给H5
    /// - Parameter dic: 加密后的字典
    public func setResultToH5(_ dic: NSDictionary){
        print("HGSign dataSign setResultToH5")
        bCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
}
