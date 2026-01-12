//
//  IUMQRCodeViewController.h
//  EMMKitDemo
//
//  Created by Chenly on 16/7/5.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IUMQRCodeViewController;

typedef NS_ENUM(NSUInteger, IUMQRCodeScannerType) {
    IUMQRCodeScannerTypeBoth = 0,
    IUMQRCodeScannerTypeQRCode,
    IUMQRCodeScannerTypeBarCode,
};

/// 扫码完成回调 返回字符串结果
typedef void(^QRCodeFinishBlock)(NSString *);
/// 取消扫码回调
typedef void(^QRCodeCancelBlock)(void);

@protocol IUMQRCodeViewControllerDelegate <NSObject>

- (void)ium_QRCodeViewController:(IUMQRCodeViewController *)viewController didFinishScanningQRCode:(NSString *)code;

@end

@interface IUMQRCodeViewController : UIViewController

@property (nonatomic, weak) id<IUMQRCodeViewControllerDelegate> delegate;
@property (nonatomic, assign) IUMQRCodeScannerType scannerType;
@property (nonatomic, copy) NSString * tintMsg;//提示信息

/// 扫码完成回调 返回字符串结果
@property (nonatomic, copy) QRCodeFinishBlock qrcodeFinishBlock;
/// 扫码取消回调
@property (nonatomic, copy) QRCodeCancelBlock qrcodeCancelBlock;

- (void)startScanning;

/// 初始化实例并传输父类的实体
/// @param sender 实体
/// @return 实例
- (id)initWithObject:(id)sender;

@end
