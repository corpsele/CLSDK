//
//  NHGWebView_Extension.swift
//  CLSDK
//
//  Created by  on 2021/11/29.
//

import Foundation
import UIKit

extension NHGWebView {
    
    // MARK: 手机盾加签回调
    // @param h5参数
    private var bShieldForSignCallBack: ((Any, JSCallback) -> ())? {
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &(associatedKey.ShieldForSignKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return objc_getAssociatedObject(self, &(associatedKey.ShieldForSignKey)) as? (Any, JSCallback) -> ()
        }
    }
    
    // MARK: 手机盾加签回调
    @objc public func setShieldForSignCallBack(_ callback: ((Any, JSCallback) -> ())?) {
        self.bShieldForSignCallBack = callback
        self.shield.shieldForSignCallBack = self.bShieldForSignCallBack
    }
    
    ///属性键
    struct associatedKey {
        /// 错误视图key
         static var ErrorViewKey = "ErrorViewKey"
        /// 手机盾加签key
        static var ShieldForSignKey = "ShieldForSignKey"
    }
     
    // MARK: 错误视图
    private var ErrorView: UIView? {
            set {
                if let newValue = newValue {
                    
                    objc_setAssociatedObject(self, &(associatedKey.ErrorViewKey), newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
            }
            
            get {
                return objc_getAssociatedObject(self, &(associatedKey.ErrorViewKey)) as? UIView
            }
    }

    // MARK: 生成错误视图
    private func buildErrorView() -> UIView {
        if let view = ErrorView {
            return view
        }else{
            ErrorView = UIView()
            ErrorView?.backgroundColor = .white
            self.addSubview(ErrorView ?? UIView())
            ErrorView?.snp.makeConstraints({ make in
                make.centerX.equalTo(self);
                make.top.equalTo(kTopHeight);
                make.width.height.equalTo(300.0);
            })
            let noDataImage = UIImageView()
            noDataImage.image = UIImage(named: "Network_Error")
            noDataImage.contentMode = .scaleAspectFit
            ErrorView?.addSubview(noDataImage)
            noDataImage.snp.makeConstraints { make in
                make.centerX.equalTo(ErrorView!);
                make.bottom.equalTo(ErrorView!.snp.centerY);
                make.width.height.equalTo(100.0);
            }
            let nameLabel = UILabel()
            nameLabel.text = "连接异常，请稍后重试！"
            nameLabel.textColor = UIColor(hexString: "#333333")
            nameLabel.textAlignment = .center
            nameLabel.font = UIFont.systemFont(ofSize: 16.0)
            nameLabel.sizeToFit()
            ErrorView?.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.centerX.equalTo(noDataImage);
                make.height.equalTo(50.0);
                make.top.equalTo(noDataImage.snp.bottom).offset(20.0);
            }
//            let backBtn = UIButton()
            
        }
        return ErrorView ?? UIView()
    }
//    //页面异常
//    - (void)buildErrorView{
//
//        self.errorView = [[UIView alloc]init];
//        self.errorView.backgroundColor = [UIColor whiteColor];
//        [self.viewController.view addSubview:self.errorView];
//        [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.viewController.view);
//            make.top.offset(kTopHeight);
//            make.width.height.offset(300);
//        }];
//
//            UIImageView * noDataImage = [[UIImageView alloc]init];
//            noDataImage.image = [UIImage imageNamed:@"nodata"];
//            noDataImage.contentMode = UIViewContentModeScaleAspectFit;
//            [self.errorView addSubview:noDataImage];
//            [noDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(self.errorView);
//                make.bottom.equalTo(self.errorView.mas_centerY);
//                make.width.height.offset(100);
//            }];
//
//            UILabel * nameLabel = [[UILabel alloc]init];
//            nameLabel.text = @"连接异常，请稍后重试！";
//            nameLabel.textColor = BLACK_COLOUR;
//            nameLabel.textAlignment = NSTextAlignmentCenter;
//            nameLabel.font = [UIFont systemFontOfSize:16];
//            [nameLabel sizeToFit];
//            [self.errorView addSubview:nameLabel];
//            [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(noDataImage);
//                make.height.offset(50);
//                make.top.equalTo(noDataImage.mas_bottom).offset(20);
//            }];
//
//            UIButton * backBtn = [[UIButton alloc]init];
//            backBtn.backgroundColor = BLUE_COLOUR;
//            [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
//            backBtn.layer.cornerRadius = 5;
//            backBtn.layer.masksToBounds = YES;
//            [self.errorView addSubview:backBtn];
//            [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(noDataImage);
//                make.top.equalTo(nameLabel.mas_bottom).offset(30);
//                make.width.offset(150);
//                make.height.offset(44);
//            }];
//
//            [backBtn addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    - (void)backMethod{
//        [self.viewController.navigationController popViewControllerAnimated:YES];
//    }
}
