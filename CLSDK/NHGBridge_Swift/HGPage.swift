//
//  HGPage.swift
//  CLSDK
//
//  Created by  on 2022/3/16.
//


import Foundation

class HGPage: NSObject {
    
    /// 父控制器
    private var vc: UIViewController?
    
    /// 跳转小程序代理
    @objc public var openPageCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 跳转Summer小应用代理
    @objc public var openAppCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 跳转系统浏览器代理
    @objc public var openSystemWebCallBack: (([String: Any]) -> ())?
    
    /// 小程序H5回调
    private var bCompletionHander: JSCallback?
    
    /// 小应用H5回调
    private var appCompletionHander: JSCallback?
    
    /// 系统浏览器H5回调
    private var systemWebCompletionHander: JSCallback?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    // MARK: 打开页面
    /// 打开页面
    /// - Parameter params: {"pageId":"333","appId":"333","msg":"首页"} 2023.7.14 改
    /// 改 {"pageId":"evaluate","pageParam":{"taskCode":"value","appId":"value"}
    /// pageId 原生页面ID appId 应用ID msg页面信息
    /// 改 pageId 原生页面ID  pageParam 传递给页面的参数，不同页面可接收的参数不同，且固定。详见页面和页面参数。
    @objc func openPage(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var pageId = ""
        var pageParam = NSDictionary()
//        var msg = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            pageId = dic["pageId"] as? String ?? ""
            print("HGPage openPage pageId = \(pageId )")
            pageParam = dic["pageParam"] as? NSDictionary ?? NSDictionary()
            print("HGPage openPage pageParam = \(pageParam )")
//            msg = dic["msg"] as? String ?? ""
//            print("HGPage openPage msg = \(msg)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            pageId = dic["pageId"] as? String ?? ""
            print("HGPage openPage pageId = \(pageId )")
            pageParam = dic["pageParam"] as? NSDictionary ?? NSDictionary()
            print("HGPage openPage pageParam = \(pageParam )")
            
        }
        if let block = openPageCallBack {
            bCompletionHander = completionHandler
            block(dic as! [String : Any], completionHandler)
        }
    }
    
    // MARK: 打开Summer小应用
    /// 打开Summer小应用
    /// - Parameter params: {"appId":"333"}
    /// appId 小应用ID
    @objc func openApp(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var appId = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            appId = dic["appId"] as? String ?? ""
            print("HGPage openApp appId = \(appId)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            appId = dic["appId"] as? String ?? ""
            print("HGPage openApp appId = \(appId)")
        }
        if let block = openAppCallBack {
            appCompletionHander = completionHandler
            block(dic as! [String : Any], completionHandler)
        }
    }
    
    // MARK: 打开系统浏览器
    /// 打开系统浏览器
    /// - Parameter params: {"url":"http://"}
    /// url url
    @objc func openSystemWebview(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var url = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            url = dic["url"] as? String ?? ""
            print("HGPage openSystemWebview url = \(url)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            url = dic["url"] as? String ?? ""
            print("HGPage openSystemWebview url = \(url)")
        }
        if let block = openSystemWebCallBack {
            systemWebCompletionHander = completionHandler
            block(dic as! [String : Any])
        }
    }
    
    // MARK: 结果传给H5
    /// - Parameter dic: 传回的字典
    public func setPageResultToH5(_ dic: NSDictionary) {
        bCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    // MARK: 小应用结果传给H5
    /// - Parameter dic: 传回的字典
    public func setOpenAppResultToH5(_ dic: NSDictionary) {
        appCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    // MARK: 系统浏览器传给H5
    /// - Parameter dic: 传回的字典
    public func setSystemWebResultToH5(_ dic: NSDictionary) {
        systemWebCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
}
