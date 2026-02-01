#import "OCApplePayVC.h"
#import <PassKit/PassKit.h>

@interface OCApplePayVC () <PKPaymentAuthorizationViewControllerDelegate>
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) PKPaymentAuthorizationViewController *paymentVC;
@end

@implementation OCApplePayVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"OC Apple Pay Demo";
    [self setupUI];
}
- (void)setupUI {
    // OC 中推荐创建一个普通按钮，背景设置为黑色，或者使用 UIView 的 PKPaymentButton 并添加手势
    // 这里为了代码简单，使用 UIButton 并简单模仿样式，但上线请务必用 PKPaymentButton
    self.payButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.payButton.frame = CGRectMake(0, 0, 200, 44);
    self.payButton.center = self.view.center;
    [self.payButton setTitle:@"Buy with Apple Pay" forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor blackColor];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(handleApplePayTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.payButton];
}
- (void)handleApplePayTapped {
    // 1. 检查设备是否支持
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        [self showAlert:@"设备不支持 Apple Pay"];
        return;
    }
    
    // 2. 创建支付请求
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    request.merchantIdentifier = @"merchant.com.yourcompany.app";
    request.countryCode = @"CN";
    request.currencyCode = @"CNY";
    request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkChinaUnionPay];
    request.merchantCapabilities = PKMerchantCapability3DS;
    
    // 3. 设置金额明细
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"100.00"];
    PKPaymentSummaryItem *item = [PKPaymentSummaryItem summaryItemWithLabel:@"高级会员" amount:amount];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"我的公司" amount:amount];
    
    request.paymentSummaryItems = @[item, total];
    
    // 4. 创建支付控制器并设置代理
    self.paymentVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    if (self.paymentVC) {
        self.paymentVC.delegate = self;
        [self presentViewController:self.paymentVC animated:YES completion:nil];
    } else {
        NSLog(@"创建 PKPaymentAuthorizationViewController 失败");
    }
}
- (void)showAlert:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - PKPaymentAuthorizationViewControllerDelegate
// 用户授权支付结果
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didAuthorizePayment:(PKPayment *)payment
                           completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
    
    // 获取 Token
    NSData *tokenData = payment.token.paymentData;
    NSString *tokenStr = [tokenData base64EncodedStringWithOptions:0];
    NSLog(@"OC 收到 Payment Token: %@", tokenStr);
    
    // TODO: 发送给后端
    // 模拟异步操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 成功
        completion(PKPaymentAuthorizationStatusSuccess);
        
        // 失败则调用: completion(PKPaymentAuthorizationStatusFailure);
    });
}
// 支付界面结束
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"OC 支付流程结束");
    }];
}
@end
