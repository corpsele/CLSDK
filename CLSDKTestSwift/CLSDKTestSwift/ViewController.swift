//
//  ViewController.swift
//  CLSDKTestSwift
//
//  Created by corpsele_n on 2026/1/12.
//

import UIKit
import SwiftSoup

class ViewController: UIViewController {
    @IBOutlet var tvReply: UITextView?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let apikey = loadApiKey()
//        requestData()
        let content = """
            <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
            <html>
              <head>
             
                <title>中国药典、兽药典质量标准在线查询-药标网</title>
                
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <meta name="keywords" content="药典,药品标准,药标网,yaobw.cn,在线查询" />
                <meta name="description" content="2020年版中国药典,2015年版中国兽药典,在线查询" />
                
                
                 <link rel="stylesheet" href="/yaobw/css/common.css" type="text/css"/>
              </head>
              
              <body>
                  
                <div class="wrap">
                    
            <style type="text/css">
                    .main_nav ul{margin-right:20px;display:inline-block;}
            </style>
                <div style="text-align:left;padding:5px;margin:0px;">
                    <img src="/yaobw/images/front/logo.jpg" width="164" height="70"  alt="药标网"/>
                
                </div>
                <div style="background:#fff;border:solid 1px #999;border-left:none;border-right:none;margin-bottom:5px;">
                    <div class="main_nav" style="text-align:left;font-size:14px;padding:10px;">
                    <ul    >
                    <li style="float:left;margin-right:35px;"><a href="/yaobw">首页</a></li>
                    <li style="float:left;margin-right:35px;"><a href="/yaobw/book.do?flag=goBook&bookId=1" target="_blank">中国药典</a></li>
                    <li style="float:left;margin-right:35px;"><a href="/yaobw/book.do?flag=goBook&bookId=2" target="_blank">兽药典</a></li>
                    <li style="float:left;margin-right:35px;"><a href="https://www.zhishouai.com/" target="_blank">兽药AI助手</a></li>
                    <li style="float:left;margin-right:35px;"><a href="/bbs" target="_blank">药部落</a></li>
                    <li style="float:left;margin-right:35px;"><a href="https://bbs.99myf.com/" target="_blank">资源下载</a></li>
                    <li style="float:left;margin-right:35px;"><a href="/yaobw/book.do?flag=goBook&bookId=3" target="_blank">宠物药品</a></li>
                
                    </ul>
                    </div>
                </div>
                    
                    <div class="cms_box">
                        <div class="cms_sort clearfix">
                            <div class='searchbox' style='text-align:center;'>
                            <div style="width:600px;padding:0px;margin:10px;display:inline-block;border:solid 1px #69C;line-height:20px;;">
                            <form method="post" action="/yaobw/book.do?flag=search&bookId=1">
                                <input type="text" NAME="name" class="input_k" value="" style=""/><input type="submit" class="input_s" value="搜 索"/>
                            </form>
                            </div>
                        </div>
                    </div>
                    
                    
                    <div class="cms_box_left">
                        <div style='width:100%;background:#ddd;text-align:left;font-weight:bold;line-height:30px;'>&nbsp;药典目录</div>
                        <div style="padding:10px;">
                        
                        
                            <p><strong><a href="book.do?flag=show&bookId=1&cid=1">一部</a></strong>
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=1&cid2=1">药材和饮片 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=1&cid2=2">植物油脂和提取物 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=1&cid2=3">成方制剂和单味制剂 </a>    
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            </p>
                        
                            <p><strong><a href="book.do?flag=show&bookId=1&cid=2">二部</a></strong>
                            
                            
                            
                            
                            
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=2&cid2=4">正文品种第一部分 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=2&cid2=5">正文品种第二部分 </a>    
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            </p>
                        
                            <p><strong><a href="book.do?flag=show&bookId=1&cid=3">三部</a></strong>
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=3&cid2=6">生物制品通则 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=3&cid2=7">总论 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=3&cid2=8">预防类 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=3&cid2=9">治疗类 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=3&cid2=10">体内诊断类 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=3&cid2=11">体外诊断类 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=3&cid2=12">三部通则 </a>    
                            
                            
                            
                            
                            
                            
                            
                            
                            </p>
                        
                            <p><strong><a href="book.do?flag=show&bookId=1&cid=4">四部</a></strong>
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=4&cid2=13">凡例 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=4&cid2=14">通则 </a>    
                            
                            
                            
                                <br>&nbsp;&nbsp;<a href="book.do?flag=show&bookId=1&cid=4&cid2=15">药用辅料 </a>    
                            
                            
                            </p>
                        
                        </div>
                
                        <div style='width:100%;background:#ddd;text-align:left;font-weight:bold;line-height:30px;'>&nbsp;相关链接</div>
                            <ul style="padding:5px;">
                                <li><a href="https://www.chp.org.cn/" target="_blank">&gt; 国家药典委员会 </a></li>
                                <li><a href="https://www.zhishouai.com/" target="_blank">&gt; 知兽AI大模型 </a></li>
                            </ul>
                        </div>
                        
                        <div class="cms_box_right">
                            <div class="path_box clearfix">
                                <ul>
                                <li class="path_item"><a href="/yaobw/book.do?flag=goBook&bookId=1">中国药典</a></li>            </ul>
                            </div>
                            <div class="cms_sort clearfix">
                                <ul>
                                    
                                    <a href="book.do?flag=show&bookId=1&cid=1" style="float:left;line-height:16px;padding:5px;margin:5px;border:solid 1px #ccc;"> 一部 </a>
                                
                                    
                                    <a href="book.do?flag=show&bookId=1&cid=2" style="float:left;line-height:16px;padding:5px;margin:5px;border:solid 1px #ccc;"> 二部 </a>
                                
                                    
                                    <a href="book.do?flag=show&bookId=1&cid=3" style="float:left;line-height:16px;padding:5px;margin:5px;border:solid 1px #ccc;"> 三部 </a>
                                
                                    
                                    <a href="book.do?flag=show&bookId=1&cid=4" style="float:left;line-height:16px;padding:5px;margin:5px;border:solid 1px #ccc;"> 四部 </a>
                                
                                            
                                </ul>
                            </div>
                            <div class="cms_list">
                                <TABLE width="100%" cellpadding="5" border="1">
                                <TR bgcolor="#DDDDDD">
                                    <TH >名称</TH>
                                    <TH width="180">来源</TH>
                                    <TH width="150">分类</TH>
                                    <TH width="60">页码</TH>
                                    <TH width="100">查看</TH>
                                </TR>
                                
                                <TR>
                                <td><a href="book.do?flag=showyao&bookId=1&cid=1&cid2=3&id=1683">连花清瘟片</a></td>
                                <td>一部</td>
                                <td>成方制剂和单味制剂</td>
                                <td>944</td>
                                <td>[<a href="book.do?flag=showyao&bookId=1&cid=1&cid2=3&id=1683">查看</a>]</td>
                                </TR>
                                
                                <TR>
                                <td><a href="book.do?flag=showyao&bookId=1&cid=1&cid2=3&id=1684">连花清瘟胶囊</a></td>
                                <td>一部</td>
                                <td>成方制剂和单味制剂</td>
                                <td>945</td>
                                <td>[<a href="book.do?flag=showyao&bookId=1&cid=1&cid2=3&id=1684">查看</a>]</td>
                                </TR>
                                
                                <TR>
                                <td><a href="book.do?flag=showyao&bookId=1&cid=1&cid2=3&id=1685">连花清瘟颗粒</a></td>
                                <td>一部</td>
                                <td>成方制剂和单味制剂</td>
                                <td>946</td>
                                <td>[<a href="book.do?flag=showyao&bookId=1&cid=1&cid2=3&id=1685">查看</a>]</td>
                                </TR>
                                
                                </TABLE>
                                
                                <p class="pages">
                                    <a href="book.do?flag=search&k=连花清瘟&pageNow=1&bookId=1">首页</a>
                                    
                                    <a href="book.do?flag=search&k=连花清瘟&pageNow=1&bookId=1">上一页</a>
                                    
                                    
                                    
                                    
                                    
                                    
                                        <a href="book.do?flag=search&k=连花清瘟&pageNow=1&bookId=1">1</a>
                                    
                                    
                                    
                                    
                                    <a href="book.do?flag=search&k=连花清瘟&pageNow=1&bookId=1">下一页</a>
                                    
                                    <a href="book.do?flag=search&k=连花清瘟&pageNow=1&bookId=1">末页（1）</a>
                                    <input type="text" id="pagetogo" size="2" value="1"> 
                                    <input type="button" onclick="location.href='book.do?flag=search&bookId=1&k=连花清瘟&pageNow='+document.getElementById('pagetogo').value;" value=" GO ">
                                </p>
                                
                            </div>
                        </div>
                
                     </div>
                    
            <script>
            var _hmt = _hmt || [];
            (function() {
              var hm = document.createElement("script");
              hm.src = "https://hm.baidu.com/hm.js?04e349ce53671666bca5a87c63525bbe";
              var s = document.getElementsByTagName("script")[0]; 
              s.parentNode.insertBefore(hm, s);
            })();
            </script>
                <div style="border:none;border-top:solid 1px #999;padding:5px;">
                    <p>(c)药标网 - 中国药典、兽药典质量标准在线查询<a href="https://beian.miit.gov.cn/">（豫ICP备16032441号-1）</a></p>
                </div>
                
            </div>
              </body>
            </html>
            """
        sendOllamaRequest(apiKey: apikey, content: content + " 帮我解析出上面html代码里的药品名称name、来源source、分类type、页码pageNo、超链接link，并以array数组json格式返回，注意不要多于的内容")
    }
    
    // 定义一个工具方法
    func showLoading(on view: UIView) -> UIView {
        // 1. 创建背景遮罩
        let container = UIView(frame: view.bounds)
        container.backgroundColor = UIColor(white: 0, alpha: 0.3) // 半透明黑底
        
        // 2. 创建 Loading
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.center = container.center
        indicator.startAnimating()
        
        container.addSubview(indicator)
        view.addSubview(container)
        
        return container // 返回容器以便稍后移除
    }
    
    func sendOllamaRequest(apiKey: String, content: String) {
        let showLoading = showLoading(on: view)
        // 1. 设置 URL
        guard let url = URL(string: "https://ollama.com/api/chat") else { return }
        
        // 2. 创建 Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 3. 设置 Header
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 4. 设置 Body (JSON)
        let parameters: [String: Any] = [
            "model": "qwen3-vl:235b-cloud",
            "messages": [
                [
                    "role": "user",
                    "content": content
                ]
            ],
            "stream": false
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("JSON serialization error: \(error)")
            return
        }
        
        // 5. 发起请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 6. 处理错误
            if let error = error {
                print("Request Error: \(error.localizedDescription)")
                return
            }
            
            // 7. 检查 HTTP 状态码
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            
            // 8. 解析返回的数据
            guard let data = data else { return }
            
            do {
                // 如果需要将结果转为 JSON 对象
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    do{
                        if let dicMsg = jsonResponse["message"] as? [String: Any] {
                            if let strContent = dicMsg["content"] as? String{
                                let data = try JSONSerialization.data(withJSONObject: jsonResponse)
                                
                                
                                let str = String(data: data, encoding: .utf8)
                                DispatchQueue.main.async {
                                    self.tvReply?.text = strContent
                                }
                            }
                        }
                        
                        
                    }catch{
                        print("error \(error)")
                    }
                    
                    
                    // 如果是在主线程更新 UI，需要跳回主线程
                    DispatchQueue.main.async {
                        // 例如: self.label.text = jsonResponse["message"] as? String
                    }
                }
            } catch {
                print("JSON Parsing Error: \(error)")
                if let stringData = String(data: data, encoding: .utf8) {
                    print("Raw Response: \(stringData)")
                }
            }
            DispatchQueue.main.async {
                showLoading .removeFromSuperview()
            }
            
        }
        
        task.resume()
    }
    
    func loadApiKey() -> String{
        guard let filePath = Bundle.main.path(forResource: "apikey", ofType: "json") else { return "" }
        var json = ""
        do {
            let dataKey = try Data(contentsOf: URL(filePath: filePath))
            let dic = try JSONSerialization.jsonObject(with: dataKey)
            if let d = dic as? [String: Any] {
                if let str = d["apiKey"] as? String {
                    json = str
                }
            }
            
        }catch{
            print(error)
        }
        return json
    }

    func requestData() {
        let parameters = [
          [
            "key": "name",
            "value": "连花清瘟",
            "type": "text"
          ]] as [[String: Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = Data()
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] != nil { continue }
          let paramName = param["key"]!
          body += Data("--\(boundary)\r\n".utf8)
          body += Data("Content-Disposition:form-data; name=\"\(paramName)\"".utf8)
          if param["contentType"] != nil {
            body += Data("\r\nContent-Type: \(param["contentType"] as! String)".utf8)
          }
          let paramType = param["type"] as! String
          if paramType == "text" {
            let paramValue = param["value"] as! String
            body += Data("\r\n\r\n\(paramValue)\r\n".utf8)
          } else {
            let paramSrc = param["src"] as! String
            let fileURL = URL(fileURLWithPath: paramSrc)
            if let fileContent = try? Data(contentsOf: fileURL) {
              body += Data("; filename=\"\(paramSrc)\"\r\n".utf8)
              body += Data("Content-Type: \"content-type header\"\r\n".utf8)
              body += Data("\r\n".utf8)
              body += fileContent
              body += Data("\r\n".utf8)
            }
          }
        }
        body += Data("--\(boundary)--\r\n".utf8);
        let postData = body


        var request = URLRequest(url: URL(string: "http://yaobw.cn/yaobw/book.do?flag=search&bookId=1")!,timeoutInterval: Double.infinity)
        request.addValue("JSESSIONID=4973FF2635BD2F17843D9F9FA5EF0C8C", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
//          print(String(data: data, encoding: .utf8)!)
            let str = String(data: data, encoding: .utf8)
            self?.parseData(str ?? "")
        }

        task.resume()

    }
    
    func parseData(_ str: String){
        
        if str.isEmpty == false {
            do {
                let document = try SwiftSoup.parse(str)
                let doc1 = try document.select("div.cms_list")
                print("doc1 = \(doc1), doc1.count = \(doc1.count)")
                for str1 in doc1 {
                    print("str1 = \(try str1.html())")
                    let doc2 = try str1.select("tr")
                    print("doc2 = \(doc2), doc2.count = \(doc2.count)")
                }
            }
            catch(let e) {
                print(e.localizedDescription)
            }
            
        }
    }

}

