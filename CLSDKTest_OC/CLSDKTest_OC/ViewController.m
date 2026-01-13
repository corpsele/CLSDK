//
//  ViewController.m
//  HGSDKTest_OC
//
//  Created by  on 2021/8/31.
//

#define WEB_URL [NSURL URLWithString: @"https://192.168.0.100:8080/#/question"]
#define WEB_URL1 [NSURL URLWithString: @"http://www.xmsyj.moa.gov.cn/gjjlhz/202111/t20211102_6381054.htm"]
#define WEB_URL2 [NSURL URLWithString: @"https://apptest..gov.cn/appwebserver/app/dist/#/hgmobcarapp2600411appInfo?applyType=1&status=new&speType=4&projectSubCode=11"]

#import "ViewController.h"

#import <CLSDK/CLSDK-Swift.h>
#import <WebKit/WebKit.h>
#import <Toast.h>
#import <YJProgressHUD.h>
#import <ReactiveObjC.h>
#import "CLSDKTest_OC-Swift.h"
#import "CLSDKTest_OC-Bridging-Header.h"


@interface ViewController ()

@property (nonatomic, strong) NHGWebView *webView;

@property (nonatomic, strong) WKWebViewConfiguration *configuration;

@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:false];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    YJProgressHUD.shareinstance.hud.bezelView.backgroundColor = UIColor.blackColor;
    YJProgressHUD.shareinstance.hud.customView.backgroundColor = UIColor.blackColor;
    YJProgressHUD.shareinstance.hud.backgroundView.backgroundColor = UIColor.blackColor;
    
    [self addNaviButtonItem];
    
    [self.view addSubview:self.webView];
    
    self.request = [[NSURLRequest alloc] initWithURL:WEB_URL2 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.webView loadRequest:self.request];
    
    __weak typeof(self) weakSelf = self;
    [self.webView setDidStartBlock:^(NHGWebView * _Nonnull webView, WKNavigation * _Nonnull navigation) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [YJProgressHUD showProgress:@"网页加载中" inView:[UIApplication sharedApplication].keyWindow];
    }];
    
    [self.webView setDidFailBlock:^(NHGWebView * _Nonnull webView, WKNavigation * _Nonnull navigation, NSError * _Nonnull error) {
        [YJProgressHUD hide];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showErrorDialog:error];
    }];
    
    [self.webView setDidCommitBlock:^(NHGWebView * _Nonnull webView, WKNavigation * _Nonnull navigation) {
            
    }];
    
    [self.webView setDidFinishBlock:^(NHGWebView * _Nonnull webView, WKNavigation * _Nonnull navigation) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [YJProgressHUD showSuccess:@"网页加载完成" inview:strongSelf.view];
//        [ProgressHUD dismiss];
//        [strongSelf.view makeToast:@"网页加载完成" duration:2 position:CSToastPositionCenter];
        
    }];
    
    [self.webView setDidFailProvisionalBlock:^(NHGWebView * _Nonnull webView, WKNavigation * _Nonnull navigation, NSError * _Nonnull error) {
        [YJProgressHUD hide];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf showErrorDialog:error];
    }];
    
    [self.webView setDeviceInfoCallBack:^(NSDictionary<NSString *,id> * _Nonnull dic) {
        
    }];
    
    [self.webView setLocationCallBack:^(NSDictionary<NSString *,id> * _Nonnull dic){
        
    }];
    
    [self.webView setPrepareUploadCallBack:^NSString * _Nonnull{
        return @"TGC=eyJhbGciOiJIUzUxMiJ9.WlhsS2FHSkhZMmxQYVVwcllWaEphVXhEU214aWJVMXBUMmxLUWsxVVNUUlJNRXBFVEZWb1ZFMXFWVEpKYmpBdUxqWjRWV0V0UVdKRmRrSnJla1JPWlU1TU5XeE9VVUV1VFdkWloyVmZRVmxyVUVwdU1WWkRkblIxVkc4dGJWZzVWSHB6UWtSWGVHbHBaRU5sVWtWRVpIcHRMV2RNU201WkxUUm1PRUZ4WDBKd1V6WTVRVmxCY2pVMldUSlJNMEZsZVVsSE5rODRhV2xMV2tacGRHMDJPVWR4VDNCYVVHOXViR2xHVjNkNk5ETjNMVEpuWjFWbGExRnhObGx4VW5aWlpIVTVVV1pwWVdoWlpWTklObEpMYVhab2FXdEdNbE50T0d0QmR6SXdaWGRJUlZOTWExY3pORnBVU1hsU00xZENTbGxRTmxadVkyNTJPRmcxWkc1c05VZHphVEZJWkVGSWIweDJSWHAwYmt0MVFTMXVNVnBTYTJoUU16QkpYelpsTjFGMWJqTXpWMk4xVFVkc2JYVklNWE41YkRWRFRUZHJaekptZDA4NFpWcG1RbkpTU1VaUllTNUNkR1JuU0c5cE5EWTNVVk52VERZNWJrc3RjM1pu.pk4ylIowOD3Zjiflpgmk_Dj2rdAzpKcLTrZWs_Qn4UlOhn3H50bfGf9ZbdzEeExv5ZypHTaEaLU7amGccerkIw;";
    }];
    
    [self.webView setPrepareDownloadCallBack:^NSString * _Nonnull{
        return @"TGC=eyJhbGciOiJIUzUxMiJ9.WlhsS2FHSkhZMmxQYVVwcllWaEphVXhEU214aWJVMXBUMmxLUWsxVVNUUlJNRXBFVEZWb1ZFMXFWVEpKYmpBdUxqWjRWV0V0UVdKRmRrSnJla1JPWlU1TU5XeE9VVUV1VFdkWloyVmZRVmxyVUVwdU1WWkRkblIxVkc4dGJWZzVWSHB6UWtSWGVHbHBaRU5sVWtWRVpIcHRMV2RNU201WkxUUm1PRUZ4WDBKd1V6WTVRVmxCY2pVMldUSlJNMEZsZVVsSE5rODRhV2xMV2tacGRHMDJPVWR4VDNCYVVHOXViR2xHVjNkNk5ETjNMVEpuWjFWbGExRnhObGx4VW5aWlpIVTVVV1pwWVdoWlpWTklObEpMYVhab2FXdEdNbE50T0d0QmR6SXdaWGRJUlZOTWExY3pORnBVU1hsU00xZENTbGxRTmxadVkyNTJPRmcxWkc1c05VZHphVEZJWkVGSWIweDJSWHAwYmt0MVFTMXVNVnBTYTJoUU16QkpYelpsTjFGMWJqTXpWMk4xVFVkc2JYVklNWE41YkRWRFRUZHJaekptZDA4NFpWcG1RbkpTU1VaUllTNUNkR1JuU0c5cE5EWTNVVk52VERZNWJrc3RjM1pu.pk4ylIowOD3Zjiflpgmk_Dj2rdAzpKcLTrZWs_Qn4UlOhn3H50bfGf9ZbdzEeExv5ZypHTaEaLU7amGccerkIw;";
    }];
    
    [self.webView setSelectFileCallBack:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
        
    }];
    
}

- (void)addNaviButtonItem {
    __weak typeof(self) weakSelf = self;
    UIButton *btnRight = UIButton.new;
    [btnRight setTitle:@"HGW" forState:UIControlStateNormal];
    [btnRight setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    UIButton *btnRight1 = UIButton.new;
    [btnRight1 setTitle:@"R" forState:UIControlStateNormal];
    [btnRight1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithCustomView:btnRight1];
    
    [self.navigationItem setRightBarButtonItems:@[right, right1] animated:true];
    
    [[btnRight rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NHGWebVC *vc = NHGWebVC.new;
        [strongSelf.navigationController pushViewController:vc animated:true];
    }];
    
    [[btnRight1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.webView reload];
    }];
}

- (void)showErrorDialog:(NSError *)error {
    
    if (error.code == -1001 || error.code == -1004) {
        
        NSLog(@"网络连接超时");
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"网络连接超时" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
//            [strongSelf.navigationController popViewControllerAnimated:true];
        }];
        UIAlertAction *retry = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.webView loadRequest:strongSelf.request];
        }];
        [alert addAction:cancel];
        [alert addAction:retry];
        [self.navigationController presentViewController:alert animated:true completion:^{
                    
        }];
        
    }
}

- (WKWebViewConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[WKWebViewConfiguration alloc] init];
        _configuration.allowsAirPlayForMediaPlayback = true;
        
    }
    return _configuration;
}

- (NHGWebView *)webView {
    if (!_webView) {
        _webView = [[NHGWebView alloc] initWithFrame:self.view.bounds configuration:self.configuration vc:self];
    }
    return _webView;
}


@end
