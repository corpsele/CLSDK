//
//  NHGWebVC.swift
//  HGSDKTest_OC
//
//  Created by  on 2021/9/1.
//


let WEB_URL_STR = "https://192.168.0.100:8080/#/question"
let WEB_URL = URL(string:WEB_URL_STR)

func showAlert(_ title: String, _ msg: String, _ vc: UIViewController, _ cancelBlock:@escaping () -> (), _ okBlock:@escaping () -> ()) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "取消", style: .cancel) { action  in
        cancelBlock()
    }
    let ok = UIAlertAction(title: "重试", style: .default) { action in
        okBlock()
    }
    alert.addAction(cancel)
    alert.addAction(ok)
    vc.present(alert, animated: true) {
        
    }
}

import UIKit

import CLSDK
import ReactiveSwift
import ReactiveCocoa
import YJProgressHUD
import SVProgressHUD

class NHGWebVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(self.webView)
        self.view.addSubview(self.btnBack)
        self.webView.load(self.request)
        
        YJProgressHUD.shareinstance().hud.tintColor = .black
        YJProgressHUD.shareinstance().hud.contentColor = .black
        YJProgressHUD.shareinstance().hud.backgroundColor = .black
        
        self.btnBack.reactive.controlEvents(.touchUpInside).observeResult({[unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        self.webView.setDownloadSuccessCallBack { path in
            SVProgressHUD.dismiss()
            let common = Common()
            common.openPDF(withPath: path ?? "")
        }
        
        self.webView.setDownloadingCallBack {
            SVProgressHUD.show(withStatus: "文件下载中")
        }
        
        self.webView.setDownloadFailedCallBack { err in
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: err?.localizedDescription)
        }
        
        self.webView.didCommitBlock = { (v, navi) in
            
        }
        
        self.webView.didStartBlock = {[unowned self] (v, navi) in
            self.btnBack.isHidden = false
            YJProgressHUD.showProgress("页面加载中", in: self.view)
        }
        
        self.webView.didFinishBlock = {[unowned self] (v, navi) in
            self.btnBack.isHidden = true
            YJProgressHUD.showMessage("页面加载完成", in: self.view)
        }
        
        self.webView.didFailBlock = {[unowned self] (v, navi, e) in
            YJProgressHUD.hide()
            showAlert("错误", "网页加载失败", self) {
                
            } _: { [unowned self] in
                self.webView.load(self.request)
            }
        }
        
        self.webView.didFailProvisionalBlock = {[unowned self] (v, navi, e) in
            YJProgressHUD.hide()
            showAlert("错误", "网页加载失败", self) {
                
            } _: {
                self.webView.load(self.request)
            }

        }
        
        self.webView.setSpeakEndCallBack { str in
            print("str = \(str ?? "")")
        }
        
        self.webView.setSpeakCancelCallBack {
            
        }
        
        self.webView.setScannerCallBack {_ in 
            
        }
        
        self.webView.setDeviceInfoCallBack {_ in 
            
        }
        
        self.webView.setLocationCallBack {_ in 
            
        }
        
        self.webView.setWindowCloseCallBack {
            
        }
        
        
    }
    
    lazy var btnBack:UIButton = {
        let btn = UIButton(frame: CGRect(x: 5.0, y: 30.0, width: 100.0, height: 100.0))
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 65.0)
        btn.isHidden = true
        return btn
    }()
    
    lazy var configuration: WKWebViewConfiguration = {
       let config = WKWebViewConfiguration()
       return config
    }()
    
    lazy var webView: NHGWebView = {
        let view = NHGWebView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), configuration: self.configuration, vc: self)
        return view
    }()
    
    lazy var request: URLRequest = {
        let request = URLRequest(url: WEB_URL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 2)
        return request
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
