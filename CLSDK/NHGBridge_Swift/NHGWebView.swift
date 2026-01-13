//
//  NHGWebView.swift
//  CLSDK
//
//  Created by  on 2021/8/31.
//
/// - Authors: 
// TODO: **请在项目设置中Build Phases - 添加Copy File Script - 选择frameworks - 选择CLSDK.xcframework**

import UIKit
//import Alamofire

/// 封装DSWebView控件 公开插件方法。
/// 详细参数定义对照《公共组件接口文档》，请联系所要。
/// ***
/// **请在项目设置中Build Phases - 添加Copy File Script - 选择frameworks - 选择CLSDK.xcframework**
public class NHGWebView: DWKWebView, WKNavigationDelegate {
   
    ///父控制器
    private var vc: UIViewController?
    
    /// 自定义跳转条件
    private var customNavigationAction: Bool?
    
    /// 自定义跳转条件打开系统浏览器
    private var customArrayForOpenWebBrowser: Array<String>?
    
    /// 自定义跳转条件不处理
    private var customArrayWithoutOpenWebBrowser: Array<String>?
//    /是否自定义语音界面
//    private var isCustomView: Bool?
    ///讯飞语音Appid
//    private var iFlyAppId: String?
    
    // MARK: 网页请求失败Block
    /**
      网页请求失败 didFailProvisionalNavigation 代理
      - Parameters:
        - webView: webView
        - navigation: 导航
        - error: 错误信息
     */
    @objc public var didFailProvisionalBlock: ((_ webView: NHGWebView, _ navigation: WKNavigation, _ error: Error) -> Void)?
    
    // MARK: 开始请求网页Block
    /**
      开始请求网页 didStartProvisionalNavigation 代理
      - Parameters:
        - webView: webView
        - navigation: 导航
     */
    @objc public var didStartBlock: ((_ webView: NHGWebView, _ navigation: WKNavigation) -> Void)?
    
    // MARK: 网页请求成功Block
    ///完成请求网页并成功 didFinish 代理
    ///webView webView
    ///navigation 导航
    ///***
    /// - parameter webView: webView
    /// - parameter navigation: 导航
    /// - important:请求网页成功只是网络畅通情况下
    @objc public var didFinishBlock: ((_ webView: NHGWebView, _ navigation: WKNavigation) -> Void)?
    
    // MARK: 网页提交请求Block
    /**
      请求提交正在跳转 didCommit 代理
      - Parameters:
        - webView: webView
        - navigation: 导航
     */
    @objc public var didCommitBlock: ((_ webView: NHGWebView, _ navigation: WKNavigation) -> Void)?
    
    // MARK: 网页请求失败Block
    /**
      网页请求失败 didFail 代理
      - Parameters:
        - webView: webView
        - navigation: 导航
        - error: 错误信息
     */
    @objc public var didFailBlock: ((_ webView: NHGWebView, _ navigation: WKNavigation, _ error: Error) -> Void)?
    
    // MARK: 网页关闭Block
    /// 远程终止
    @objc public var webDidTerminate: ((_ webView: NHGWebView) -> Void)?
    
    // MARK: 页面协议Block
    /// 页面跳转逻辑Block
    /// @param webView: webView
    /// @param navigationAction: WKNavigationAction
    @objc public var decidePolicyForBlock: ((_ webView: NHGWebView, _ navigationAction: WKNavigationAction) -> Void)?
    
    @objc public var decidePolicyLinkActivateForBlock: ((_ webView: NHGWebView, _ navigationAction: WKNavigationAction) -> Void)?
    
    // MARK: 页面协议Block
    /// 页面跳转逻辑Block
    /// @param webView: webView
    /// @param navigationAction: WKNavigationAction
    /// @return WKNavigationActionPolicy
    @objc public var decidePolicyForAction: ((_ webView: NHGWebView, _ navigationAction: WKNavigationAction) -> WKNavigationActionPolicy)?
    
    // MARK: 页面响应Block
    /// 页面返回
    @objc public var decidePolicyForResponse: ((_ webView: NHGWebView, _ navigationAction: WKNavigationResponse) -> Void)?
    
    // MARK: 页面校验变化Block
    /// webView跨域跳转
    @objc public var webViewAuthChallenge: ((_ webView: NHGWebView, _ challenge: URLAuthenticationChallenge, _ completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?
    
    // MARK: 页面警告框Block
    /// webView alert弹框回调
    @objc public var webViewAlertPanel: ((_ webView: WKWebView, _ message: String, _ frame: WKFrameInfo, _ completionHandler: @escaping () -> Void) -> Void)?
    
    // MARK: 页面确认框Block
    /// webView alert确认弹框回调
    @objc public var webViewConfirmPanel: ((_ webView: WKWebView, _ message: String, _ frame: WKFrameInfo, _ completionHandler: @escaping (Bool) -> Void) -> Void)?
    
    /**
     文件下载 文件预览 文件下载成功
     - Parameters:
      - filePath: 文件下载成功的文件路径
     */
    private var fileDownloadDidSuccess: ((_ filePath: String?) -> ())?
    
    /**
     文件下载 文件预览 文件下载失败
     - Parameters:
      - error: 文件上传失败并返回错误信息
     */
    private var fileDownloadDidFailed: ((_ error: Error?) -> ())?
    
    /**
     文件下载 文件预览 文件下载中 主要更新ui逻辑
     */
    private var fileDownloading: (() -> ())?
    
    /// 开始说话回调
    private var speakStartBlock: (() -> ())?
    /// 取消说话回调
    private var speakCancelBlock: (() -> ())?
    /// 说话正常识别且正常完成回调
    private var speakEndBlock: ((_ str: String?) -> ())?
    /// 讯飞语音回调
    private var speakCallBack: ((Any) -> ())?
    
    /// 当js window.close时触发Block
    private var windowCloseCallBack:(() -> ())?
    
    /// 条形扫码Block
    private var scannerCallBack:(([String: Any]) -> ())?
    
    /// 条形扫码取消Block
    private var scannerCancelCallBack:(() -> ())?
    
    /**
     文件上传 文件上传成功
     - Parameters:
      - filePath: 文件上传成功返回字典
     */
    private var fileUploadDidSuccess: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?
    
    /**
     文件上传 文件上传失败
     - Parameters:
      - error: 文件上传成功并返回错误信息
     */
    private var fileUploadDidFailed: ((_ error: Error?, _ code: NSInteger, _ msg: String?) -> ())?
    
    /**
     文件上传 文件上传中 主要更新ui逻辑
     */
    private var fileUploading: (() -> ())?
    
    
    /// 选择文件回调
    /// @param dic: 返回的数据
    /// @param error: 错误信息
    private var selectFileCallBack: ((_ dic: Dictionary<AnyHashable, Any>?, _ error: Error?) -> ())?
    
    /// 获取设备信息回调
    /// @param 字典
    private var getDeviceInfoCallBack: (([String: Any]) -> ())?
    
    /// 获取位置信息回调
    /// @param 字典
    private var getLocationCallBack: (([String: Any]) -> ())?
    
    /// 拍照回调
    private var takePictureCallBack: (() -> ())?
    
    /// 海拔高度回调
    /// @param 字典
    private var getAltitudeCallBack: (([String: Any]) -> ())?
    
    /// 获取图片回调
    /// @param 字典
    private var getImageCallBack: (([String: Any]) -> ())?
    
    
    /// 准备上传回调 单一
    /// @param 返回casTgc
    private var prepareUploadCallBack: (() -> String)?
    
    /// 准备下载回调 单一
    /// @param 返回jsessionid
    private var prepareDownloadCallBack: (() -> String)?
    
    /// tgc准备下载回调 单一
    /// @param 返回jsessionid
    private var tgcPrepareDownloadCallBack: (() -> String)?
    
    
    /// 设置手机盾加签入参回调
    /// url地址 用户信息字典
    private var setParamShieldForSignCallBack: ((Any) -> ([String: Any]))?
    
    /// webView关闭回调
    private var webViewDidCloseCallBack: (() -> ())?
    
    
    /// 跳转小程序插件
    private var jumpAppletCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 打开页面插件
    private var openPageCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 打开Summer小应用插件
    private var openAppCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 数据加密插件
    private var dataEncryptCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 加密请求插件
    private var encryptRequestCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 与MA服务进行加密网络请求回调block
    private var encryptRequestForMaCallBack: (([String: Any], JSCallback) -> Void)?
    
    /// 文件操作读文件插件
    private var readFileCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 文件操作写文件插件
    private var writeFileCallBack: ((([String: Any]), JSCallback) -> ())?
    
    /// 表单上传请求 回调
    private var formDataUploadCallBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?
    
    /// 表单上传请求 回调字典
    private var getFileContentCallBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?
    
    /// 收藏回调block
    private var deleteCollectionCallBack: (([String: Any], JSCallback) -> Void)?
    
    /// sm4加解密回调block
    private var sm4EnDeCallBack: (([String: Any]) -> ())?
    
    /// 打开系统浏览器回调block
    private var systemWebCallBack: (([String: Any]) -> ())?
    
    /// 打开系统浏览器回调block
    private var getDomainCallBack: (([String: Any]) -> ())?
    
    /// 支付功能回调block
    private var openPaymentAppCallBack: (([String: Any]) -> ())?
    
    /// 用户登录信息block
    private var getUserInfoCallBack: (([String: Any]) -> ())?
    
    /// 小应用信息block
    private var getAppInfoCallBack: (([String: Any]) -> ())?
    
    /// 更新登录时间给小应用
    private var getUpdateLoginTimeCallBack: (([String: Any]) -> ())?
    
    /// 小应用打电话
    private var getDialCallBack: (([String: Any]) -> ())?
    
    private var joinMeetingCallBack: (([String: Any]) -> ())?
    
    /// 通过schemeUrl打开第三方APP
    private var getOpenAppWithSchemeCallBack: (([String: Any]) -> ())?
    
    @objc public var rootURL: String?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: 初始化
    /// 父类初始化
    /// - Parameter coder: coder
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    // MARK: 类初始化
    /// 父类初始化
    /// - Parameters:
    ///   - frame: frame
    ///   - configuration: webView配置
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }
    
    public override func loadUrl(_ url: String) {
        super.loadUrl(url)
        self.rootURL = url;
    }
    
    // MARK: App调用初始化使用
    /// 初始化WebView frame: rect configuration: webView配置 vc: 父控制器 isCustomView: 是否自定义语音识别界面 如自定义界面 手动调用语音识别方法 startRecognitionVoice iFlyAppId: 讯飞语音AppId
    /// - Parameters:
    ///   - frame: frame
    ///   - configuration: webView设置
    ///   - vc: 父控制器
    ///   - isCustomView: 是否自定义语音识别界面 如自定义界面 手动调用语音识别方法 startRecognitionVoice
    ///   - iFlyAppId: 讯飞语音AppId
    
    /// - Parameter frame: frame
    /// - Parameter configuration: 配置
    /// - Parameter vc: 父控制器
//    / - Parameter isCustomView: 是否自定义语音识别界面 如自定义界面 手动调用语音识别方法 startRecognitionVoice
//    / - Parameter iFlyAppId: 讯飞语音AppId
    @objc public init(frame: CGRect, configuration: WKWebViewConfiguration, vc: UIViewController) {
        super.init(frame: frame, configuration: configuration)
        self.vc = vc
//        self.isCustomView = isCustomView
//        self.iFlyAppId = iFlyAppId
        initProtocol()
        registerDSMethod()
    }
        
//    // MARK: 主动调用语音识别
//    /**
//     开始语音识别
//     当自定义语音界面使用
//     */
//    @objc public func startRecognitionVoice(){
//        self.voice.startRecognitionVoice()
//    }
    
    // MARK: js 调用 window.close
    /// 当js调用window.close会触发ds的window close回调，在回调中写原生逻辑
    /// - Parameter callBack: 回调
    @objc public func setWindowCloseCallBack(_ callBack: (() -> ())?){
        self.windowCloseCallBack = callBack
    }

    // MARK: 初始化代理协议
    private func initProtocol(){
        self.navigationDelegate = self
        self.uiDelegate = self
        self.dsuiDelegate = self
    }
    
    // MARK: 注册插件
    private func registerDSMethod(){
        self.addJavascriptObject(self.file, namespace: PluginName.PluginName_HGFile.rawValue)
        self.addJavascriptObject(self.voice, namespace: PluginName.PluginName_HGVoice.rawValue)
        self.addJavascriptObject(self.scanner, namespace: PluginName.PluginName_HGScanner.rawValue)
        self.addJavascriptObject(self.deviceInfo, namespace: PluginName.PluginName_HGDeviceInfo.rawValue)
        self.addJavascriptObject(self.shield, namespace: PluginName.PluginName_HGSign.rawValue)
        self.addJavascriptObject(self.applet, namespace: PluginName.PluginName_HGApplet.rawValue)
        self.addJavascriptObject(self.page, namespace: PluginName.PluginName_HGPage.rawValue)
        self.addJavascriptObject(self.data, namespace: PluginName.PluginName_HGData.rawValue)
        self.addJavascriptObject(self.request, namespace: PluginName.PluginName_HGRequest.rawValue)
        self.addJavascriptObject(self.storage, namespace: PluginName.PluginName_HGStorage.rawValue)
        self.addJavascriptObject(self.camera, namespace: PluginName.PluginName_HGCamera.rawValue)
        self.addJavascriptObject(self.enDecrypt, namespace: PluginName.PluginName_HGEnDecrypt.rawValue)
        self.addJavascriptObject(self.environment, namespace: PluginName.PluginName_HGEnvironment.rawValue)
        self.addJavascriptObject(self.payment, namespace: PluginName.PluginName_HGPay.rawValue)
        self.addJavascriptObject(self.collection, namespace: PluginName.PluginName_HGCollection.rawValue)
        self.addJavascriptObject(self.hgUser, namespace: PluginName.PluginName_HGUser.rawValue)
        self.addJavascriptObject(self.hgApp, namespace: PluginName.PluginName_HGApp.rawValue)
        self.addJavascriptObject(self.hgLogin, namespace: PluginName.PluginName_HGLogin.rawValue)
        self.addJavascriptObject(self.hgSystem, namespace: PluginName.PluginName_HGSystem.rawValue)
        self.addJavascriptObject(self.hgMeeting, namespace: PluginName.PluginName_HGMeeting.rawValue)
    }
    
    // MARK: 小应用插件
    private lazy var hgApp: HGApp = {
        let s = HGApp(self.vc!)
        return s
    }()
    
    // MARK: 登录插件
    private lazy var hgLogin: HGLogin = {
        let s = HGLogin(self.vc!)
        return s
    }()
    
    // MARK: 系统插件
    private lazy var hgSystem: HGSystem = {
        let s = HGSystem(self.vc!)
        return s
    }()
    
    private lazy var hgMeeting: HGMeeting = {
        let s = HGMeeting(self.vc!)
        return s
    }()
    
    // MARK: 用户插件
    private lazy var hgUser: HGUser = {
        let s = HGUser(self.vc!)
        return s
    }()
    
    // MARK: 文件下载成功回调
    /**
      文件下载成功回调 callBack: filePath 文件下载成功后的路径
      - Parameters:
        - callBack: filePath 文件下载成功后的路径
    */
    @objc public func setDownloadSuccessCallBack(_ callBack: ((_ filePath: String?) -> ())?) {
        self.fileDownloadDidSuccess = callBack
        self.file.fileDownloadSuccessCallBack = self.fileDownloadDidSuccess
    }
    
    // MARK: 文件下载失败回调
    /**
     文件下载失败回调
     - Parameters:
       - callBack: error 失败原因
     */
    @objc public func setDownloadFailedCallBack(_ callBack: ((_ error: Error?) -> ())?) {
        self.fileDownloadDidFailed = callBack
        self.file.fileDownloadFailedCallBack = self.fileDownloadDidFailed
    }
    
    // MARK: 文件下载中回调
    /**
     文件下载中回调
     - Parameters:
       - callBack: 回调无参数
     */
    @objc public func setDownloadingCallBack(_ callBack: (() -> ())?) {
        self.fileDownloading = callBack
        self.file.fileDownloadingCallBack = self.fileDownloading
    }
    
    // MARK: 讯飞语音回调
    /// 讯飞语音回调
    /// - Parameter callBack: 回调 Any H5给原生的参数
    @objc public func setSpeechCallBack(_ callBack: ((Any) -> ())?) {
        self.speakCallBack = callBack;
        self.voice.speechRecognitionCallBack = self.speakCallBack;
    }
    
    // MARK: 讯飞语音原生给H5回调
    /// 讯飞语音原生给H5回调
    /// - Parameter dic: 给H5的参数
    @objc public func setSpeechResultToH5(_ dic: NSDictionary) {
        self.voice.setSpeechResultToH5(dic)
    }
    
    // MARK: 加密请求给H5回调
    /// 加密请求给H5回调
    /// - Parameter dic: 给H5的参数
    ///   code    服务请求状态，由服务定义，默认0为请求成功 0 成功 1 失败 101 网络差
    ///   msg    服务请求结果描述信息
    ///   result    服务器返回结果（JSON）
    @objc public func setEncryptRequestResultToH5(_ dic: NSDictionary) {
        self.request.setResultToH5(dic)
    }
    
    // MARK: 加密请求给H5回调
    /// 加密请求给H5回调
    /// - Parameter str: 给H5的参数
    ///   code    服务请求状态，由服务定义，默认0为请求成功 0 成功 1 失败 101 网络差
    ///   msg    服务请求结果描述信息
    ///   result    服务器返回结果（JSON）
    @objc public func setEncryptRequestResultsToH5(_ str: String) {
        self.request.setResultToH5(str)
    }
    
    // MARK: 获取登录用户的信息
    @objc public func setGetUserInfoCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getUserInfoCallBack = callBack
        self.hgUser.getUserInfoCallBack = self.getUserInfoCallBack
    }
    
    // MARK：获取登录用户信息给H5
    @objc public func setGetUserInfoResultsToH5(_ dic: NSDictionary) {
        self.hgUser.setGetUserInfoResultToH5(dic)
    }
    
    // MARK: 获取小应用信息
    @objc public func setGetAppInfoCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getAppInfoCallBack = callBack
        self.hgApp.getAppInfoCallBack = self.getAppInfoCallBack
    }
    
    // MARK：获取小应用信息给H5
    @objc public func setGetAppInfoResultsToH5(_ dic: NSDictionary) {
        self.hgApp.setGetAppInfoResultToH5(dic)
    }
    
    // MARK: 更新登录时间给小应用
    @objc public func setUpdateLoginTimeCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getUpdateLoginTimeCallBack = callBack
        self.hgLogin.getUpdateLoginTimeCallBack = self.getUpdateLoginTimeCallBack
    }
    
    // MARK：更新登录时间给小应用给H5
    @objc public func setUpdateLoginTimeResultsToH5(_ dic: NSDictionary) {
        self.hgLogin.setUpdateLoginTimeResultToH5(dic)
    }
    
    // MARK: 小应用打电话
    @objc public func setDialCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getDialCallBack = callBack
        self.hgSystem.getDialCallBack = self.getDialCallBack
    }
    
    // MARK：小应用打电话给H5
    @objc public func setDialResultsToH5(_ dic: NSDictionary) {
        self.hgSystem.setDialResultToH5(dic)
    }
    
    // MARK: 通过schemeUrl打开第三方APP
    @objc public func setOpenAppWithSchemeCallback(_ callBack: (([String: Any]) -> ())?) {
        self.getOpenAppWithSchemeCallBack = callBack
        self.hgSystem.getOpenAppWithSchemeCallBack = self.getOpenAppWithSchemeCallBack
    }
    
    // MARK：通过schemeUrl打开第三方APP给H5
    @objc public func setOpenAppWithSchemeResultsToH5(_ dic: NSDictionary) {
        self.hgSystem.setOpenAppWithSchemeResultToH5(dic)
    }
    
    // MARK: 开始说话回调
    /**
     开始说话回调
     - Parameters:
       - callBack: 回调无参数
     */
    @objc public func setSpeakStartCallBack(_ callBack: (() -> ())?) {
        self.speakStartBlock = callBack
        self.voice.speakStartBlock = self.speakStartBlock
    }

    // MARK: 取消说话回调
    /**
     取消说话回调
     - Parameters:
       - callBack: 回调无参数
     */
    @objc public func setSpeakCancelCallBack(_ callBack: (() -> ())?) {
        self.speakCancelBlock = callBack
        self.voice.speakCancelBlock = self.speakCancelBlock
    }

    // MARK: 正常说话且正常识别完成回调
    /**
     正常说话且正常识别完成回调 callBack: str 说话完识别后的字符串
     - Parameters:
       - callBack: str 说话完识别后的字符串
     */
    @objc public func setSpeakEndCallBack(_ callBack: ((_ str: String?) -> ())?) {
        self.speakEndBlock = callBack
        self.voice.speakEndBlock = self.speakEndBlock
    }
    
    // MARK: 设置SDK内识别语音的文字字体
    /// 设置说话视图字体
    /// - Parameter font: 字体
    @objc public func setSpeakViewTextFont(_ font: UIFont) {
        self.voice.setSpeakViewTextFont(font)
    }
    
    // MARK: 扫码接口
    /// 扫码接口
    /// - Parameter callBack: 回调 扫回的内容发给H5
    @objc public func setScannerCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.scannerCallBack = callBack
        self.scanner.scannerCallBack = self.scannerCallBack
    }
    
    // MARK: 扫码取消接口
    /// 扫码取消接口
    /// - Parameter callBack: 回调 无参数
    @objc public func setScannerCancelCallBack(_ callBack: (() -> ())?) {
        self.scannerCancelCallBack = callBack
        self.scanner.scannerCancelCallBack = self.scannerCancelCallBack
    }
    
    // MARK: 文件上传中回调
    /// 文件上传中回调
    /// - Parameter callBack: 回调无参数
    @objc public func setFileUploadingCallBack(_ callBack: (() -> ())?) {
        self.fileUploading = callBack
        self.file.fileUploadingCallBack = self.fileUploading
    }
    
    // MARK: 文件上传成功回调
    /// 文件上传成功回调
    /// - Parameter callBack: 回调字典
    /// 上传成功服务器返回的参数
    @objc public func setFileUploadSuccessCallBack(_ callBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?) {
        self.fileUploadDidSuccess = callBack
        self.file.fileUploadSuccessCallBack = self.fileUploadDidSuccess
    }
    
    // MARK: 文件上传失败回调
    /// 文件上传失败回调
    /// - Parameter callBack: 回调错误信息
    /// error:错误信息 code:错误编号 msg:错误文本
    @objc public func setFileUploadFailedCallBack(_ callBack: ((_ error: Error?, _ code: NSInteger, _ msg: String?) -> ())?) {
        self.fileUploadDidFailed = callBack
        self.file.fileUploadFailedCallBack = self.fileUploadDidFailed
    }
    
    // MARK: 选择文件回调
    /// 选择文件回调
    /// - Parameter callBack: 回调数据和错误信息
    /// dic: 服务器返回的参数 error: 错误信息
    @objc public func setSelectFileCallBack(_ callBack: ((_ dic: Dictionary<AnyHashable, Any>? , _ error: Error?) -> ())?) {
        self.selectFileCallBack = callBack
        self.file.selectFileCallBack = self.selectFileCallBack
    }
    
    // MARK: 获取设备信息回调
    /// 获取设备信息回调
    /// - Parameter callBack: 回调
    /// 返回给H5参数 暂时无参数
    @objc public func setDeviceInfoCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getDeviceInfoCallBack = callBack
        self.deviceInfo.getDeviceInfoCallBack = self.getDeviceInfoCallBack
        
    }
    
    // MARK: 获取位置信息回调
    /// 获取位置信息回调
    /// - Parameter callBack: 回调
    /// 返回给H5参数 暂时无参数
    @objc public func setLocationCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getLocationCallBack = callBack
        self.deviceInfo.getLocationCallBack = self.getLocationCallBack
    }
    
    // MARK: 获取位置信息回调
    /// 获取位置信息回调
    /// - Parameter callBack: 回调
    /// 返回给H5参数 暂时无参数
    @objc public func setAltitudeCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getAltitudeCallBack = callBack
        self.deviceInfo.getAltitudeCallBack = self.getAltitudeCallBack
    }
    
    // MARK: 拍照结果回调
    /// 拍照结果回调
    /// - Parameter callBack: 回调
    @objc public func setTakePictureCallBack(_ callBack: (() -> ())?) {
        self.takePictureCallBack = callBack
        self.camera.takePictureCallBack = self.takePictureCallBack
    }
    
    // MARK: 获得图片结果回调
    /// 拍照结果回调
    /// - Parameter callBack: 回调
    @objc public func setImageCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getImageCallBack = callBack
        self.camera.getImageCallBack = self.getImageCallBack
    }
    
    // MARK: 准备上传回调 单一
    /// 准备下载回调 单一
    /// - Parameter callBack: 返回给H5 casTgc
    @objc public func setPrepareUploadCallBack(_ callBack: (() -> String)?) {
        self.prepareUploadCallBack = callBack
        self.file.filePrepareUploadCallBack = self.prepareUploadCallBack
    }
    
    // MARK: 准备下载回调 单一
    /// 准备下载回调 单一
    /// - Parameter callBack: 返回给H5 jsessionid
    @objc public func setPrepareDownloadCallBack(_ callBack: (() -> String)?) {
        self.prepareDownloadCallBack = callBack
        self.file.filePrepareDownloadCallBack = self.prepareDownloadCallBack
    }
    
    // MARK: tgc准备下载回调 单一
    /// tgc准备下载回调 单一
    /// - Parameter callBack: 返回给H5 jsessionid
    @objc public func setTgcPrepareDownloadCallBack(_ callBack: (() -> String)?) {
        self.tgcPrepareDownloadCallBack = callBack
        self.file.tgcFilePrepareDownloadCallBack = self.tgcPrepareDownloadCallBack
    }
    
    // MARK: 设置手机盾加签入参
    /// 设置手机盾加签入参
    /// - Parameter callBack: 返回手机盾入参
    /// String: 返回给原生所需参数 [String: Any] 返回给H5 字典加密内容
    @objc public func setShieldParamForSignCallBack(_ callBack: ((Any) -> ([String: Any]))?) {
        self.setParamShieldForSignCallBack = callBack
        self.shield.setShieldParamForSignCallBack = self.setParamShieldForSignCallBack
//        if let block = self.setParamShieldForSignCallBack {
//            let dic = block()
//            let url = dic["url"]
//            let param = dic["param"]
//            print("webView url = \(String(describing: url)) param = \(String(describing: param))")
//        }
    }
    
    // MARK: 关闭小应用
    /// - Parameter callBack: 回调无参数
    @objc public func setWebViewDidCloseCallBack(_ callBack: (() -> ())?) {
        self.webViewDidCloseCallBack = callBack
    }
    
    // MARK: 跳转小程序
    /// - Parameter callBack: 参数如下
    /// 参数[String: Any] 是 H5传给原生的参数 {"originalId":"11sfsf112""path":"xxxxx"}
    /// 参数JSCallback 是 返回给H5的参数 1.String=字典转字符串 字典包含{"code":0,"msg":"成功",} 2.BOOL=true
    @objc public func setJumpAppletCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.jumpAppletCallBack = callBack
        self.applet.jumpAppletCallBack = self.jumpAppletCallBack
    }
    
    // MARK: 应用内跳转
    /// - Parameter callBack: 参数如下
    /// 参数[String: Any] 是 H5传给原生的参数 {"pageId":"xxxx""appId":"xxxxx""msg":"xxx"}
    /// 参数JSCallback 是 返回给H5的参数 1.String=字典转字符串 字典包含{"code":0,"msg":"成功",} 2.BOOL=true
    @objc public func setOpenPageCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.openPageCallBack = callBack
        self.page.openPageCallBack = self.openPageCallBack
    }
    
    // MARK: 打开Summer小应用
    /// - Parameter callBack: 参数如下
    /// 参数[String: Any] 是 H5传给原生的参数 {"appId":"xxxxx"}
    /// 参数JSCallback 是 返回给H5的参数 1.String=字典转字符串 字典包含{"code":0,"msg":"成功",} 2.BOOL=true
    @objc public func setOpenAppCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.openAppCallBack = callBack
        self.page.openAppCallBack = self.openAppCallBack
    }
    
    // MARK: 数据加密
    /// 数据加密
    /// - Parameter callBack: 参数
    /// 数据加密
    @objc public func setDataEncryptCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.dataEncryptCallBack = callBack
        self.data.dataEncryptCallBack = self.dataEncryptCallBack
    }
    
    // MARK: 请求加密
    /// 请求加密
    /// - Parameter callBack: 参数
    /// data    请求体参数，json格式
    /// header    请求头参数:key为header请求头的key，value为请求头的value（JSON）
    /// url    接口请求地址
    @objc public func setEncryptRequestCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.encryptRequestCallBack = callBack
        self.request.encryptRequestCallBack = self.encryptRequestCallBack
    }
    
    // MARK: 与MA服务进行加密网络请求
    /// 与MA服务进行加密网络请求
    /// - Parameter callBack: 参数
    /// data    请求体参数，json格式
    /// header    请求头参数:key为header请求头的key，value为请求头的value（JSON）
    /// url    接口请求地址
    @objc public func setEncryptRequestForMaCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.encryptRequestForMaCallBack = callBack
        self.request.encryptRequestForMaCallBack = self.encryptRequestForMaCallBack
    }
    
    // MARK: 文件操作读文件
    /// 文件操作读文件
    /// - Parameter callBack: 参数
    /// filePath 文件相对路径
    /// content 文件内容字符串
    @objc public func setReadFileCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.readFileCallBack = callBack
        self.storage.readFileCallBack = self.readFileCallBack
    }
    
    // MARK: 文件操作写文件
    /// 文件操作写文件
    /// - Parameter callBack: 参数
    /// filePath 文件相对路径
    /// content 文件内容字符串
    @objc public func setWriteFileCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.writeFileCallBack = callBack
        self.storage.writeFileCallBack = self.writeFileCallBack
    }
    
    // MARK: 文件操作写文件回调给H5
    @objc public func setWriteFileResultToH5(_ dic: NSDictionary) {
        self.storage.setWriteFileResultToH5(dic)
    }
    
    // MARK: 文件操作读文件回调给H5
    @objc public func setReadFileResultToH5(_ dic: NSDictionary) {
        self.storage.setReadFileResultToH5(dic)
    }
    
    @objc public func setDeviceInfoResultToH5(_ dic: NSDictionary) {
        self.deviceInfo.setGetDeviceInfoResultToH5(dic)
    }
    
    // MARK: 表单文件上传回调
    /// 表单文件上传回调
    /// - Parameter callBack: 回调参数
    /// uploadUrl 上传url地址
    /// filePath 本地文件路径
    /// postParams post参数
    @objc public func setFormDataUploadCallBack(_ callBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?) {
        self.formDataUploadCallBack = callBack
        self.file.formDataUploadCallBack = self.formDataUploadCallBack
    }
    
    // MARK: 获取文件内容回调
    /// 获取文件内容回调
    /// - Parameter callBack: 回调参数
    /// fileType 文件类型，多个文件类型限制使用英文;分隔
    /// fileSize 单个文件大小
    /// fileCount 选取文件数量
    /// hasContent 是否返回文件内容，1返回，0不返回
    @objc public func setFileContentCallBack(_ callBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?) {
        self.getFileContentCallBack = callBack
        self.file.getFileContentCallBack = self.getFileContentCallBack
    }
    
    // MARK: 收藏
    /// 收藏
    /// - Parameter callBack: 参数
    /// 删除收藏
    @objc public func setDeleteCollectionCallBack(_ callBack: ((([String: Any]), JSCallback) -> ())?) {
        self.deleteCollectionCallBack = callBack
        self.collection.deleteCollectionCallBack = self.deleteCollectionCallBack
    }
    
    // MARK: 加解密
    /// 加解密
    /// - Parameter callBack: 参数
    /// sm4加解密
    @objc public func setSM4EnDeCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.sm4EnDeCallBack = callBack
        self.enDecrypt.sm4EnDeCallBack = self.sm4EnDeCallBack
    }
    
    // MARK: 打开系统浏览器
    /// 打开系统浏览器
    /// - Parameter callBack: 参数
    /// url url
    @objc public func setOpenSystemWebCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.systemWebCallBack = callBack
        self.page.openSystemWebCallBack = self.systemWebCallBack
    }
    
    // MARK: 设置环境变量
    /// 设置环境变量
    /// - Parameter callBack: 参数
    /// url url
    @objc public func setDomainCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.getDomainCallBack = callBack
        self.environment.getDomainCallBack = self.getDomainCallBack
    }
    
    // MARK: 支付功能
    /// 支付功能
    /// - Parameter callBack: 参数
    /// url url
    @objc public func setOpenPaymentAppCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.openPaymentAppCallBack = callBack
        self.payment.openPaymentAppCallBack = self.openPaymentAppCallBack
    }
    
    @objc public func setJoinMeetingCallBack(_ callBack: (([String: Any]) -> ())?) {
        self.joinMeetingCallBack = callBack
        self.hgMeeting.joinMeetingCallBack = self.joinMeetingCallBack
    }
    
    /// 表单文件上传传回给H5
    /// - Parameter dic: 参数
    /// code 0
    /// msg 成功
    /// response 上传成功返回的response
    @objc public func setFormDataUploadResultToH5(_ dic: NSDictionary) {
        self.file.setFormDataUploadResultToH5(dic)
    }
    
    @objc public func setFileContentResultToH5(_ dic: NSDictionary) {
        self.file.setFileContentResultToH5(dic)
    }
    
    @objc public func setOpenPaymentAppResultToH5(_ dic: NSDictionary) {
        self.payment.setOpenPaymentAppResultToH5(dic)
    }
    
    @objc public func setJoinMeetingResultToH5(_ dic: NSDictionary) {
        self.hgMeeting.setJoinMeetingResultToH5(dic)
    }
    
    @objc public func setScannerResultToH5(_ dic: NSDictionary) {
        self.scanner.setScannerResultToH5(dic);
    }
    
    /// 拍照传回给H5
    /// - Parameter dic: 参数
    /// code 0
    /// msg 成功
    /// img base64string
    @objc public func setTakePictureResultToH5(_ dic: NSDictionary) {
        self.camera.setTakePictureResultToH5(dic)
    }
    
    /// 自定义跳转逻辑
    /// - Parameter navigationAction: 是否自定义
    /// 自定义逻辑 ， 不自定义sdk内部执行逻辑
    @objc public func setCustomNavigationAction(_ navigationAction: Bool) {
        self.customNavigationAction = navigationAction;
    }
    
    /// 自定义跳转打开浏览器
    /// - Parameter array: 字符串数组
    @objc public func setCustomArrayNaviActionForOpenWeb(_ array: Array<String>) {
        self.customArrayForOpenWebBrowser = array;
    }
    
    /// 自定义跳转不处理
    /// - Parameter array: 字符串数组
    @objc public func setCustomArrayNaviActionWithoutOpenWeb(_ array: Array<String>) {
        self.customArrayWithoutOpenWebBrowser = array;
    }
    
    // MARK: 文件插件
    private lazy var file: HGFile = {
        let f = HGFile(self.vc!)
        return f
    }()
    
    // MARK: 语音插件
    private lazy var voice: HGVoice = {
        let voice = HGVoice(self.vc!)
        return voice
    }()
    
    // MARK: 扫描插件
    private lazy var scanner: HGScanner = {
        let s = HGScanner(self.vc!)
        return s
    }()
    
    // MARK: 信息插件
    private lazy var deviceInfo: HGDeviceInfo = {
        let s = HGDeviceInfo(self.vc!)
        return s
    }()
    
    // MARK: 小程序插件
    private lazy var applet: HGApplet = {
        let s = HGApplet(self.vc!)
        return s
    }()
    
    // MARK: 手机盾
    internal lazy var shield: HGSign = {
        let s = HGSign(self.vc!)
        return s
    }()
    
    // MARK: 应用页面
    private lazy var page: HGPage = {
        let s = HGPage(self.vc!)
        return s
    }()
    
    // MARK: 数据加密
    private lazy var data: HGData = {
        let s = HGData(self.vc!)
        return s
    }()
    
    // MARK: 数据请求加密
    private lazy var request: HGRequest = {
        let s = HGRequest(self.vc!)
        return s
    }()
    
    // MARK: 文件操作
    private lazy var storage: HGStorage = {
        let s = HGStorage(self.vc!)
        return s
    }()
    
    // MARK: 照相机
    private lazy var camera: HGCamera = {
        let s = HGCamera(self.vc!)
        return s
    }()
    
    // MARK: 收藏插件
    private lazy var collection: HGCollection = {
        let s = HGCollection(self.vc!)
        return s
    }()
    
    // MARK: 加密解密
    private lazy var enDecrypt: HGEnDecrypt = {
        let s = HGEnDecrypt(self.vc!)
        return s
    }()
    
    // MARK: 环境设置
    private lazy var environment: HGEnvironment = {
        let s = HGEnvironment(self.vc!)
        return s
    }()
    
    // MARK: 支付
    private lazy var payment: HGPay = {
        let s = HGPay(self.vc!)
        return s
    }()
    
    // MARK: 将手机盾加签后的结果传给H5
    /// - Parameter dic: 返回结果字典
    @objc public func setDataSignResultToH5(_ dic: NSDictionary) {
        self.shield.setResultToH5(dic)
    }
    
    // MARK: 微信小程序跳回结果传给H5
    /// - Parameter dic: 小程序传回的字典
    @objc public func setWeChatResultToH5(_ dic: NSDictionary) {
        self.applet.setWeChatResultToH5(dic);
    }
    
    // MARK: 打开页面传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setOpenPageResultToH5(_ dic: NSDictionary) {
        self.page.setPageResultToH5(dic)
    }
    
    // MARK: 打开Summer小应用传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setOpenAppResultToH5(_ dic: NSDictionary) {
        self.page.setOpenAppResultToH5(dic)
    }
    
    // MARK: 数据加密传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setDataEncryptResultToH5(_ dic: NSDictionary) {
        self.data.setResultToH5(dic)
    }
    
    // MARK: 数据加密传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setDataEncryptMaResultToH5(_ dic: NSDictionary) {
        self.request.setMaResultToH5(dic)
    }
    
    // MARK: 定位传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setLocationResultToH5(_ dic: NSDictionary) {
        self.deviceInfo.setGetLocationResultToH5(dic)
    }
    
    // MARK: 海拔高度传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setAltitudeResultToH5(_ dic: NSDictionary) {
        self.deviceInfo.setGetAltitudeResultToH5(dic)
    }
    
    // MARK: 获取图片传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setImageResultToH5(_ dic: NSDictionary) {
        self.camera.setImageResultToH5(dic)
    }
    
    // MARK: 收藏状态传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setCollectionResultToH5(_ dic: NSDictionary) {
        self.collection.setCollectionResultToH5(dic)
    }
    
    // MARK: 加解密传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setSm4EnDeResultToH5(_ dic: NSDictionary) {
        self.enDecrypt.setSM4EnDeResultToH5(dic)
    }
    
    // MARK: 打开系统浏览器传给H5
    /// - Parameter dic: 返回的字典
    @objc public func setSystemWebResultToH5(_ dic: NSDictionary) {
        self.page.setSystemWebResultToH5(dic)
    }
    
    // MARK: 环境变量
    /// - Parameter dic: 返回的字典
    @objc public func setDomainResultToH5(_ dic: NSDictionary) {
        self.environment.setDomainResultToH5(dic)
    }
    
    // MARK: webView关闭
    /// 系统父类方法 请使用setWebViewDidCloseCallBack回调实现
    public override func webViewDidClose(_ webView: WKWebView) {
        guard let block = self.webViewDidCloseCallBack else {
            return;
        }
        block()
    }
    
    // MARK: webView线程关闭
    /// 系统父类方法 请使用webDidTerminate回调实现
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("webview webViewWebContentProcessDidTerminate")
        webView.reload()
        guard let block = self.webDidTerminate else {
            return;
        }
        block(webView as! NHGWebView);
    }
    
    // MARK: WebView系统代理
    /// 系统父类方法 请使用didStartBlock回调实现
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("webview didStartProvisionalNavigation")
        guard let block = self.didStartBlock else {
            return;
        }
        block(webView as! NHGWebView, navigation)
    }
    
    /// 系统父类方法 请使用didFailProvisionalBlock回调实现
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("webview didFailProvisionalNavigation")
        guard let block = self.didFailProvisionalBlock else {
            return;
        }
        block(webView as! NHGWebView, navigation, error)
    }
    
    /// 系统父类方法 请使用didFinishBlock回调实现
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("webView didFinish")
        guard let block = self.didFinishBlock else {
            return;
        }
        block(webView as! NHGWebView, navigation)
    }
    
    /// 系统父类方法 请使用didFailBlock回调实现
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("webview didfail")
        guard let block = self.didFailBlock else {
            return;
        }
        block(webView as! NHGWebView, navigation, error)
    }
    
    /// 系统父类方法 请使用didCommitBlock回调实现
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webview didCommit")
        guard let block = self.didCommitBlock else {
            return;
        }
        block(webView as! NHGWebView, navigation)
    }
    
    /// 系统父类方法 请使用webViewAuthChallenge回调实现
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let cha = webViewAuthChallenge {
            cha(webView as! NHGWebView, challenge, completionHandler)
        }
        print("webview didReceive URLAuthenticationChallenge")
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if challenge.previousFailureCount == 0 {
                let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
                print("URLAuthenticationChallenge useCredential")
            }else{
                completionHandler(.cancelAuthenticationChallenge, nil)
                print("URLAuthenticationChallenge cancelAuthenticationChallenge")
            }
        }else{
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("URLAuthenticationChallenge cancelAuthenticationChallenge")
        }
    }
    
    /// 系统父类方法 请使用decidePolicyForAction回调实现
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webview decidePolicyFor navigationAction")
        if (navigationAction.request.url?.absoluteString.contains(".pdf") == true || navigationAction.request.url?.absoluteString.contains(".doc") == true || navigationAction.request.url?.absoluteString.contains(".docx") == true || navigationAction.request.url?.absoluteString.contains(".xls") == true || navigationAction.request.url?.absoluteString.contains(".xlsx") == true ||
            navigationAction.request.url?.absoluteString.contains("customsapplink") == true) {
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
//        else if (navigationAction.request.url?.absoluteString.contains("cas/login") == true) {
//            decisionHandler(.cancel)
//            return
//        }
        if let array = customArrayForOpenWebBrowser {
            if array.count > 0 {
                array.forEach({ str in
                    if navigationAction.request.url?.absoluteString.contains(str) == true {
                        UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
                        decisionHandler(.cancel)
                        return
                    }
                })
            }
        }
        if let array = customArrayWithoutOpenWebBrowser {
            if array.count > 0 {
                array.forEach({ str in
                    if navigationAction.request.url?.absoluteString.contains(str) == true {
                        decisionHandler(.cancel)
                        return
                    }
                })
            }
        }
        if let block = self.decidePolicyForAction {
            let flag = block(webView as! NHGWebView, navigationAction)
            if self.customNavigationAction == true {
                decisionHandler(flag)
                return
            }
        }
        decisionHandler(.allow)
    }
    
    /// 系统父类方法 请使用decidePolicyForResponse回调实现
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("webview decidePolicyFor navigationResponse")
        if let block = self.decidePolicyForResponse {
            block(webView as! NHGWebView, navigationResponse)
        }
        decisionHandler(.allow)
    }
    
    /// 系统父类方法
    public override func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        print("webView shouldPreviewElement")
        return false
    }
    
    /// 系统父类方法
    @available(iOS 13.0, *)
    public override func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping (UIContextMenuConfiguration?) -> Void) {
//        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: {[unowned self] () -> UIViewController? in
//            return self.vc
//                }) { (_) -> UIMenu? in
//                    UIMenu(title: "", image: nil, identifier: UIMenu.Identifier(rawValue: "action"), options: .destructive, children: [])
//                }
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil)
        completionHandler(config)
    }
    
    /// 系统父类方法 请使用webViewAlertPanel回调实现
    public override func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print("runJavaScriptAlertPanelWithMessage")
        if let block = webViewAlertPanel {
            block(webView, message, frame, completionHandler)
            return
        }
        completionHandler()
        return
    }
    
    /// 系统父类方法 请使用webViewConfirmPanel回调实现
    public override func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage")
        if let block = webViewConfirmPanel {
            block(webView, message, frame, completionHandler)
            return
        }
        completionHandler(false)
        return
    }
    
    /// 系统父类方法
    public override func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //该方法是说不需要新建,我只需要在我自己的上加载界面
        let frameInfo = navigationAction.targetFrame;
        if frameInfo?.isMainFrame ?? true {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    /// 系统父类方法 请使用decidePolicyForBlock回调实现
    @available(iOS 13.0, *)
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print("decidePolicyFor navigationAction preferences")
        if let block = self.decidePolicyForBlock {
            block(webView as! NHGWebView, navigationAction)
        }
        if (navigationAction.navigationType == .linkActivated) {
            print("linkActivated url = \(navigationAction.request.url?.absoluteString)")
            if let urlRoot = self.rootURL {
                let nsURL = NSURL(string: urlRoot)
                print("nsURL.host = \(nsURL?.host) , webView.url?.host = \(webView.url?.host), webView.url.absoluteString = \(webView.url?.absoluteString), navigationaction host = \(navigationAction.request.url?.host)")
                if let webViewHost = navigationAction.request.url?.host {
                    if ((nsURL?.host?.contains(webViewHost)) == true || ((webView.url?.absoluteString)!.contains("cas/login"))) {
                        decisionHandler(.allow, webView.configuration.defaultWebpagePreferences)
                        return
                    }
                }
            }
                //跳转别的应用如系统浏览器
                // 对于跨域，需要手动跳转
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
               
                // 不允许web内跳转
            decisionHandler(.cancel, webView.configuration.defaultWebpagePreferences)
                
        }else{
            decisionHandler(.allow, webView.configuration.defaultWebpagePreferences)
        }
        //不添加会崩溃
        return
    }
    
    /// 系统父类方法
    public func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
//        let trust = URLCredential(trust: challenge.protectionSpace.serverTrust)
        print("webview authenticationChallenge")
        decisionHandler(true)
    }
    
    
}
