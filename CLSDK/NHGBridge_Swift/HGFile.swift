//
//  HGFile.swift
//  CLSDK
//
//  Created by  on 2021/10/18.
//

import Foundation

class HGFile: NSObject
{
    
    /// 父控制器
    private var vc: UIViewController?
    
    /// 文件下载中回调
    @objc public var fileDownloadingCallBack: (() -> ())?
    /// 文件下载成功回调 回调路径
    @objc public var fileDownloadSuccessCallBack: ((_ filePath: String?) -> ())?
    /// 文件下载失败回调 回调错误信息
    @objc public var fileDownloadFailedCallBack: ((_ error: Error?) -> ())?
    
    /// 文件上传中回调
    @objc public var fileUploadingCallBack: (() -> ())?
    /// 文件上传成功回调 回调字典
    @objc public var fileUploadSuccessCallBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?
    /// 文件上传失败回调 回调错误信息
    @objc public var fileUploadFailedCallBack: ((_ error: Error?, _ code: NSInteger, _ msg: String?) -> ())?
    
    /// 准备文件上传 单一
    @objc public var filePrepareUploadCallBack: (() -> String)?
    
    /// 准备文件下载 单一
    @objc public var filePrepareDownloadCallBack: (() -> String)?
    
    /// tgc准备文件下载 单一
    @objc public var tgcFilePrepareDownloadCallBack: (() -> String)?
    
    /// 选择文件回调 回调数据和错误信息
    @objc public var selectFileCallBack: ((_ dic: Dictionary<AnyHashable, Any>?, _ error: Error?) -> ())?
    
    /// 表单上传请求 回调字典
    @objc public var formDataUploadCallBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?
    
    /// 获取文件内容 回调字典
    @objc public var getFileContentCallBack: ((_ dic: Dictionary<AnyHashable, Any>?) -> ())?
    
    
    /// 表单上传请求 传给H5
    private var formDataUploadCompletionHandler: JSCallback?
    
    /// 获取文件内容传给H5
    private var fileContentCompletionHandler: JSCallback?
    
    /// 选择的文件路径
    private var selectFilePath: String?
    
    /// 选择的键值
    private var selectResult: [AnyHashable : Any]?
    
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    /// MARK: 预览文件 修改接口名 V2
    
    /// 预览文件 文件存在不重复下载
    /// {
    /// "url":"http://ip:port/OA/Name.jpg", 文件下载地址
    /// "type":"jpg",  文件类型
    /// "name":"test"  文件名称
    /// }
    /// {
    /// "responseCode":0, 状态码
    /// "responseMsg":"成功", 状态信息文本
    /// }
    /// - Parameters:
    ///   - params: 接受的H5参数名
    ///   - completionHandler: 原生完成回调给H5
    @objc func previewFile(_ params: String, completionHandler: @escaping JSCallback) {
        print("HGFile previewFile")
        let dic = getDictionaryFromJSONString(jsonString: params)
        let name = dic["name"] as? String
        let url = dic["url"] as? String
        let type = dic["type"] as? String
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.fileDownloadingCallBack = self.fileDownloadingCallBack
        downloadPlugin.setDownloadSuccessCallBack(self.fileDownloadSuccessCallBack)
        downloadPlugin.setDownloadFailedCallBack(self.fileDownloadFailedCallBack)
        downloadPlugin.downloadFile(withExist: url, withFileName: name, withFileType: type) { (result, error) in
            completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功"]), true);
        }
    }
    
    /// MARK: 上传文件
    
    /// 上传文件
    /// {
    /// "uploadUrl":"http://ip:port/server/xxx", 上传url地址
    /// "filePath":"sdcard/xx/xx", 文件本地路径
    /// "sysname":"xxx" 系统标识
    /// }
    /// {
    /// "responseCode":0, 状态码
    /// "responseMsg":"成功", 状态信息文本
    /// }
    /// - Parameters:
    ///   - params: 接受的H5参数名
    ///   - completionHandler: 原生完成回调给H5
    @objc func uploadFileWithCas(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var name = ""
        var url = ""
        var path = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            name = dic["sysname"] as? String ?? ""
            url = dic["uploadURL"] as? String ?? ""
            print("uploadFileWithCas url = \(url)");
            path = dic["filePath"] as? String ?? ""
            print("HGFile uploadFIleWithCas path = \(path)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            name = dic["sysname"] as? String ?? ""
            url = dic["uploadURL"] as? String ?? ""
            print("uploadFileWithCas url = \(url)");
            path = dic["filePath"] as? String ?? ""
        }
//        let dic = getDictionaryFromJSONString(jsonString: params)
//        let name = dic["sysname"] as? String
//        let url = dic["uploadURL"] as? String
//        print("uploadFile url = \(url ?? "")");
//        let path = dic["filePath"] as? String
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.fileUploadingCallBack = self.fileUploadingCallBack
        downloadPlugin.setUploadSuccessCallBack(self.fileUploadSuccessCallBack)
        downloadPlugin.setUploadFailedCallBack(self.fileUploadFailedCallBack)
        let tgc = self.filePrepareUploadCallBack?()
        if tgc == nil || tgc?.isEmpty == true {
            completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "-1", "responseMsg": "登录超时", "code": -1, "msg": "登录超时", "fileId": ""]), true);
            return
        }
        print("uploadFileWithCas tgc = \(String(describing: tgc))")
        
//        downloadPlugin.selectFile { (result, error) in
//        }
        print("uploading = \(self.selectResult ?? [:])")
        if let re = self.selectResult {
            downloadPlugin.uploadFile(url, withFileName: re[AnyHashable("fileName")] as? String, withFileType: "", withFilePath: re[AnyHashable("fileUrl")] as? String, withCasTgc: tgc, withSysname: name) { (result, error, errMsg) in
                if error != nil {
                    print("上传失败\(error?.localizedDescription ?? "") = \(errMsg ?? "")")
                    completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": errMsg ?? "", "code": result?["code"] ?? "", "msg": errMsg ?? "", "fileId": ""]), true);
                }else{
                    let tmp = getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "", "code": "0", "msg": result?["msg"] ?? "", "fileId": result?["retFileId"] ?? ""])
                    print("上传成功 = \(tmp)")
                    completionHandler(tmp, true);
                }
            }
        }
            

        
    }
    
    /// MARK: 下载文件
    
    /// 下载文件
    /// {
    /// "url":"http://ip:port/OA/Name.jpg", 文件下载地址
    /// "type":"jpg",  文件类型
    /// "name":"test"  文件名称
    /// }
    /// {
    /// "responseCode":0, 状态码
    /// "responseMsg":"成功", 状态信息文本
    /// }
    /// - Parameters:
    ///   - params: 接受的H5参数名
    ///   - completionHandler: 原生完成回调给H5
    @objc func previewFileWithCas(_ params: Any, completionHandler: @escaping JSCallback) {
        print("HGFile previewFileWithCas js")
        var dic = NSDictionary()
        var name = ""
        var url = ""
        var type = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            name = dic["name"] as? String ?? ""
            url = dic["url"] as? String ?? ""
            print("previewFileWithCas url = \(url)");
            type = dic["type"] as? String ?? ""
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            name = dic["name"] as? String ?? ""
            url = dic["url"] as? String ?? ""
            print("previewFileWithCas url = \(url)");
            type = dic["type"] as? String ?? ""
        }
//        let dic = getDictionaryFromJSONString(jsonString: params)
//        let name = dic["name"] as? String
//        let url = dic["url"] as? String
//        let type = dic["type"] as? String
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.fileDownloadingCallBack = self.fileDownloadingCallBack
        downloadPlugin.setDownloadSuccessCallBack(self.fileDownloadSuccessCallBack)
        downloadPlugin.setDownloadFailedCallBack(self.fileDownloadFailedCallBack)
        let jsessionId = self.filePrepareDownloadCallBack?()
        print("jsessionId = \(String(describing: jsessionId))")
        downloadPlugin.downloadSWFile(url, withFileName: name, withFileType: type, withIsPreview: true, withJSessionId: jsessionId) { (result, error) in
            if error != nil {
                print("downloadSWFile error = \(error ?? NSError.init(domain: "1", code: -1)) result = \(result ?? [:])")
                var result = ""
                if let err = error as NSError? {
                    if err.code == 303 {
                        result = getJSONStringFromDictionary(dictionary: ["responseCode": "-1", "responseMsg": err.userInfo["msg"] ?? "", "code": "-1", "msg": err.userInfo["msg"] ?? ""])

                    }else{
                        result = getJSONStringFromDictionary(dictionary: ["responseCode": "-1", "responseMsg": err.userInfo["msg"] ?? "失败", "code": "-1", "msg": err.userInfo["msg"] ?? "失败"])
                    }
                }else{
                    result = getJSONStringFromDictionary(dictionary: ["responseCode": "-1", "responseMsg": "失败", "code": "-1", "msg": "失败"])
                }
                completionHandler(result, true);
            }else{
                print("downloadSWFile success = \(result ?? [:])")
                completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功"]), true);
            }
        }
    }
    
    /// tgc下载单一文件
    /// - Parameters:
    ///   - params: 接收H5参数
    ///   - completionHandler: 完成回调给H5
    @objc func previewFileWithTgc(_ params: Any, completionHandler: @escaping JSCallback) {
        print("HGFile previewFileWithTgc")
        var dic = NSDictionary()
        var name = ""
        var url = ""
        var type = ""
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            name = dic["name"] as? String ?? ""
            url = dic["url"] as? String ?? ""
            print("previewFileWithTgc url = \(url)");
            type = dic["type"] as? String ?? ""
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            name = dic["name"] as? String ?? ""
            url = dic["url"] as? String ?? ""
            print("previewFileWithTgc url = \(url)");
            type = dic["type"] as? String ?? ""
        }
//        let dic = getDictionaryFromJSONString(jsonString: params)
//        let name = dic["name"] as? String
//        let url = dic["url"] as? String
//        let type = dic["type"] as? String
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.fileDownloadingCallBack = self.fileDownloadingCallBack
        downloadPlugin.setDownloadSuccessCallBack(self.fileDownloadSuccessCallBack)
        downloadPlugin.setDownloadFailedCallBack(self.fileDownloadFailedCallBack)
        let tgc = self.tgcFilePrepareDownloadCallBack?()
        print("tgc = \(String(describing: tgc))")
        downloadPlugin.downloadSWFile(url, withFileName: name, withFileType: type, withIsPreview: true, withJSessionId: tgc) { (result, error) in
            if error != nil {
                print("downloadSWFile error = \(error?.localizedDescription ?? "")")
                completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "-1", "responseMsg": error?.localizedDescription ?? "失败", "code": "-1", "msg": error?.localizedDescription ?? "失败"]), true);
            }else{
                print("downloadSWFile success = \(result ?? [:])")
                completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功"]), true);
            }
        }
    }
    
    
    /// 选择文件
    /// - Parameters:
    ///   - params: 参数
    ///   - completionHandler: 完成回调给H5
    @objc func selectFile(_ params: String, completionHandler: @escaping JSCallback) {
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.setSelectCallBack(self.selectFileCallBack)
//        downloadPlugin.selectFile { (result, error) in
//            completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功", "fileInfo": ["fileUrl": result?["fileUrl"], "fileName": result?["fileName"], "fileSize": result?["fileSize"]]]), true)
//        }
        downloadPlugin.selectFileShow(true) { [weak self] (result, error) in
            if let strongSelf = self {
                strongSelf.selectFilePath = result?["fileUrl"] as? String
                strongSelf.selectResult = result
            }
            completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功", "fileInfo": ["fileUrl": result?["fileUrl"], "fileName": result?["fileName"], "fileSize": result?["fileSize"]]]), true)
            downloadPlugin.uploadFile("", withFileName: result?[AnyHashable("fileName")] as? String, withFileType: "", withFilePath: result?[AnyHashable("fileUrl")] as? String, withCasTgc: "", withSysname: "") { result, error, errMsg in
                completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功", "fileInfo": ["fileUrl": result?["fileUrl"], "fileName": result?["fileName"], "fileSize": result?["fileSize"]]]), true)
            }
        }

    }
    
    // MARK: 表单提交方式
    /// 表单提交方式
    /// - Parameters:
    ///   - params: 入参
    ///   - completionHandler: 回调
    @objc func formDataUploadFileWithCas(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var uploadUrl = ""
        var filePath = ""
        var postParams = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            uploadUrl = dic["uploadURL"] as? String ?? ""
            filePath = dic["filePath"] as? String ?? ""
            print("HGFile formDataUploadFileWithCas uploadURL = \(uploadUrl)");
            postParams = dic["postParams"] as? NSDictionary ?? NSDictionary()
            print("HGFile formDataUploadFileWithCas filePath = \(filePath)");
            print("HGFile formDataUploadFileWithCas postParams = \(postParams)");
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            uploadUrl = dic["uploadURL"] as? String ?? ""
            filePath = dic["filePath"] as? String ?? ""
            print("HGFile formDataUploadFileWithCas uploadURL = \(uploadUrl)");
            postParams = dic["postParams"] as? NSDictionary ?? NSDictionary()
        }
        
        if let block = formDataUploadCallBack {
            formDataUploadCompletionHandler = completionHandler
            block(dic as! [String : Any])
        }
        
    }
    
    // MARK: 获取文件内容
    /// 获取文件内容
    /// - Parameters:
    ///   - params: 入参
    ///   - completionHandler: 回调
    @objc func getFileContent(_ params: Any, completionHandler: @escaping JSCallback) {
        var dic = NSDictionary()
        var fileType = ""
        var fileSize = ""
        var fileCount = ""
        var hasContent = ""
        print("HGFile getFileContent");
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            fileType = dic["fileType"] as? String ?? ""
            fileSize = dic["fileSize"] as? String ?? ""
            fileCount = dic["fileCount"] as? String ?? ""
            hasContent = dic["hasContent"] as? String ?? ""
            print("HGFile getFileContent fileType = \(fileType)")
            print("HGFile getFileContent fileSize = \(fileSize)")
            print("HGFile getFileContent fileCount = \(fileCount)")
            print("HGFile getFileContent hasContent = \(hasContent)")
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            fileType = dic["fileType"] as? String ?? ""
            fileSize = dic["fileSize"] as? String ?? ""
            fileCount = dic["fileCount"] as? String ?? ""
            hasContent = dic["hasContent"] as? String ?? ""
        }
        
        if let block = self.getFileContentCallBack {
            fileContentCompletionHandler = completionHandler
            block(dic as! [String : Any])
        }
        
//        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
//        downloadPlugin.setSelectCallBack(self.getFileContentCallBack)
//        downloadPlugin.selectFileShow(true) { [weak self] (result, error) in
//            if let strongSelf = self {
//                strongSelf.selectFilePath = result?["fileUrl"] as? String
//                strongSelf.selectResult = result
//            }
//
//        completionHandler(getJSONStringFromDictionary(dictionary: ["responseCode": "0", "responseMsg": "成功", "code": "0", "msg": "成功", "data":["fileList":[["fileName" : result?["fileName"], "filePath" : result?["fileUrl"], "fileType" : result?["fileType"], "fileSize" : result?["fileSize"], "fileContent":result?["fileContent"]]]]]), true)
//        }
        
    }
    
    // MARK: 表单上传请求传给H5
    @objc func setFormDataUploadResultToH5(_ dic: NSDictionary) {
        self.formDataUploadCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    /// 获取文件内容给H5
    @objc func setFileContentResultToH5(_ dic: NSDictionary) {
        self.fileContentCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    // MARK: 直接打开pdf文件
    @objc func openPdfAead(_ url: String){
        let downloadPlugin = NHGDSDownloadPlugin(vc: self.vc)!
        downloadPlugin.openPDF(withPath: url)
    }

}
