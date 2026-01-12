//
//  HGCollection.swift
//  CLSDK
//
//  Created by hgmeap on 2022/9/20.
//

import Foundation

class HGCollection: NSObject {
    /// 父控制器
    private var vc: UIViewController?

    /// 收藏回调block
    @objc public var deleteCollectionCallBack: (([String: Any], JSCallback) -> Void)?

    /// 加密请求的H5回调
    private var bCompletionHandler: JSCallback?

    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
     
    
    /// 数据加密接口
    /// - Parameters:
    ///   - params: H5参数
    ///   - completionHandler: 回调给H5
    @objc func deleteCollection(_ params: Any, completionHandler: @escaping JSCallback) {
        
        var dic = NSDictionary()
        var data = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            data = dic["data"] as? String ?? ""
            print("HGCollection deleteCollection = \(data)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            data = dic["data"] as? String ?? ""
            print("HGCollection deleteCollection = \(data)")
        }
        
    if let block = deleteCollectionCallBack {
        bCompletionHandler = completionHandler
        block(dic as! [String : Any], completionHandler)
    }

}
    
    // MARK: 收藏状态传给H5
    /// - Parameter dic: 字典
    public func setCollectionResultToH5(_ dic: NSDictionary) {
        print("HGCollection deleteCollection setCollectionResultToH5")
        bCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
}
