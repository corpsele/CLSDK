//
//  HGStorage.swift
//  CLSDK
//
//  Created by  on 2022/3/22.
//

import Foundation

class HGStorage: NSObject {
    /// 父控制器
    private var vc: UIViewController?
    
    /// 写文件回调block
    @objc public var writeFileCallBack: (([String: Any], JSCallback) -> ())?
    
    /// 读文件回调block
    @objc public var readFileCallBack: (([String: Any], JSCallback) -> ())?
    
    /// 写文件传给的H5回调
    private var wCompletionHander: JSCallback?
    
    /// 读文件传给的H5回调
    private var rCompletionHander: JSCallback?
    
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    
    /// 写文件接口
    /// - Parameters:
    ///   - params: filePath 文件路径  content 写入的文件内容（String）
    ///   - completionHandler: 回调给H5
    @objc func writeFile(_ params: Any, completionHandler: @escaping JSCallback) {
        
            var dic = NSDictionary()
            var filePath = ""
            var content = ""
            if (params is String){
                dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
                filePath = dic["filePath"] as? String ?? ""
                print("HGStorage writeFile filePath string = \(filePath)")
                content = dic["content"] as? String ?? ""
                print("HGStorage writeFile content = \(content)")
            }else if(params is NSDictionary) {
                dic = params as? NSDictionary ?? NSDictionary()
                filePath = dic["filePath"] as? String ?? ""
                print("HGStorage writeFile filePath dic = \(filePath)")
                content = dic["content"] as? String ?? ""
            }
            
        if let block = writeFileCallBack {
            wCompletionHander = completionHandler
            block(dic as! [String : Any], completionHandler)
        }

    }
    
    // MARK: 写文件结果传给H5
    /// - Parameter dic: 加密后的字典
    public func setWriteFileResultToH5(_ dic: NSDictionary){
        print("HGStorage writeFile setResultToH5")
        wCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    /// 读文件接口
    /// - Parameters:
    ///   - params: filePath 文件路径
    ///   - completionHandler: 回调给H5
    @objc func readFile(_ params: Any, completionHandler: @escaping JSCallback) {
        print("params = \(params)")
            var dic = NSDictionary()
            var filePath = ""
            if (params is String){
                dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
                filePath = dic["filePath"] as? String ?? ""
                print("HGStorage readFile filePath string = \(filePath)")
            }else if(params is NSDictionary) {
                dic = params as? NSDictionary ?? NSDictionary()
                filePath = dic["filePath"] as? String ?? ""
                print("HGStorage readFile filePath dic = \(filePath)")
            }
            print("dic = \(dic)")
        if let block = readFileCallBack {
            rCompletionHander = completionHandler
            block(dic as! [String : Any], completionHandler)
        }

    }
    
    // MARK: 读文件结果传给H5
    /// - Parameter dic: 加密后的字典
    public func setReadFileResultToH5(_ dic: NSDictionary){
        print("HGStorage readFile setResultToH5")
        rCompletionHander?(getJSONStringFromDictionary(dictionary: dic), true)
    }
}
