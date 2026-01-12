//
//  HGRequest.swift
//  CLSDK
//
//  Created by  on 2022/3/18.
//

import Foundation
/// 网络请求
class HGRequest: NSObject {
    /// 父控制器
    private var vc: UIViewController?

    /// 加密请求回调block
    @objc public var encryptRequestCallBack: (([String: Any], JSCallback) -> Void)?
    
    /// 与MA服务进行加密网络请求回调block
    @objc public var encryptRequestForMaCallBack: (([String: Any], JSCallback) -> Void)?

    /// 加密请求的H5回调
    private var bCompletionHandler: JSCallback?
    
    /// 新加密H5回调
    private var mCompletionHandler: JSCallback?

    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }

    /// 加密网络请求
    /// data    请求体参数，json格式
    /// header    请求头参数:key为header请求头的key，value为请求头的value（JSON）
    /// url    接口请求地址
    /// - Parameters:
    ///   - params: H5参数
    ///   - completionHandler: 回调给H5
    ///   code    服务请求状态，由服务定义，默认0为请求成功
    ///   msg    服务请求结果描述信息 0 成功 1 失败 101 网络差
    ///   result    服务器返回结果（JSON）
    @objc func encryptRequest(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var data = ""
        var header = ""
        var url = ""
        if params is String {
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            data = dic["data"] as? String ?? ""
            print("HGRequest encryptRequest data = \(data)")
            header = dic["header"] as? String ?? ""
            url = dic["url"] as? String ?? ""
            print("HGRequest encryptRequest header = \(header)")
            print("HGRequest encryptRequest url = \(url)")
        } else if params is NSDictionary {
            dic = params as? NSDictionary ?? NSDictionary()
            data = dic["data"] as? String ?? ""
            print("HGRequest encryptRequest = \(data)")
            header = dic["header"] as? String ?? ""
            url = dic["url"] as? String ?? ""
        }

        if let block = encryptRequestCallBack {
            bCompletionHandler = completionHandler
            block(dic as! [String: Any], completionHandler)
        }
    }
    
    /// 与MA服务进行加密网络请求
    /// data    请求体参数，json格式
    /// header    请求头参数:key为header请求头的key，value为请求头的value（JSON）
    /// url    接口请求地址
    /// - Parameters:
    ///   - params: H5参数
    ///   - completionHandler: 回调给H5
    ///   code    服务请求状态，由服务定义，默认0为请求成功
    ///   msg    服务请求结果描述信息 0 成功 1 失败 101 网络差
    ///   result    服务器返回结果（JSON）
    @objc func encryptRequestForMa(_ params: Any, completionHandler: @escaping JSCallback){
        var dic = NSDictionary()
        var data = ""
        var header = ""
        var url = ""
        if params is String {
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            data = dic["data"] as? String ?? ""
            print("HGRequest encryptRequestForMa data = \(data)")
            header = dic["header"] as? String ?? ""
            print("HGRequest encryptRequestForMa header = \(header)")
            url = dic["url"] as? String ?? ""
            print("HGRequest encryptRequestForMa url = \(url)")
        } else if params is NSDictionary {
            dic = params as? NSDictionary ?? NSDictionary()
            data = dic["data"] as? String ?? ""
            print("HGRequest encryptRequestForMa = \(data)")
            header = dic["header"] as? String ?? ""
            url = dic["url"] as? String ?? ""
        }

        if let block = encryptRequestForMaCallBack {
            mCompletionHandler = completionHandler
            block(dic as! [String: Any], completionHandler)
        }
    }

    // MARK: 结果传给H5

    /// - Parameter dic: 加密后的字典
    public func setResultToH5(_ dic: NSDictionary) {
        print("HGRequest encryptRequest setResultToH5")
        let str = getJSONStringFromDictionary(dictionary: dic)
        print("HGRequest encryptRequest setResultToH5 getJSONStringFromDictionary = \(str)")
        bCompletionHandler?(str, true)
    }
    
    // MARK: 结果传给H5

    /// - Parameter dic: 加密后的字典
    public func setMaResultToH5(_ dic: NSDictionary) {
        print("HGRequest encryptRequest setResultToH5")
        let str = getJSONStringFromDictionary(dictionary: dic)
        print("HGRequest encryptRequest setResultToH5 getJSONStringFromDictionary = \(str)")
        mCompletionHandler?(str, true)
    }
    
    public func setResultToH5(_ str: String) {
        setResultsToH5(bCompletionHandler!, str)
    }
}
