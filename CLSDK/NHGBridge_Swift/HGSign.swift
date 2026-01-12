//
//  NGShield.swift
//  CLSDK
//
//  Created by  on 2021/12/13.
//

import Foundation

class HGSign: NSObject {
    /// 父控制器
    private var vc: UIViewController?
    
    /// 设置手机盾加签入参block
    @objc public var setShieldParamForSignCallBack: ((Any) -> ([String: Any]))?
    
    /// 手机盾加签回调block
    @objc public var shieldForSignCallBack: ((Any, JSCallback) -> ())?
    
    /// 手机盾加签后的H5回调
    private var bCompletionHander: JSCallback?
    
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    
    /// 手机盾加签接口
    /// - Parameters:
    ///   - params: H5参数
    ///   - completionHandler: 回调给H5
    @objc func dataSign(_ params: Any, completionHandler: @escaping JSCallback) {
        print("HGSign dataSign = \(params)")
        //使用这个方法是调用sdk里的手机盾加签方法，先传入参给sdk，sdk中的sdk请求加签返回给h5
        if let block = self.setShieldParamForSignCallBack {
            var dic = NSDictionary()
            var signInfo = ""
            var type = DataSignType.shield
            if (params is String){
                dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
                signInfo = dic["signInfo"] as? String ?? ""
                print("dataSign signInfo = \(signInfo ?? "")")
                type = dic["type"] as? DataSignType ?? .shield
            }else if(params is NSDictionary) {
                dic = params as? NSDictionary ?? NSDictionary()
                signInfo = dic["signInfo"] as? String ?? ""
                print("dataSign signInfo = \(signInfo ?? "")")
                type = dic["type"] as? DataSignType ?? .shield
            }
            switch type {
            case DataSignType.shield:
                print("type = \(DataSignType.shield) signInfo = \(signInfo)")
//                self.hgShield(dic as! [String : Any], completionHandler: completionHandler)

//                let dic = block(params) as? NSDictionary
//                completionHandler(getJSONStringFromDictionary(dictionary: dic ?? [:]), true)
                bCompletionHander = completionHandler
                //使用这个方法是调用app内部的手机盾加签，h5调用方法后回调给app，app处理加签返回给h5
                
                if let block = self.shieldForSignCallBack {
                    block(dic, completionHandler)
                }
                return
            case .none:
                print("none")
//            case .some(_):
//                print("some")
                return
            }
            
//            completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功"]), true)

        }
        

    }
    
    // MARK: 加签后的结果传给H5
    /// - Parameter dic: 加签后的字典
    public func setResultToH5(_ dic: NSDictionary){
        print("HGSign dataSign setResultToH5")
        bCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    // MARK: 手机盾弹出层方法
//    private func hgShield(_ dic: [String: Any], completionHandler: @escaping JSCallback){
//        let pinView = NHGInputPinView()
//        self.vc?.view.addSubview(pinView)
//        pinView.snp.makeConstraints { make in
//            make.top.left.centerX.centerY.equalToSuperview()
//        }
//        pinView.surePinBlock = { [weak self, weak pinView] pinString in
//            let signInfo = dic["signInfo"] as? String
//            let flag = false
//            NHGSignModel.signShieldInfo(signInfo ?? "", pinString: pinString, base64Code: flag) { success, infoMsg in
//                if infoMsg.contains("PIN码错误，请重新输入") {
//                    if let strongSelf = self {
//                        strongSelf.vc?.view.makeToast(infoMsg)
//                    }
//                    completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "-1", "responseMsg": infoMsg, "code": "-1", "msg": infoMsg]), true)
//                }
//                else if infoMsg.contains("用户被锁定") {
//                    if let strongSelf = self {
//                        strongSelf.vc?.view.makeToast(infoMsg)
//                    }
//                    completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "-1", "responseMsg": infoMsg, "code": "-1", "msg": infoMsg]), true)
//                }
//                else {
//                    if let strongPinView = pinView {
//                        strongPinView.removeFromSuperview()
//                    }
//                    completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "签名成功", "code": "0", "msg": "签名成功"]), true)
//                }
//            }
//        }
//    }
    
}
