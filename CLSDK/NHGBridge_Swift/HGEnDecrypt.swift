//
//  HGEnDecrypt.swift
//  CLSDK
//
//  Created by eport on 2022/12/14.
//

import Foundation


class HGEnDecrypt: NSObject {
    
    ///父控制器
    private var vc: UIViewController?
    
    /// 加解密后H5回调
    private var sCompletionHandler: JSCallback?
    
    /// 加解密回调
    @objc public var sm4EnDeCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /*
     加解密接口
    mode    加密类型/方式：
    0：加密
    1：解密
    model    加密模式
    0：ECB，
    1：CBC
    若加密模式选择为ECB时，iv传参为null即可，若使用CBC，iv传参String
    data    待加密/解密数据
    key    对称秘钥
    iv    偏移量16字节
     */
    @objc func SM4SysEnDecrypt(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGEnDecrypt SM4SysEnDecrypt")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = sm4EnDeCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 获取图片结果传给H5
    /// - Parameter dic: 字典
    public func setSM4EnDeResultToH5(_ dic: NSDictionary) {
        print("SM4EnDe sm4EnDe setResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
}
