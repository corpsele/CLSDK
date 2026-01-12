//
//  AppDelegate.m
//  HGSDKTest_OC
//
//  Created by  on 2021/8/31.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) UIWindow *mainWindow;

@property (nonatomic, strong) UINavigationController *naviVC;

@property (nonatomic, strong) ViewController *vc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.mainWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = self.mainWindow;
    self.vc = ViewController.new;
    self.naviVC = [[UINavigationController alloc] initWithRootViewController:self.vc];
    self.mainWindow.rootViewController = self.naviVC;
    [self.mainWindow makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"-------沙盒路径------%@",document);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    NSString *tmp = [NSString stringWithFormat:@"%@-InBox", infoDictionary[@"CFBundleIdentifier"]];
    NSString *tmp = [document stringByAppendingFormat:@"/InBox"];
    NSString * folder = [document stringByAppendingPathComponent:@"12312.docx"];
//    NSString *file = [folder stringByAppendingFormat:@"/12312.docx"];
    NSURL *u1 = [NSURL fileURLWithPath:folder];
    NSError *error;
//    [fileManager createDirectoryAtURL:[NSURL URLWithString:tmp] withIntermediateDirectories:true attributes:@{} error:&error];
//    [fileManager copyItemAtURL:url toURL:u1 error:&error];
//    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:^(BOOL success) {
//
//    }];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
       NSString *documentsDirectory = [paths lastObject];
       if (url != nil) {
           NSString *path = [url absoluteString];
           path = [path stringByRemovingPercentEncoding];
           NSMutableString *string = [[NSMutableString alloc] initWithString:path];
           if ([path hasPrefix:@"file:///private"]) {
               [string replaceOccurrencesOfString:@"file:///private" withString:@"" options:NSCaseInsensitiveSearch  range:NSMakeRange(0, path.length)];
           }
           NSArray *tempArray = [string componentsSeparatedByString:@"/"];
           NSString *fileName = tempArray.lastObject;
           NSString *sourceName = options[@"UIApplicationOpenURLOptionsSourceApplicationKey"];
           
           NSFileManager *fileManager = [NSFileManager defaultManager];
//           NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",sourceName,fileName]];
           NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
           if ([fileManager fileExistsAtPath:filePath]) {
               NSLog(@"文件已存在");
//               [SVProgressHUD showErrorWithStatus:@"文件已存在"];
               return YES;
           }
           
//           [MRTools creatFilePathInManager:sourceName];
           BOOL isSuccess = [fileManager copyItemAtPath:string toPath:filePath error:nil];
           if (isSuccess == YES) {
               NSLog(@"拷贝成功");
//               [SVProgressHUD showSuccessWithStatus:@"文件拷贝成功"];
           } else {
               NSLog(@"拷贝失败");
//               [SVProgressHUD showErrorWithStatus:@"文件拷贝失败"];
           }
       }
       NSLog(@"application:openURL:options:");
    return true;
}


@end
