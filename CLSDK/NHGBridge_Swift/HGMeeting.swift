//
//  HGMeeting.swift
//  CLSDK
//
//  Created by eport on 2025/11/3.
//


import Foundation

class HGMeeting: NSObject {
    
    ///父控制器
    private var vc: UIViewController?
    
    /// 支付后H5回调
    private var sCompletionHandler: JSCallback?
    
    /// 支付回调
    @objc public var joinMeetingCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /*
     支付接口
     */
    @objc func joinMeeting(_ params: Any, completionHandler: @escaping JSCallback){
        print("HGMeeting joinMeeting")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = joinMeetingCallBack {
            sCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 支付结果传给H5
    /// - Parameter dic: 字典
    public func setJoinMeetingResultToH5(_ dic: NSDictionary) {
        print("HGMeeting joinMeeting setResultToH5")
        sCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
}
