

#import <Foundation/Foundation.h>

@class UIViewController;
///下载中
typedef void(^FileDownloadingCallBack)(void);
///下载成功
typedef void(^FileDownloadSuccessCallBack)(NSString *filePath);
///下载失败
typedef void(^FileDownloadFailedCallBack)(NSError *error);

///上传中
typedef void(^FileUploadingCallBack)(void);

///上传成功
typedef void(^FileUploadSuccessCallBack)(NSDictionary *dic);

///上传失败
typedef void(^FileUploadFailedCallBack)(NSError *error, NSInteger code, NSString *msg);

///选择文件
typedef void(^SelectFileCallBack)(NSDictionary *dic, NSError *error);

@interface NHGDSDownloadPlugin : NSObject

///初始化插件
///@param vc 父控制器
- (id)initWithVC:(UIViewController *)vc;

///下载中Block 在回调中写下载中逻辑和视图菊花
@property (nonatomic, copy) FileDownloadingCallBack fileDownloadingCallBack;

///下载成功Block 文件下载成功并返回完整路径
@property (nonatomic, copy) FileDownloadSuccessCallBack fileDownloadSuccessCallBack;

///下载失败Block 文件下载失败并返回失败原因
@property (nonatomic, copy) FileDownloadFailedCallBack fileDownloadFailedCallBack;

///上传失败Block 文件上传失败并返回失败原因
@property (nonatomic, copy) FileUploadFailedCallBack fileUploadFailedCallBack;

///上传中Block 在回调中写逻辑和视图菊花
@property (nonatomic, copy) FileUploadingCallBack fileUploadingCallBack;

///上传成功Block 文件上传成功并返回字典
@property (nonatomic, copy) FileUploadSuccessCallBack fileUploadSuccessCallBack;


/// 选择文件Block
@property (nonatomic, copy) SelectFileCallBack selectFileCallBack;

/// 选择文件
/// @param flag 是否显示选择界面
/// @param completeCallBack 选择文件回调
- (void)selectFileShow:(BOOL)flag withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack;

/// 文件上传
/// @param url 文件上传地址
/// @param name 文件名
/// @param type 文件类型
/// @param path 文件路径
/// @param tgc 单一casTgc
/// @param sysname 单一系统名
/// @param completeCallBack 完成回调
- (void)uploadFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withFilePath:(NSString *)path withCasTgc:(NSString *)tgc withSysname:(NSString *)sysname withComplete:(void(^)(NSDictionary *dic, NSError *error, NSString *errorMsg))completeCallBack;

/// 下载并预览文件
/// @param url 文件下载地址
/// @param name 文件名
/// @param type 文件扩展名
/// @param completeCallBack 完成回调
- (void)downloadFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack;

/// jsessionid下载文件
/// @param url 文件下载地址
/// @param name 文件名
/// @param type 文件扩展名
/// @param isPreview 是否预览文件
/// @param sessionId 单一的JSessionId
/// @param completeCallBack 完成回调
- (void)downloadSWFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withIsPreview:(BOOL)isPreview withJSessionId:(NSString *)sessionId withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack;

/// tgc下载文件
/// @param url 文件下载地址
/// @param name 文件名
/// @param type 文件扩展名
/// @param isPreview 是否预览文件
/// @param tgc 单一的tgc
/// @param completeCallBack 完成回调
- (void)downloadSWFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withIsPreview:(BOOL)isPreview withCasTgc:(NSString *)tgc withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack;

/// 下载文件
/// @param url 文件下载地址
/// @param name 文件名
/// @param type 文件扩展名
/// @param isPreview 是否有预览功能
/// @param completeCallBack 完成回调
- (void)downloadFile:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withIsPreview:(BOOL)isPreview withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack;


/// 文件不存在时下载文件并预览文件
/// @param url 文件下载地址
/// @param name 文件名
/// @param type 文件扩展名
/// @param completeCallBack 完成回调
- (void)downloadFileWithExist:(NSString *)url withFileName:(NSString *)name withFileType:(NSString *)type withComplete:(void(^)(NSDictionary *dic, NSError *error))completeCallBack;

/// 设置下载成功回调
/// @param fileDownloadSuccessCallBack 成功回调并返回完成路径
- (void)setDownloadSuccessCallBack:(FileDownloadSuccessCallBack)fileDownloadSuccessCallBack;

/// 设置下载失败回调
/// @param fileDownloadFailedCallBack 失败回调并返回失败原因
- (void)setDownloadFailedCallBack:(FileDownloadFailedCallBack)fileDownloadFailedCallBack;

/// 设置上传成功回调
/// @param fileUploadSuccessCallBack 成功回调并返回完成路径
- (void)setUploadSuccessCallBack:(FileUploadSuccessCallBack)fileUploadSuccessCallBack;

/// 设置上传失败回调
/// @param fileUploadFailedCallBack 失败回调并返回失败原因
- (void)setUploadFailedCallBack:(FileUploadFailedCallBack)fileUploadFailedCallBack;

/// 选择文件回调
/// @param selectFileCallBack 失败回调并返回失败原因
- (void)setSelectCallBack:(SelectFileCallBack)selectFileCallBack;


/// 准备上传
/// @param prepareUploadCallBack 需要的cookie
- (void)setPrepareUploadCallBack:(NSString * (^)(void))prepareUploadCallBack;

/// 打开文件 预览文件
- (void)openPDFWithPath:(NSString *)filePath;

@end


