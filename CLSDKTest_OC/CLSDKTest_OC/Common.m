//
//  Common.m
//  HGSDKTest_OC
//
//  Created by  on 2021/9/10.
//

#import "Common.h"
#import <QuickLook/QuickLook.h>
#import <CommonCrypto/CommonCrypto.h>

@interface Common () <QLPreviewControllerDelegate, UIDocumentInteractionControllerDelegate>

@end

@implementation Common


// MARK：打开预览文件
- (void)openPDFWithPath:(NSString *)filePath{
    
    NSLog(@"下载文件路径------->%@",filePath);
    UIDocumentInteractionController *pdf = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:[filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    NSLog(@"url set = %@", [filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]);
    pdf.delegate = self;
    [pdf presentPreviewAnimated:YES];
    
}

@end
