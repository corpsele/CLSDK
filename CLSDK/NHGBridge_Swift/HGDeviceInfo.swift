//
//  HGDeviceInfo.swift
//  CLSDK
//
//  Created by  on 2021/11/15.
//

import Foundation
import UIKit

class HGDeviceInfo: NSObject {
    ///父控制器
    private var vc: UIViewController?
    
    /// 扫码回调
    @objc public var getDeviceInfoCallBack: (([String: Any]) -> ())?
    
    /// 定位回调
    @objc public var getLocationCallBack: (([String: Any]) -> ())?
    
    /// 定位海拔高度回调
    @objc public var getAltitudeCallBack: (([String: Any]) -> ())?
    
    /// 定位的H5回调
    private var lCompletionHandler: JSCallback?
    
    /// 海拔高度H5回调
    private var aCompletionHandler: JSCallback?
    
    /// H5回调
    private var dCompletionHandler: JSCallback?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /// MARK: 获取设备信息接口
    @objc func getDeviceInfo(_ params: Any, completionHandler: @escaping JSCallback) {
//        if let b = self.getDeviceInfoCallBack {
//            let _ = b()
//            print("getDeviceInfo \(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功", "result": ["deviceId": UIDevice.current.uuid, "deviceModel": UIDevice.current.platform, "deviceVersion": "iOS\(UIDevice.current.systemVersion)"]]))")
//            completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功", "result": ["deviceId": UIDevice.current.uuid, "deviceModel": UIDevice.current.platform, "deviceVersion": "iOS\(UIDevice.current.systemVersion)"]]), true);
//        }
        
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getDeviceInfoCallBack {
            dCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
        
    }
    
    @objc func setGetDeviceInfoResultToH5(_ dic: NSDictionary) {
        dCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    /// 获取位置接口
    /// - Parameters:
    ///   - params: H5参数 mode 1.GCJ02 2.BD09 3.WGS-84 altitude 1.传入true会返回高度信息
    ///   - completionHandler: 回调给H5 code 0.请求成功 1.请求失败 020011.请求参数错误 data=定位信息：longitude：经度，范围为 -180~180，负数表示西经 latitude：纬度，范围为 -90~90，负数表示南纬 accuracy:位置精确度（单位：m，反应与真实位置之间的接近程度，数值越小越精确） altitude:高度，单位 m
    @objc func getLocation(_ params: Any, completionHandler: @escaping JSCallback) {
        print("HGDeviceInfo getLocation")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getLocationCallBack {
            lCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
//        completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": ""]), true);
    }
    
    
    /// 定位信息传个
    /// - Parameter dic: 返给H5的结果
    @objc func setGetLocationResultToH5(_ dic: NSDictionary) {
        print("HGDeviceInfo setGetLocationResultToH5")
        lCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    
    /// 获得定位海拔高度
    /// - Parameters:
    ///   - params: H5参数
    ///   - completionHandler: 回调给H5
    @objc func getAltitude(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getAltitudeCallBack {
            aCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    /// 定位信息传个
    /// - Parameter dic: 返给H5的结果
    @objc func setGetAltitudeResultToH5(_ dic: NSDictionary) {
        aCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
}
