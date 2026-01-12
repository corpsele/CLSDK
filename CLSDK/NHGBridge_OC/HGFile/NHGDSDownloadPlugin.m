

#import "NHGDSDownloadPlugin.h"
#import <QuickLook/QuickLook.h>
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
#import "Prefix.h"
#import <UIKit/UIKit.h>
#import "NSString+category.h"
#import "JKCategories.h"

@interface NHGDSDownloadPlugin()<UIDocumentInteractionControllerDelegate,QLPreviewControllerDataSource> {
    CGPoint beginPoint;
    CGFloat rightMargin;
    CGFloat leftMargin;
    CGFloat topMargin;
    CGFloat bottomMargin;
    CGMutablePathRef pathRef;
    //单一需要的JSessionID
    NSString *cookieSource;
}

@property(nonatomic,strong)QLPreviewController * qlPreviewVC;
@property(nonatomic,strong)NSMutableArray * filePathArray;
@property(nonatomic,strong)NSMutableURLRequest * uploadRequest;
@property(nonatomic,strong)NSMutableURLRequest * downloadRequest;
///下载过的文件路径
@property (nonatomic, copy)NSString *downloadedFilePath;

/// 文件名
@property (nonatomic, copy) NSString *fileName;
/// 文件类型扩展名
@property (nonatomic, copy) NSString *fileType;

/// 父控制器
@property (nonatomic, weak) UIViewController *vc;


/// 选择文件回调
@property (nonatomic, copy) void(^selectedCallBack)(NSDictionary *dic, NSError *error);

@property (nonatomic, copy) NSString * (^prepareUploadCallBack)(void);

@property (nonatomic, strong) UIButton * selectBtn;

@end

@implementation NHGDSDownloadPlugin

- (id)initWithVC:(UIViewController *)vc {
    if (self == [super init]) {
        self.vc = vc;
    }
    return self;
}

/// MARK: 设置下载成功回调
- (void)setDownloadSuccessCallBack:(FileDownloadSuccessCallBack)fileDownloadSuccessCallBack {
    self.fileDownloadSuccessCallBack = fileDownloadSuccessCallBack;
}

/// MARK: 设置下载失败回调
- (void)setDownloadFailedCallBack:(FileDownloadFailedCallBack)fileDownloadFailedCallBack {
    self.fileDownloadFailedCallBack = fileDownloadFailedCallBack;
}
/// MARK: 设置上传成功回调
- (void)setUploadSuccessCallBack:(FileUploadSuccessCallBack)fileUploadSuccessCallBack {
    self.fileUploadSuccessCallBack = fileUploadSuccessCallBack;
}

/// MARK: 设置上传失败回调
- (void)setUploadFailedCallBack:(FileUploadFailedCallBack)fileUploadFailedCallBack {
    self.fileUploadFailedCallBack = fileUploadFailedCallBack;
}

/// MARK: 选择文件回调
- (void)setSelectCallBack:(SelectFileCallBack)selectFileCallBack {
    self.selectFileCallBack = selectFileCallBack;
}

- (void)setPrepareUploadCallBack:(NSString *(^)(void))prepareUploadCallBack {
    self.prepareUploadCallBack = prepareUploadCallBack;
}


/// MARK: 下载文件
- (void)downloadFileWithExist:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack {
    self.fileName = name;
    self.fileType = type;
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"、" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"，" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"（" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"）" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"。" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"《" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"》" withString:@""];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
    NSString *pinyin = [NSString transform:self.fileName];
    NSString *path = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"%@.%@", pinyin, type]];
    NSLog(@"path = %@, isBlank = %d, fileExist = %d", path, (int)[NSString isBlankString:path], (int)[[NSFileManager defaultManager] fileExistsAtPath:path]);
    if (![NSString isBlankString:path] && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self openPDFWithPath:path];
        if (self.fileDownloadSuccessCallBack) {
            self.fileDownloadSuccessCallBack(path);
        }
        if (completeCallBack) {
            completeCallBack(@{@"filePath": path}, nil);
        }
        return;
    }
    [self downloadFile:url withFileName:name withFileType:type withComplete:completeCallBack];
}

#pragma mark - 下载文件----------------------

- (void)downloadFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack{
    self.fileName = name;
    self.fileType = type;
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"、" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"，" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"（" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"）" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"。" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"《" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"》" withString:@""];
//    [self setJSessionID];
    
    NSString * fileURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
    //默认，请求头中的"User-Agent"
    NSString * userAgent = @"Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3";
    
    self.downloadRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:fileURL parameters:nil error:nil];
    self.downloadRequest.timeoutInterval = 30.f;
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.downloadRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [self.downloadRequest setValue:cookieSource forHTTPHeaderField:@"Cookie"];
    [self.downloadRequest setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    WeakS;
    if (self.fileDownloadingCallBack) {
        self.fileDownloadingCallBack();
    }
    [[manager dataTaskWithRequest:self.downloadRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"response---%@",response);
        StrongS;
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
        if (urlResponse.statusCode == 200 && responseObject) {
            
            NSString * objStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [strongSelf requestDownloadWithManager:manager withIsPreview:true withComplete:completeCallBack];
            if ([objStr hasPrefix:@"<!DOCTYPE html"]) {
                NSString * mess = @"登录信息已过期，请重新登录！";
                NSLog(@"error = %@", mess);
                
                if (strongSelf.fileDownloadFailedCallBack) {
                    NSDictionary *dic = @{@"msg": @"登录信息已过期，请重新登录！"};
                    NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:-555 userInfo:dic];
                    strongSelf.fileDownloadFailedCallBack(err);
                }
//                if (completeCallBack) {
//                    completeCallBack(nil, error);
//                }
            }
        }
        
    }] resume];
    
    __weak __typeof(manager)weakManager = manager;
    
    //请求重定向
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request){
        if (request) {
            
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"urlResponse:--%@",urlResponse);
            if ([urlResponse.URL.absoluteString containsString:@"?ticket="]) {
                
                NSString * cookieString = [[urlResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                
                //替换Cookie
                [self.downloadRequest setValue:cookieString forHTTPHeaderField:@"Cookie"];
                
                __strong __typeof(weakManager)strongManager = weakManager;
                
                //获得cookie，重新请求
                [self requestDownloadWithManager:strongManager withIsPreview:true withComplete:completeCallBack];
                
                return nil;
            }
            return request;
        }
        
        return nil;
    }];
}

// MARK: 下载文件 是否有预览功能
- (void)downloadFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withIsPreview:(BOOL)isPreview withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack{
    self.fileName = name;
    self.fileType = type;
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"、" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"，" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"（" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"）" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"。" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"(" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"《" withString:@""];
    self.fileName = [self.fileName stringByReplacingOccurrencesOfString:@"》" withString:@""];
//    [self setJSessionID];
    
    NSString * fileURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
    //默认，请求头中的"User-Agent"
    NSString * userAgent = @"Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3";
    
    self.downloadRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:fileURL parameters:nil error:nil];
    self.downloadRequest.timeoutInterval = 30.f;
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.downloadRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [self.downloadRequest setValue:cookieSource forHTTPHeaderField:@"Cookie"];
    [self.downloadRequest setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    WeakS;
    if (self.fileDownloadingCallBack) {
        self.fileDownloadingCallBack();
    }
    [[manager dataTaskWithRequest:self.downloadRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"response---%@",response);
        StrongS;
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
        if (urlResponse.statusCode == 200 && responseObject) {
            
            NSString * objStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [strongSelf requestDownloadWithManager:manager withIsPreview:isPreview withComplete:completeCallBack];
            if ([objStr hasPrefix:@"<!DOCTYPE html"]) {
                NSString * mess = @"登录信息已过期，请重新登录！";
                NSLog(@"error = %@", mess);
                
                if (strongSelf.fileDownloadFailedCallBack) {
                    NSDictionary *dic = @{@"msg": @"登录信息已过期，请重新登录！"};
                    NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:-555 userInfo:dic];
                    strongSelf.fileDownloadFailedCallBack(err);
                }
//                if (completeCallBack) {
//                    completeCallBack(nil, error);
//                }
            }
        }
        
    }] resume];
    
    __weak __typeof(manager)weakManager = manager;
    
    //请求重定向
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request){
        if (request) {
            
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"urlResponse:--%@",urlResponse);
            if ([urlResponse.URL.absoluteString containsString:@"?ticket="]) {
                
                NSString * cookieString = [[urlResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                
                //替换Cookie
                [self.downloadRequest setValue:cookieString forHTTPHeaderField:@"Cookie"];
                
                __strong __typeof(weakManager)strongManager = weakManager;
                
                //获得cookie，重新请求
                [self requestDownloadWithManager:strongManager withIsPreview:isPreview withComplete:completeCallBack];
                
                return nil;
            }
            return request;
        }
        
        return nil;
    }];
}

// MARK: jsessionid下载单一文件
- (void)downloadSWFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withIsPreview:(BOOL)isPreview withJSessionId:(NSString *)sessionId withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack {
    [self setJSessionID:sessionId];
    //默认，请求头中的"User-Agent"
    NSString * userAgent = @"Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3";
    
    self.downloadRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    self.downloadRequest.timeoutInterval = 30.f;
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.downloadRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [self.downloadRequest setValue:sessionId forHTTPHeaderField:@"Cookie"];
    [self.downloadRequest setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    NSLog(@"downloadSWFile start dataTaskWithRequest");
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (self.fileDownloadingCallBack) {
        self.fileDownloadingCallBack();
    }
    WeakS;
    [[manager dataTaskWithRequest:self.downloadRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"jsessionid dataTaskWithRequest response---%@",response);
        StrongS;
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
        if (urlResponse.statusCode == 200 && responseObject) {
            
            NSString * objStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [strongSelf requestDownloadWithManager:manager withIsPreview:isPreview withComplete:completeCallBack];
            if ([objStr hasPrefix:@"<!DOCTYPE html"]) {
                NSString * mess = @"登录信息已过期，请重新登录！";
                if (strongSelf.fileDownloadFailedCallBack) {
                    NSDictionary *dic = @{@"msg": @"登录信息已过期，请重新登录！"};
                    NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:-555 userInfo:dic];
                    strongSelf.fileDownloadFailedCallBack(err);
                }
//                if (completeCallBack) {
//                    completeCallBack(nil, error);
//                }
            }
        }else{
            if (urlResponse.statusCode != 302) {
                if (completeCallBack) {
                    completeCallBack(nil, error);
                }
            }
        }
        
    }] resume];
    
    __weak __typeof(manager)weakManager = manager;
    
    //请求重定向
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request){
        if (request) {
            
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"jsessionid setTaskWillPerformHTTPRedirectionBlock urlResponse:--%@",urlResponse);
//            if (urlResponse.statusCode == 302) {
            if ([urlResponse.URL.absoluteString containsString:@"?ticket="]) {
                
                NSString * cookieString = [[urlResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                
                //替换Cookie
                [self.downloadRequest setValue:cookieString forHTTPHeaderField:@"Cookie"];
                
                __strong __typeof(weakManager)strongManager = weakManager;
                
                //获得cookie，重新请求
                [self requestDownloadWithManager:strongManager withIsPreview:isPreview withComplete:completeCallBack];
                
                return nil;
            }
            return request;
        }
        
        return nil;
    }];
}

// MARK: tgc下载单一文件
- (void)downloadSWFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withIsPreview:(BOOL)isPreview withCasTgc:(NSString *)tgc withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack {
    //请求的Cookie值，登陆信息中的casTgc
    NSString * casTgc = tgc;
    //默认，请求头中的"User-Agent"
    NSString * userAgent = @"Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3";
    
    self.downloadRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    self.downloadRequest.timeoutInterval = 30.f;
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.downloadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.downloadRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [self.downloadRequest setValue:casTgc forHTTPHeaderField:@"Cookie"];
    [self.downloadRequest setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (self.fileDownloadingCallBack) {
        self.fileDownloadingCallBack();
    }
    WeakS;
    [[manager dataTaskWithRequest:self.downloadRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"dataTaskWithRequest response---%@",response);
        StrongS;
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
        if (urlResponse.statusCode == 200 && responseObject) {
            
            NSString * objStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [strongSelf requestDownloadWithManager:manager withIsPreview:isPreview withComplete:completeCallBack];
            if ([objStr hasPrefix:@"<!DOCTYPE html"]) {
                NSString * mess = @"登录信息已过期，请重新登录！";
                if (strongSelf.fileDownloadFailedCallBack) {
                    NSDictionary *dic = @{@"msg": @"登录信息已过期，请重新登录！"};
                    NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:-555 userInfo:dic];
                    strongSelf.fileDownloadFailedCallBack(err);
                }
//                if (completeCallBack) {
//                    completeCallBack(nil, error);
//                }
            }
        }else{
            if (urlResponse.statusCode != 302) {
                if (completeCallBack) {
                    completeCallBack(nil, error);
                }
            }
        }
        
    }] resume];
    
    __weak __typeof(manager)weakManager = manager;
    
    //请求重定向
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request){
        if (request) {
            NSLog(@"setTaskWillPerformHTTPRedirectionBlock request = %@", request);
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
            
            NSLog(@"urlResponse:--%@",urlResponse);
            if ([urlResponse.URL.absoluteString containsString:@"?ticket="]) {
                
                NSString * cookieString = [[urlResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                
                //替换Cookie
                [self.downloadRequest setValue:cookieString forHTTPHeaderField:@"Cookie"];
                
                __strong __typeof(weakManager)strongManager = weakManager;
                
                //获得cookie，重新请求
                [self requestDownloadWithManager:strongManager withIsPreview:isPreview withComplete:completeCallBack];
                
                return nil;
            }
            return request;
        }
        
        return nil;
    }];
}


// MARK: 请求文件下载时的单一服务器 需传cookie jsessionid
- (void)setJSessionID:(NSString *)sessionIdList {
    //单一应用cookie，登录后请求获取，退出登录时清除
    if (sessionIdList) {
        NSLog(@"sessionIdList = %@", sessionIdList);
        NSData * sessionData = [sessionIdList dataUsingEncoding:NSUTF8StringEncoding];
        NSArray * sessionArray = [NSJSONSerialization JSONObjectWithData:sessionData options:0 error:nil];
        for (NSDictionary * temDic in sessionArray) {
            NSString * keyValue = [[temDic allValues] firstObject];
                cookieSource = keyValue;
                break;
        }
    }
}

//重定向之后，再次请求下载接口
- (void)requestDownloadWithManager:(AFHTTPSessionManager *)manager withIsPreview:(BOOL)isPreview withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack{
    NSLog(@"requestDownloadWithManager");
    @try {
        [manager.securityPolicy setAllowInvalidCertificates:YES];
        [manager.securityPolicy setValidatesDomainName:NO];
        WeakS;
        NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:self.downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"download progress %lld,%lld",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            StrongS;
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
            NSLog(@"urlResponse.URL = %@ response = %@", urlResponse.URL.absoluteString, response);
            if (urlResponse.statusCode != 200 || [urlResponse.URL.absoluteString containsString:@"cas/login"]){
                NSString * mess = @"下载失败";
                NSLog(@"error = %@", mess);
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:urlResponse.statusCode userInfo:@{@"url": urlResponse.URL.absoluteString}];
                if (strongSelf.fileDownloadFailedCallBack) {
                    strongSelf.fileDownloadFailedCallBack(error);
                }
                if (completeCallBack) {
                    completeCallBack(nil, error);
                }
                return nil;
            }
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths lastObject];
            documentsDirectory = [documentsDirectory stringByAppendingString:@"/"];
            NSString *extens = [strongSelf.downloadRequest.URL pathExtension];
            //获取文件类型
            NSString * fileType = @"";
            if (strongSelf.fileType && strongSelf.fileType.length > 0) {
                fileType = strongSelf.fileType;
                NSLog(@"download fileType = %@", fileType);
            }else{
//                if (extens && extens.length > 0) {
//                    fileType = extens;
//                    NSLog(@"download extens fileType = %@", fileType);
//                }else{
                    @try {
                        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
                        NSString * ContentTypeStr = [[urlResponse allHeaderFields] valueForKey:@"Content-Type"];
                        NSLog(@"ContentTypeStr = %@", ContentTypeStr);
                        if ([ContentTypeStr isEqualToString:@"application/octet-stream;charset=UTF-8"]) {
                            fileType = @"pdf";//数据流形式，默认pdf
                        }
                        else if ([ContentTypeStr isEqualToString:@"application/octet-stream"]) {
                            fileType = @"doc";
                        }
                        else if ([ContentTypeStr isEqualToString:@"application/x-download;charset=UTF-8"]) {
                            fileType = @"pdf";
                        }
                        else if ([ContentTypeStr isEqualToString:@"application/pdf;charset=UTF-8"]) {
                            fileType = @"pdf";
                        }
//                        else if ([ContentTypeStr containsString:@"application/json"]){
//                            NSString * mess = @"下载失败";
//                            NSLog(@"error = %@", mess);
//                            NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:urlResponse.statusCode userInfo:@{@"url": urlResponse.URL.absoluteString, @"contentType": ContentTypeStr}];
//                            if (strongSelf.fileDownloadFailedCallBack) {
//                                strongSelf.fileDownloadFailedCallBack(error);
//                            }
//                            if (completeCallBack) {
//                                completeCallBack(nil, error);
//                            }
//                            return nil;
//                        }
                        else{
                            NSArray * strArray0 = [ContentTypeStr componentsSeparatedByString:@"/"];
                            NSArray * strArray1 = [strArray0[1] componentsSeparatedByString:@";"];
                            fileType = strArray1[0];
                        }
                    } @catch (NSException *exception) {
                        fileType = @"pdf";
                    } @finally {}
                    NSLog(@"download fileType = %@", fileType);
//                }
            }
            NSString *pinyin = @"";
            if (strongSelf.fileName && strongSelf.fileName.length > 0) {
                pinyin = [NSString transform:strongSelf.fileName];
            }
            
//            NSString *path = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"%@.%@",[strongSelf getNowTimeTimestamp],fileType]];
            NSString *path = @"";
            if (strongSelf.fileName && strongSelf.fileName.length > 0) {
                path = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"%@.%@", pinyin, fileType]];
            }else{
                path = [documentsDirectory stringByAppendingString:[NSString stringWithFormat:@"%@.%@",[strongSelf getNowTimeTimestamp],fileType]];
            }
            
            NSLog(@"文件路径----->%@",path);
            return [NSURL fileURLWithPath:path];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            @try {
                StrongS;
                NSLog(@"response response = %@", response);
                if (![filePath isKindOfClass:[NSURL class]]) {
                    NSString *mess = @"文件下载失败";
                    NSLog(@"error = %@", mess);
                    if (strongSelf.fileDownloadFailedCallBack) {
                        strongSelf.fileDownloadFailedCallBack(error);
                    }
                    return;
                }
                
            NSString * filesize = [NSString stringWithFormat:@"%llu",[self fileSizeAtPath:[filePath path]]];
            if (!error && [filesize integerValue] > 0) {
                
                NSString * downPath = [filePath path];
                strongSelf.downloadedFilePath = downPath;
                NSLog(@"downPath = %@", strongSelf.downloadedFilePath);
//                [[NSUserDefaults standardUserDefaults] setObject:downPath forKey:@""];
                // json文件
                if ([downPath containsString:@".json"] || [downPath containsString:@".txt"]) {
                    NSFileManager *manager = NSFileManager.defaultManager;
                    NSData *data = [manager contentsAtPath:strongSelf.downloadedFilePath];
                    NSString *strError = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                    NSDictionary *tmpDic = strError.jk_dictionaryValue;
                    NSString *errCode = tmpDic[@"errCode"];
                    NSString *errMsg = tmpDic[@"errMsg"];
                    NSLog(@"read file strError = %@ tmpDic = %@", strError, tmpDic);
                    if (strongSelf.fileDownloadFailedCallBack) {
                        NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:errCode.intValue userInfo:@{@"msg": errMsg}];
                        strongSelf.fileDownloadFailedCallBack(err);
                    }
                    if (completeCallBack) {
                        NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:errCode.intValue userInfo:@{@"msg": errMsg}];
                        completeCallBack(nil, err);
                    }
                    return;
                }
                if (isPreview) {
                    [strongSelf openPDFWithPath:downPath];
                }
                if (strongSelf.fileDownloadSuccessCallBack) {
                    strongSelf.fileDownloadSuccessCallBack(downPath);
                }
                if (completeCallBack) {
                    completeCallBack(@{@"filePath": filePath}, error);
                }
            }else{
                NSString *mess = @"文件下载失败";
                NSLog(@"error = %@", mess);
                NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:@{@"msg": mess}];
                if (strongSelf.fileDownloadFailedCallBack) {
                    strongSelf.fileDownloadFailedCallBack(err);
                }
                if (completeCallBack) {
                    completeCallBack(nil, err);
                }
            }
                    
            } @catch (NSException *exception) {
                StrongS;
                NSString *mess = @"文件下载失败";
                NSLog(@"error = %@", mess);
                NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:-1 userInfo:exception.userInfo];
                if (strongSelf.fileDownloadFailedCallBack) {
                    strongSelf.fileDownloadFailedCallBack(err);
                }
                if (completeCallBack) {
                    completeCallBack(nil, err);
                }
            } @finally {
                
            }
        }];
        [task resume];
        
    } @catch (NSException *exception) {
        
        NSLog(@"exception---%@",exception);
        NSString *mess = @"文件下载失败";
        NSLog(@"error = %@", mess);
        NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:-1 userInfo:exception.userInfo];
        if (self.fileDownloadFailedCallBack) {
            self.fileDownloadFailedCallBack(error);
        }
        if (completeCallBack) {
            completeCallBack(nil, error);
        }
    } @finally {
        
    }
}

// MARK：打开预览文件
- (void)openPDFWithPath:(NSString *)filePath{
    
    NSLog(@"下载文件路径------->%@",filePath);
    UIDocumentInteractionController *pdf = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    NSLog(@"url set = %@", [filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
    pdf.delegate = self;
    [pdf presentPreviewAnimated:YES];
    
}

- (NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}


#pragma mark - 打开文件----------------------

- (void)selectFileShow:(BOOL)flag withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack{
    self.selectedCallBack = completeCallBack;
    
    //得到沙盒文件夹 下的所有文件
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSString * document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"-------沙盒路径------%@",document);
    NSString *tmpDir = NSTemporaryDirectory();
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *tmp = [NSString stringWithFormat:@"%@-InBox", infoDictionary[@"CFBundleIdentifier"]];
    NSString *tmpFolder = [tmpDir stringByAppendingFormat:@"%@", tmp];
    NSError *error;
    NSString * folder = [document stringByAppendingPathComponent:@"Inbox"];
    NSArray * fileList = [fileManager contentsOfDirectoryAtPath:folder error:NULL];
    
    self.filePathArray = [NSMutableArray array];
    for (NSString *file in fileList) {
        //把查询到的文件路径存入数组
        NSString *path =[folder stringByAppendingPathComponent:file];
        if ([file containsString:@".DS_Store"]) {
            continue;
        }
        [self.filePathArray addObject:path];
    }
    
    NSArray * tmpList = [fileManager contentsOfDirectoryAtPath:document error:&error];
    for (NSString *file in tmpList) {
        //把查询到的文件路径存入数组
        NSString *path =[document stringByAppendingPathComponent:file];
        if ([file containsString:@".DS_Store"]) {
            continue;
        }
        [self.filePathArray addObject:path];
    }
    if (!flag) {
        return;
    }
    self.qlPreviewVC = [[QLPreviewController alloc]init];
    self.qlPreviewVC.dataSource = self;
    self.qlPreviewVC.view.userInteractionEnabled = true;
//    self.qlPreviewVC.view.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.vc.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - ([UIApplication sharedApplication].statusBarFrame.size.height + self.vc.navigationController.navigationBar.frame.size.height));

//    UIViewController * top = [HGCommonMethod getCurrentViewController];
    
    //添加选择文件按钮
    [self setSelectButton];
    
    [self.vc.navigationController pushViewController:self.qlPreviewVC animated:YES];
//    [self.vc presentViewController:self.qlPreviewVC animated:true completion:^{
//
//    }];
    
    
}


// MARK: 创建选择按钮
- (void)setSelectButton{
    
    self.selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.vc.view.frame.size.width-110, 120, 80, 80)];
    [self.selectBtn setTitle:[NSString stringWithFormat:@"选择\n当前文件"] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.numberOfLines = 0;
    self.selectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectBtn setTitleColor:BLUE_COLOUR forState:UIControlStateNormal];
    self.selectBtn.backgroundColor = BASE_COLOUR;
    self.selectBtn.layer.borderWidth = 10;
    self.selectBtn.layer.borderColor = LIGHT_GRAY_COLOUR.CGColor;
    self.selectBtn.layer.cornerRadius = self.selectBtn.frame.size.width/2;
    self.selectBtn.clipsToBounds = YES;
    self.selectBtn.userInteractionEnabled = true;
    [self.selectBtn addTarget:self action:@selector(getPathBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.qlPreviewVC.view addSubview:self.selectBtn];
//    [UIApplication.sharedApplication.keyWindow addSubview:self.selectBtn];
    
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
    [self.selectBtn addGestureRecognizer:panGestureRecognizer];
    
    rightMargin = [UIScreen mainScreen].bounds.size.width-self.selectBtn.frame.size.width/2.0;
    leftMargin = self.selectBtn.frame.size.width/2.0;
    bottomMargin = [UIScreen mainScreen].bounds.size.height-self.selectBtn.frame.size.height/2.0-44;
    topMargin = self.selectBtn.frame.size.height/2.0+64;
    
    pathRef=CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, NULL, leftMargin, topMargin);
    CGPathAddLineToPoint(pathRef, NULL, rightMargin, topMargin);
    CGPathAddLineToPoint(pathRef, NULL, rightMargin, bottomMargin);
    CGPathAddLineToPoint(pathRef, NULL, leftMargin, bottomMargin);
    CGPathAddLineToPoint(pathRef, NULL, leftMargin, topMargin);
    CGPathCloseSubpath(pathRef);

}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return self.filePathArray.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    NSURL * url = [NSURL fileURLWithPath:self.filePathArray[index]];
    return url;
}

//选择文件点击
- (void)getPathBack:(id)sender{

    if (self.filePathArray.count > self.qlPreviewVC.currentPreviewItemIndex) {
        
        NSString * currentPath = self.filePathArray[self.qlPreviewVC.currentPreviewItemIndex];
        NSLog(@"-------上传------%@",currentPath);
        NSFileManager* fm = [NSFileManager defaultManager];
        NSData* data = [[NSData alloc] init];
        data = [fm contentsAtPath:currentPath];
        NSString *contentStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//        contentStr = contentStr jk_ut
//        contentStr = contentStr
//        NSLog(@"contentStr = %@", contentStr);
        NSArray * strArray = [currentPath componentsSeparatedByString:@"/"];
        NSLog(@"strArray = %@", strArray);
        NSString *strFileName = [currentPath lastPathComponent];
        NSDictionary * resultDic = @{@"fileName":strFileName ? strFileName : @"",
                                     @"fileSize":[NSString stringWithFormat:@"%llu",[self fileSizeAtPath:currentPath]],
                                     @"fileUrl":currentPath,@"fileType":[currentPath pathExtension],@"fileContent":contentStr};
//        CDVPluginResult * result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:
//                                    [HGCommonMethod dictionaryToJson:resultDic]];
        if(self.selectedCallBack) {
            self.selectedCallBack(resultDic, nil);
        }
        if(self.selectFileCallBack) {
            self.selectFileCallBack(resultDic, nil);
        }
    }
    [self.qlPreviewVC.navigationController popViewControllerAnimated:YES];
}

// 创建选择按钮
//- (void)setSelectButton{
//
//    selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.viewController.view.frame.size.width-110, 120, 80, 80)];
//    [selectBtn setTitle:[NSString stringWithFormat:@"选择\n当前文件"] forState:UIControlStateNormal];
//    selectBtn.titleLabel.numberOfLines = 0;
//    selectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [selectBtn setTitleColor:BLUE_COLOUR forState:UIControlStateNormal];
//    selectBtn.backgroundColor = BASE_COLOUR;
//    selectBtn.layer.borderWidth = 10;
//    selectBtn.layer.borderColor = LIGHT_GRAY_COLOUR.CGColor;
//    selectBtn.layer.cornerRadius = selectBtn.frame.size.width/2;
//    selectBtn.clipsToBounds = YES;
//    [selectBtn addTarget:self action:@selector(getPathBack) forControlEvents:UIControlEventTouchUpInside];
//    [self.qlPreviewVC.view addSubview:selectBtn];
//
//    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doHandlePanAction:)];
//    [selectBtn addGestureRecognizer:panGestureRecognizer];
//
//    rightMargin = [UIScreen mainScreen].bounds.size.width-selectBtn.frame.size.width/2.0;
//    leftMargin = selectBtn.frame.size.width/2.0;
//    bottomMargin = [UIScreen mainScreen].bounds.size.height-selectBtn.frame.size.height/2.0-44;
//    topMargin = selectBtn.frame.size.height/2.0+64;
//
//    pathRef=CGPathCreateMutable();
//    CGPathMoveToPoint(pathRef, NULL, leftMargin, topMargin);
//    CGPathAddLineToPoint(pathRef, NULL, rightMargin, topMargin);
//    CGPathAddLineToPoint(pathRef, NULL, rightMargin, bottomMargin);
//    CGPathAddLineToPoint(pathRef, NULL, leftMargin, bottomMargin);
//    CGPathAddLineToPoint(pathRef, NULL, leftMargin, topMargin);
//    CGPathCloseSubpath(pathRef);
//}
//按钮拖动事件
- (void) doHandlePanAction:(UIPanGestureRecognizer *)pan{
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        beginPoint = [pan locationInView:self.qlPreviewVC.view];
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        CGPoint nowPoint = [pan locationInView:self.qlPreviewVC.view];
        float offsetX = nowPoint.x - beginPoint.x;
        float offsetY = nowPoint.y - beginPoint.y;
        CGPoint centerPoint = CGPointMake(beginPoint.x + offsetX, beginPoint.y + offsetY);
        
        if (CGPathContainsPoint(pathRef, NULL, centerPoint, NO)){
            self.selectBtn.center = centerPoint;
        }else{
            if (centerPoint.y>bottomMargin){
                if (centerPoint.x<rightMargin&centerPoint.x>leftMargin) {
                    self.selectBtn.center = CGPointMake(beginPoint.x + offsetX, bottomMargin);
                }
            }else if (centerPoint.y<topMargin){
                if (centerPoint.x<rightMargin&centerPoint.x>leftMargin) {
                    self.selectBtn.center = CGPointMake(beginPoint.x + offsetX, topMargin);
                }
            }else if (centerPoint.x>rightMargin){
                self.selectBtn.center = CGPointMake(rightMargin, beginPoint.y + offsetY);
            }else if (centerPoint.x<leftMargin){
                self.selectBtn.center = CGPointMake(leftMargin, beginPoint.y + offsetY);
            }
        }
    }else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed){
    }
}

#pragma mark - 上传文件----------------------

// MARK: 调取上传文件接口
- (void)uploadFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withFilePath:(NSString *)path withCasTgc:(NSString *)tgc withSysname:(NSString *)sysname withComplete:(void(^)(NSDictionary *dic, NSError *error, NSString *errorMsg))completeCallBack{
    NSDictionary *tmp = @{@"fileName":name,
                          @"fileSize":[NSString stringWithFormat:@"%llu",[self fileSizeAtPath:path]],
                          @"fileUrl":path};
    NSLog(@"uploadFile tmp = %@", tmp);
    if (url == nil || url.length < 1) {
        completeCallBack(tmp, nil, @"url不能为空");
        NSLog(@"uploadFile url == nil or empty return");
        return;
    }
    WeakS;
    //请求的Cookie值，登陆信息中的casTgc
    NSString * casTgc = tgc;
    
    //默认，请求头中的"User-Agent"
    NSString * userAgent = @"Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3";
    
    //文件大小
    NSString * filesize = [NSString stringWithFormat:@"%llu",[self fileSizeAtPath:path]];
    if (1024*1024*4 < [filesize integerValue]) {
        NSString * mess = @"文件过大，请重新选择文件（暂只支持上传4M以下的文件）";
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:mess forKey:@"msg"];
        NSError *err = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:dic];
        completeCallBack(tmp, err, mess);
        NSLog(@"文件过大，请重新选择文件（暂只支持上传4M以下的文件）上传失败 return");
        if (self.fileUploadFailedCallBack) {
            self.fileUploadFailedCallBack(err, -1, mess);
        }
        return;
    }
    //文件名称
    NSArray * pathArray = [path componentsSeparatedByString:@"/"];
    NSString * oriFileName = [pathArray lastObject];
    //文件类型
    NSArray * fileNameArray = [oriFileName componentsSeparatedByString:@"."];
    NSString * fileType = [fileNameArray lastObject];
    //文件的数据流
    NSData * fileData = [NSData dataWithContentsOfFile:path];
    
    self.uploadRequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    self.uploadRequest.timeoutInterval = 30.f;
    self.uploadRequest.HTTPBody = fileData;
    [self.uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.uploadRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.uploadRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    [self.uploadRequest setValue:@"0" forHTTPHeaderField:@"offset"];
    [self.uploadRequest setValue:filesize forHTTPHeaderField:@"datasize"];
    [self.uploadRequest setValue:filesize forHTTPHeaderField:@"filesize"];
    [self.uploadRequest setValue:@"" forHTTPHeaderField:@"data"];
    [self.uploadRequest setValue:@"Y" forHTTPHeaderField:@"isSaveExp"];
    [self.uploadRequest setValue:@"1001" forHTTPHeaderField:@"fn"];
    [self.uploadRequest setValue:@"Y" forHTTPHeaderField:@"replace"];
    [self.uploadRequest setValue:[self sha1withData:fileData] forHTTPHeaderField:@"hash"];
    [self.uploadRequest setValue:fileType forHTTPHeaderField:@"fileType"];
    [self.uploadRequest setValue:[NSString stringWithFormat:@".%@",fileType] forHTTPHeaderField:@"oriFileName"];
    [self.uploadRequest setValue:sysname forHTTPHeaderField:@"sysname"]; //业务子系统名称 (如：dec)
    [self.uploadRequest setValue:casTgc forHTTPHeaderField:@"Cookie"];
    NSLog(@"uploadfile castgc = %@", casTgc);
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"updateFile dataTaskWithRequest");
    [[manager dataTaskWithRequest:self.uploadRequest uploadProgress:^(NSProgress *uploadProgress) {
        StrongS;
        if (strongSelf.fileUploadingCallBack) {
            strongSelf.fileUploadingCallBack();
        }
    } downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"response---%@",response);
        StrongS;
        NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
        if (urlResponse.statusCode == 200 && responseObject) {
            
            NSString * objStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            objStr = [objStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([objStr hasPrefix:@"<!DOCTYPE html>"]) {
                NSString * mess = @"登录信息已过期，请重新登录！";
                NSMutableDictionary *dic = error.userInfo;
                [dic setObject:mess forKey:@"msg"];
                NSError *tmp = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:dic];
                NSLog(@"uploadfile 登录信息已过期，请重新登录！ 上传失败");
                if (strongSelf.fileUploadFailedCallBack) {
                    strongSelf.fileUploadFailedCallBack(tmp, -1, mess);
                }
                if (completeCallBack) {
                    completeCallBack(nil, tmp, mess);
                }
            }
        }
    }] resume];
    
    __weak __typeof(manager)weakManager = manager;
    
    //请求重定向
    [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest * _Nonnull(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLResponse * _Nonnull response, NSURLRequest * _Nonnull request){
        StrongS;
        NSLog(@"uploadFile setTaskWillPerformHTTPRedirectionBlock request = %@", request);
        if (request) {
            NSHTTPURLResponse * urlResponse = (NSHTTPURLResponse *)response;
            NSLog(@"uploadFile setTaskWillPerformHTTPRedirectionBlock response =%@ ", response.URL);
            if ([urlResponse.URL.absoluteString containsString:@"?ticket="]) {
                
                NSString * cookieString = [[urlResponse allHeaderFields] valueForKey:@"Set-Cookie"];
                
                //替换Cookie
                [self.uploadRequest setValue:cookieString forHTTPHeaderField:@"Cookie"];
                
                __strong __typeof(weakManager)strongManager = weakManager;
                
                //获得cookie，重新请求
                [self requestUploadWithManager:strongManager withComplete:completeCallBack];
                
                return nil;
            }else{
                NSLog(@"uploadfile setTaskWillPerformHTTPRedirectionBlock url not contains ?ticket= 无法重新获取cookie");
                
                NSError *tmp = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:@{@"msg": @"重定向获取不到cookie"}];
                NSString *mess = @"重定向获取不到cookie";
                if (strongSelf.fileUploadFailedCallBack) {
                    strongSelf.fileUploadFailedCallBack(tmp, -1, mess);
                }
//                if (completeCallBack) {
//                    completeCallBack(nil, tmp, mess);
//                }
            }
            return request;
        }
        return nil;
    }];
}

//重定向之后，再次请求上传接口
- (void)requestUploadWithManager:(AFHTTPSessionManager *)manager withComplete:(void(^)(NSDictionary *dic, NSError *error, NSString *msg))completeCallBack{
    WeakS;
    @try {
        [manager.securityPolicy setAllowInvalidCertificates:YES];
        [manager.securityPolicy setValidatesDomainName:NO];
        NSLog(@"requestUploadWithManager dataTaskWithRequest");
        NSURLSessionDataTask * task = [manager dataTaskWithRequest:self.uploadRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            StrongS;
            NSLog(@"requestUploadWithManager dataTaskWithRequest error = %@", error);
            if (!error) {
                NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
                NSDictionary * headerFields = [r allHeaderFields];
                NSLog(@"headerFields---%@",headerFields);
                //信息 retmessage; retcode 000为成功; 文件的名 retFileId
                NSString * retmessage = [self encodeMessage:headerFields[@"retmessage"]]?:@"";
                NSString * retcode = headerFields[@"retcode"]?:@"";
                NSString * retFileId = headerFields[@"retFileId"]?:@"";
                NSLog(@"retmessage---%@",retmessage);
                
                if ([retcode isEqualToString:@"000"]) {
                    NSDictionary * successDic = @{@"msg":@"上传成功",
                                                  @"retFileId":retFileId,
                                                  @"code":retcode};
                    if (strongSelf.fileUploadSuccessCallBack) {
                        strongSelf.fileUploadSuccessCallBack(successDic);
                    }
                    if (completeCallBack) {
                        completeCallBack(successDic, error, @"上传成功");
                    }
                }else{
                    NSLog(@"上传失败");
                    NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:headerFields];
                    if (strongSelf.fileUploadFailedCallBack) {
                        strongSelf.fileUploadFailedCallBack(error, -1, error.localizedDescription);
                    }
                    if (completeCallBack) {
                        completeCallBack(nil, error, error.localizedDescription);
                    }
                }
                
            } else {
                NSLog(@"error=%@", error);
                if (strongSelf.fileUploadFailedCallBack) {
                    strongSelf.fileUploadFailedCallBack(error, -1, error.localizedDescription);
                }
                if (completeCallBack) {
                    completeCallBack(nil, error, error.localizedDescription);
                }
            }
        }];
        [task resume];
        
    } @catch (NSException *exception) {
        StrongS;
        NSLog(@"exception---%@",exception);
        if (strongSelf.fileUploadFailedCallBack) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:exception.userInfo];
            strongSelf.fileUploadFailedCallBack(error, -1, error.localizedDescription);
        }
        if (completeCallBack) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:-1 userInfo:exception.userInfo];
            completeCallBack(nil, error, error.localizedDescription);
        }
    } @finally {
    }
}

//---------------------------------------------------------------------------------------------

//用于获取本地文件的大小
- (unsigned long long)fileSizeAtPath:(NSString *)filePath {
    unsigned long long fileSize = 0;
    NSFileManager *dfm = [NSFileManager defaultManager];
    if ([dfm fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSDictionary *attributes = [dfm attributesOfItemAtPath:filePath error:&error];
        if (!error && attributes) {
            fileSize = attributes.fileSize;
        } else if (error) {
            NSLog(@"error: %@", error);
        }
    }
    return fileSize;
}

//SHA1安全哈希算法
- (NSString*)sha1withData:(NSData *)data{
    
    //NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return [output lowercaseString];
}

//用iso-8859-1解码，再用gbk编码
- (NSString *)encodeMessage:(NSString *)message{
    if (!message) {
        return message;
    }
    //ISO-8859-1格式接收数据并进行转换
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    NSData * resultData = [message dataUsingEncoding:enc];
    
    //GBK编码
    NSStringEncoding encGBK = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString * encodeStr = [[NSString alloc] initWithBytes:[resultData bytes] length:[resultData length] encoding:encGBK];
    
    return encodeStr;
}

// MARK: 请求文件下载时的单一服务器 需传cookie jsessionid
//- (void)setJSessionID {
//    //单一应用cookie，登录后请求获取，退出登录时清除
//    if (HGUserDefault.sessionIdList) {
//        NSLog(@"HGUserDefault.sessionIdList = %@", HGUserDefault.sessionIdList);
//        NSData * sessionData = [HGUserDefault.sessionIdList dataUsingEncoding:NSUTF8StringEncoding];
//        NSArray * sessionArray = [NSJSONSerialization JSONObjectWithData:sessionData options:0 error:nil];
//        for (NSDictionary * temDic in sessionArray) {
//            NSString * keyValue = [[temDic allValues] firstObject];
//                cookieSource = keyValue;
//                break;
//        }
//    }
//}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self.vc;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"hidden"];
}

@end
