//
//  IUMQRCodeViewController.m
//  EMMKitDemo
//
//  Created by Chenly on 16/7/5.
//  Copyright © 2016年 Little Meaning. All rights reserved.
//
//  源码来自 https://github.com/yannickl/QRCodeReaderViewController

#import "IUMQRCodeViewController.h"
#import "UIAlertController+IUMExtensions.h"
#import "Prefix.h"
#import <AVFoundation/AVFoundation.h>

@interface IUMQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *scanRectView;

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *localAlbumButton;

@property (nonatomic, strong) UIImagePickerController *pickerController;


/// 弹出父类实体
@property (nonatomic, strong) id sender;

@end

@implementation IUMQRCodeViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {    
    return UIInterfaceOrientationMaskPortrait;
}

- (id)initWithObject:(id)sender {
    if (self = [super init]) {
        self.sender = sender;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:IUM_IMAGE_NAMED(@"QRCode_back_button") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.flashButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:IUM_IMAGE_NAMED(@"QRCode_torch_off") forState:UIControlStateNormal];
        [button setImage:IUM_IMAGE_NAMED(@"QRCode_torch_on") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleTorch) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    self.localAlbumButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:IUM_IMAGE_NAMED(@"QRCode_pic_button") forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedLocalAlbum) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus ==AVAuthorizationStatusRestricted ||
        authStatus ==AVAuthorizationStatusDenied)     {
        [self.sender dismissViewControllerAnimated:YES completion:nil];
        [UIAlertController showAlertWithTitle:@"未获取到相机权限" message:@"请到设置-隐私中开启相机权限"];
        return;
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        // 发出权限请求, 在未决定的时候发出请求系统才会弹出对话框,其它情况下发出下面的请求也不弹框,需要自己去指引用户设置
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self buildCaramUI];
                });
            }else{
//                [self backAction];
            }
        }];
        return;
    }
    
    [self buildCaramUI];
}
    
- (void)buildCaramUI{
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    
    CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
    
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:([UIScreen mainScreen].bounds.size.height<500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    NSArray *metadataObjectTypes;
    switch (self.scannerType) {
        case IUMQRCodeScannerTypeBoth:
            metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                    AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code,
                                    
                                    AVMetadataObjectTypeUPCECode,
                                    AVMetadataObjectTypeCode39Code,
                                    AVMetadataObjectTypeCode39Mod43Code,
                                    AVMetadataObjectTypeCode93Code,
                                    AVMetadataObjectTypePDF417Code,
                                    AVMetadataObjectTypeAztecCode,
                                    AVMetadataObjectTypeInterleaved2of5Code,
                                    AVMetadataObjectTypeITF14Code,
                                    AVMetadataObjectTypeDataMatrixCode
                                    ];
        break;
        case IUMQRCodeScannerTypeQRCode:
            metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        break;
        case IUMQRCodeScannerTypeBarCode:
            metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code];
        break;
    }
    
    self.output.metadataObjectTypes = metadataObjectTypes;
    self.output.rectOfInterest = scanRect;
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    self.scanRectView = [UIView new];
    [self.view addSubview:self.scanRectView];
    self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
    self.scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    self.scanRectView.layer.borderColor = [UIColor greenColor].CGColor;
    self.scanRectView.layer.borderWidth = 1;
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.scanRectView.frame.origin.y+self.scanRectView.frame.size.height+10, self.view.frame.size.width, 60)];
    titleLab.numberOfLines = 0;
    titleLab.text = self.tintMsg==nil?@"对准二维码，条形码进行扫描":self.tintMsg;
    titleLab.textColor = [UIColor whiteColor];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
        
    //开始捕获
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startScanning {
    [self.session startRunning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.backButton.frame = CGRectMake(16, 24, 37, 37);
    self.flashButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 16 - 37, 24, 37, 37);
    self.localAlbumButton.frame = CGRectMake(CGRectGetMinX(self.flashButton.frame) - 47, 24, 37, 37);
}

- (UIImagePickerController *)pickerController {
    if (!_pickerController) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _pickerController.delegate = self;
        _pickerController.allowsEditing = NO;
        //解决iOS11以上相册列表向上偏移问题
        _pickerController.navigationBar.translucent = NO;
    }
    return _pickerController;
}

#pragma mark - <AVCaptureMetadataOutputObjectsDelegate>

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count == 0) {
        return;
    }
    
    [self.session stopRunning];
    AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
    if (self.qrcodeFinishBlock) {
        self.qrcodeFinishBlock(metadataObject.stringValue);
    }
    //输出扫描字符串
    [self.delegate ium_QRCodeViewController:self didFinishScanningQRCode:metadataObject.stringValue];
}

#pragma mark - button actions

- (void)backAction {
    if (self.qrcodeCancelBlock) {
        self.qrcodeCancelBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleTorch {
    AVCaptureDevice *avDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![avDevice hasTorch]) {
        // 没有闪光灯
    }
    else {
        self.flashButton.selected = !self.flashButton.selected;
        [avDevice lockForConfiguration:nil];
        avDevice.torchMode = !avDevice.torchMode;
        [avDevice unlockForConfiguration];
    }
}

- (void)clickedLocalAlbum{
     [self presentViewController:self.pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

/** alertMessageString 读取相册中二维码相册的结果*/
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info; {
    UIImage *pickerImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *resultString = nil;
    resultString = [self readAlbumQRCodeImage:pickerImage];
    [self dismissViewControllerAnimated:YES completion:^{
          [self.delegate ium_QRCodeViewController:self didFinishScanningQRCode:resultString];
        if (self.qrcodeFinishBlock) {
            self.qrcodeFinishBlock(resultString);
        }
    }];
 
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - Read the photo album of QRCode  读取相册的中二维码
- (NSString *)readAlbumQRCodeImage:(UIImage *)imagePicker {
    CIImage *qrcodeImage = [CIImage imageWithCGImage:imagePicker.CGImage];
    CIContext *qrcodeContext = [CIContext contextWithOptions:nil];
    CIDetector *qrcodeDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:qrcodeContext options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *qrcodeFeaturesArr = [qrcodeDetector featuresInImage:qrcodeImage];
    NSString *qrCodeString = nil;
    if (qrcodeFeaturesArr && qrcodeFeaturesArr.count > 0) {
        for (CIQRCodeFeature *feature in qrcodeFeaturesArr) {
            if (qrCodeString && qrCodeString.length > 0) {
                break;
            }
            qrCodeString = feature.messageString;
        }
    }
    
    NSString *alertMessageString = nil;
    alertMessageString = qrCodeString;
    
    if (qrCodeString) {
        [self.session stopRunning];
    }
    
    return alertMessageString;
}

@end
