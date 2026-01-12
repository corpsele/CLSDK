//
//  HGVoice.swift
//  CLSDK
//
//  Created by  on 2021/9/7.
//

import UIKit
import AVFoundation

class HGVoice: NSObject {
    ///父控制器
    private var vc: UIViewController?
    ///讯飞语音AppId
//    private var iFlyAppId: String?
    
    /// 开始说话回调
    @objc public var speakStartBlock: (() -> ())?
    /// 取消说话回调
    @objc public var speakCancelBlock: (() -> ())?
    /// 说话正常识别且正常完成回调
    @objc public var speakEndBlock: ((_ str: String?) -> ())?
    /// 讯飞语音回调
    @objc public var speechRecognitionCallBack: ((Any) -> ())?
    /// 回调给h5
    private var bCompleteHandler: JSCallback?
    
    ///是否自定义界面
//    private var isCustomView: Bool = false
    
    /// 语音视图
//    private var mSpeakView: NHGSpeakView!
    
    private let alertTitle: String = "温馨提示"
    private let alertMsg: String = "您还没有允许使用麦克风权限，请到“设置-隐私-麦克风”开启"
    private let cancelAction: String = "取消"
    private let okAction: String = "去设置"
    /// 说话视图字体
    private var speakViewFont: UIFont?
    
    
    /**
     初始化插件
     - Parameters:
       - vc: 父控制器
       - isCustomView: 是否自定义界面
       - iFlyAppId: 讯飞语音AppId
     */
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
//        self.isCustomView = isCustomView
//        self.iFlyAppId = iFlyAppId
    }
    
    // MARK: 语音接口
    
    /// 语音接口
    /// - Returns: 返回拼接json字符串
    @objc func speechRecognition() -> String {
        return getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "responseResult": ["content": ""], "code": "0", "msg": "成功", "result": ["content": ""]])
    }
    
    // MARK: 语音接口
    
    /// 语音接口
    /// - Parameters:
    ///   - params: H5传的参数
    ///   - completionHandler: 返回拼接json字符串
    @objc func speechRecognition(_ params: Any, completionHandler: @escaping JSCallback) {
//        if startVoiceMethod() {
//            showSpeekView(params, completionHandler: completionHandler)
//        }
        var dic = NSDictionary()
        var type = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            type = dic["type"] as? String ?? ""
            print("Voice showSpeekView type = \(type)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            type = dic["type"] as? String ?? ""
            print("Voice showSpeekView type = \(type)")
        }
        if let block = self.speechRecognitionCallBack {
            bCompleteHandler = completionHandler
            block(dic)
        }
    }
    
    // MARK: 结果回调给h5
    public func setSpeechResultToH5(_ dic: NSDictionary) {
        bCompleteHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
//    /**
//     开始语音识别
//     */
//    @objc public func startRecognitionVoice(){
//        self.mSpeakView.startBtnHandler()
//    }
    
    /// 设置说话视图字体
    /// - Parameter font: 字体
    @objc public func setSpeakViewTextFont(_ font: UIFont) {
        self.speakViewFont = font
    }
    
//    // MARK: 显示语音界面
//
//    /// 显示语音界面
//    /// - Parameters:
//    ///   - params: type = normal large
//    ///   - completionHandler: 回调给H5
//    private func showSpeekView(_ params: Any, completionHandler: @escaping JSCallback){
//        var dic = NSDictionary()
//        var type = ""
//        if (params is String){
//            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
//            type = dic["type"] as? String ?? ""
//            print("Voice showSpeekView type = \(type ?? "")")
//        }else if(params is NSDictionary) {
//            dic = params as? NSDictionary ?? NSDictionary()
//            type = dic["type"] as? String ?? ""
//            print("Voice showSpeekView type = \(type ?? "")")
//        }
//        print("showSpeakView isCustomView = \(isCustomView)")
//        self.mSpeakView = NHGSpeakView.init(appId: self.iFlyAppId ?? "")
//        if type == "large" {
//            self.mSpeakView.setTextFont(UIFont.systemFont(ofSize: 28.0))
//        }
//        if isCustomView == false {
//            self.mSpeakView.removeFromSuperview()
//            self.vc?.view.addSubview(self.mSpeakView)
//            self.mSpeakView.startBtnHandler()
//        }
//        if let b = self.speakStartBlock {
//            b()
//        }
//        if let b = self.speakEndBlock {
//            self.mSpeakView.speakEndBlock = { str in
//                b(str)
//                completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "responseResult": ["content": str], "code": "0", "msg": "成功", "result": ["content": str]]), true)
//            }
////            self.speakView.speakEndBlock = b
//        }
////        self.speakView.speakEndBlock = { str in
////            print("str = \(str)")
////        }
////        self.speakView.speakCancelBlock = {
////
////        }
//        if let b = self.speakCancelBlock {
//            self.mSpeakView.speakCancelBlock = b
//        }
//    }
    
    private func startVoiceMethod() -> Bool{
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        switch authStatus {
        case .notDetermined:
            print("notDetermined")
            requestAuth()
            return false
        case .denied:
            print("denied")
            getAudioAuth()
            return false
        case .restricted:
            print("restricted")
            getAudioAuth()
            return false
        case .authorized:
            print("denied")
            break
        default:
            break
        }
        return true
    }
    
    private func requestAuth() {
        AVCaptureDevice.requestAccess(for: .audio) { flag in
            
        }
    }
    
    private func getAudioAuth(){
        let alert = UIAlertController(title: alertTitle, message: alertMsg, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: cancelAction, style: UIAlertAction.Style.cancel) { action in
            
        }
        let okAction = UIAlertAction(title: okAction, style: UIAlertAction.Style.default) { action in
            DispatchQueue.main.async {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString) ?? URL(fileURLWithPath: ""), options: [:]) { flag in
                    
                }
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        vc?.present(alert, animated: true, completion: {
            
        })
    }
    
//    private lazy var speakView: NHGSpeakView = {
//        let view = NHGSpeakView.init(appId: self.iFlyAppId ?? "")
//       return view
//    }()
    
}
