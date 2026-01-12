//
//  HGCamera.swift
//  CLSDK
//
//  Created by  on 2022/6/16.
//

import UIKit

class HGCamera: NSObject {
    ///父控制器
    private var vc: UIViewController?
    
    /// 拍照后H5回调
    private var tCompletionHandler: JSCallback?
    
    /// 获取图片H5回调
    private var gCompletionHandler: JSCallback?
    
    /// 扫码回调
    @objc public var takePictureCallBack: (() -> ())?
    
    /// 获取图片回调
    @objc public var getImageCallBack: (([String: Any]) -> ())?
    
    @objc init(_ vc: UIViewController) {
        super.init()
        self.vc = vc
    }
    
    // MARK: 拍照接口
    @objc func takePictureWithFrontCamera(_ params: Any, completionHandler: @escaping JSCallback) {
        print("HGCamera takePictureWithFrontCamera")
        if let b = takePictureCallBack {
            b()
        }
        self.tCompletionHandler = completionHandler;
    }
    
    // MARK: 读拍照结果传给H5
    /// - Parameter dic: 字典
    public func setTakePictureResultToH5(_ dic: NSDictionary) {
        print("HGCamera takePicture setResultToH5")
        tCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
    
    // MARK: 获取图片
    /// 获取图片
    /// - Parameters:
    ///   - params: count:最多可以选择的图片数量 sourceType:1:从相册选择 2:使用相机拍摄 isCompress:图片是否压缩 camera:1:使用后置摄像头 2:使用前置摄像头
    ///   - completionHanlder: code: 0 请求成功 1 请求失败 020011 请求参数错误 data imgList [{"format" : "jpg", "img" : "xxx1"}, {"format" : "jpg", "img" : "xxx2"}]
    @objc func getImage(_ params: Any, completionHandler: @escaping JSCallback) {
        print("HGCamera getImage")
        var dic = NSDictionary()
        if (params is String){
            dic = getDictionaryFromJSONString(jsonString: params as? String ?? "")
            
        }else if(params is NSDictionary) {
            dic = params as? NSDictionary ?? NSDictionary()
            
        }
        if let b = getImageCallBack {
            gCompletionHandler = completionHandler
            b(dic as! [String: Any])
        }
    }
    
    // MARK: 获取图片结果传给H5
    /// - Parameter dic: 字典
    public func setImageResultToH5(_ dic: NSDictionary) {
        print("HGCamera getImage setResultToH5")
        gCompletionHandler?(getJSONStringFromDictionary(dictionary: dic), true)
    }
}
