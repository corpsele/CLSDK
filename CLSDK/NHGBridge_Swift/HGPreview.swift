//
//  HGDownloadFile.swift
//  HGMSDK
//
//  Created by eport2 on 2021/8/31.
//

import UIKit

class HGPreview: NSObject {
    ///父控制器
    private var vc: UIViewController?
    
    /// 文件下载中回调
    @objc public var fileDownloadingCallBack: (() -> ())?
    /// 文件下载成功回调
    @objc public var fileDownloadSuccessCallBack: ((_ filePath: String?) -> ())?
    /// 文件下载失败回调
    @objc public var fileDownloadFailedCallBack: ((_ error: Error?) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /// MARK: 预览文件
    @objc func showFile(_ params: String) -> String {
        let dic = getDictionaryFromJSONString(jsonString: params)
        let name = dic["name"]
        let url = dic["url"]
        let type = dic["type"]
        return getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": ""])
    }
    
    /// MARK: 预览文件
    @objc func showFile(_ params: String, completionHandler: JSCallback) {
        let dic = getDictionaryFromJSONString(jsonString: params)
        let name = dic["name"] as? String
        let url = dic["url"] as? String
        let type = dic["type"] as? String
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.fileDownloadingCallBack = self.fileDownloadingCallBack
        downloadPlugin.setDownloadSuccessCallBack(self.fileDownloadSuccessCallBack)
        downloadPlugin.setDownloadFailedCallBack(self.fileDownloadFailedCallBack)
        downloadPlugin.downloadFile(url, withFileName: name, withFileType: type);
        completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": ""]), true);
    }
    
    /// MARK: 预览文件 修改接口名 V2
    @objc func previewFile(_ params: String, completionHandler: JSCallback) {
        let dic = getDictionaryFromJSONString(jsonString: params)
        let name = dic["name"] as? String
        let url = dic["url"] as? String
        let type = dic["type"] as? String
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.fileDownloadingCallBack = self.fileDownloadingCallBack
        downloadPlugin.setDownloadSuccessCallBack(self.fileDownloadSuccessCallBack)
        downloadPlugin.setDownloadFailedCallBack(self.fileDownloadFailedCallBack)
//        downloadPlugin.downloadFile(url, withFileName: name, withFileType: type)
        downloadPlugin.downloadFile(withExist: url, withFileName: name, withFileType: type)
        completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": ""]), true);
    }

}
