//
//  HGDefine.swift
//  CLSDK
//
//  Created by  on 2021/10/8.
//
/**
 定义类
 */
import Foundation


/// 定义插件接口名
enum PluginName: String {
    /// 文件操作
    case PluginName_HGFile = "HGFile"
    /// 语音
    case PluginName_HGVoice = "HGVoice"
    /// 条形扫描
    case PluginName_HGScanner = "HGScanner"
    /// 信息
    case PluginName_HGDeviceInfo = "HGDeviceInfo"
    /// 手机盾
    case PluginName_HGSign = "HGSign"
    /// 小程序
    case PluginName_HGApplet = "HGApplet"
    /// 应用页面
    case PluginName_HGPage = "HGPage"
    /// 数据加密
    case PluginName_HGData = "HGData"
    /// 数据请求加密
    case PluginName_HGRequest = "HGRequest"
    /// 文件操作
    case PluginName_HGStorage = "HGStorage"
    /// 照相机
    case PluginName_HGCamera = "HGCamera"
    /// 加解密
    case PluginName_HGEnDecrypt = "HGEnDecrypt"
    /// 环境配置
    case PluginName_HGEnvironment = "HGEnvironment"
    /// 支付
    case PluginName_HGPay = "HGPay"
    /// 收藏
    case PluginName_HGCollection = "HGCollection"
    /// 用户
    case PluginName_HGUser = "HGUser"
    /// 小应用
    case PluginName_HGApp = "HGApp"
    /// 登录
    case PluginName_HGLogin = "HGLogin"
    /// 系统
    case PluginName_HGSystem = "HGSystem"
    case PluginName_HGMeeting = "HGMeeting"
    
}

/// 签名类型
enum DataSignType: Int {
    /// 无类型
    case none = -1
    /// 手机盾
    case shield = 0
}
