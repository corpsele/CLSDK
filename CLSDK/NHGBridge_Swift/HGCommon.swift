//
//  Common.swift
//  CLSDK
//
//  Created by  on 2021/9/6.
//

/**
 字典转换为JSONString

 - parameter dictionary: 字典参数

 - returns: JSONString
 */
func getJSONStringFromDictionary(dictionary: NSDictionary) -> String {
    if !JSONSerialization.isValidJSONObject(dictionary) {
        print("无法解析出JSONString")
        return ""
    }
    let data: NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
    let JSONString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
}

// JSONString转换为字典

func getDictionaryFromJSONString(jsonString: String) -> NSDictionary {
    let jsonData: Data = jsonString.data(using: .utf8)!

    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! NSDictionary
    }
    return NSDictionary()
}

// MARK: 传给H5
public func setResultsToH5(_ completionHandler: @escaping JSCallback, _ str: String) {
    print("HGCommon setResultToH5")
    print("HGCommon setResultToH5 str = \(str)")
    completionHandler(str, true)
}

/*
 导航栏/标签栏尺寸
 */
let kStatusBarHeight = UIApplication.shared.statusBarFrame.size.height //状态栏高度
let iPhoneXHeight = 812 //iphonex 高度
let kNavBarHeight = 44.0 //导航栏高度
let kTabBarHeight = (kStatusBarHeight > 20.0 ? 83.0 : 49) //标签栏的高度
let kTopHeight = kStatusBarHeight + kNavBarHeight //状态栏加导航栏高度
let isTypeiPhoneX = (kStatusBarHeight > 20.0 ? true : false)
let kHomeHeight = (isTypeiPhoneX ? 34 : 0)
