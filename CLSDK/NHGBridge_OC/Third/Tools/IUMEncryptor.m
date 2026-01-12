//
//  IUMEncryptor.m
//  IUMCore
//
//  Created by Chenly on 2016/11/1.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import "IUMEncryptor.h"
#import <CommonCrypto/CommonCryptor.h>
#include "SM4Code.h"

size_t const kKeySize = kCCKeySizeAES128;

static NSString *publicKey = @"ea84f809a711eaae";
static NSString *publicIv  = @"873209a711eaae32";

//定义SM4秘钥和iv
#define SecretKey  "0ffb8344490186b7"
#define IV         "e97200b545feba13"

typedef unsigned char Uchar;

@implementation IUMEncryptor

+ (NSString *)encryptDES:(NSString *)plainText {
//    return [self encryptDES:plainText operation:kCCEncrypt];
//    return [IUMEncryptor hg_encryptAES:plainText];
    return [IUMEncryptor hg_encryptSM4:plainText];
}

+ (NSString *)decryptDES:(NSString *)plainText {
//    return [self encryptDES:plainText operation:kCCDecrypt];
//    return [IUMEncryptor hg_decryptAES:plainText];
    return [IUMEncryptor hg_decryptSM4:plainText];
}

+ (NSString *)encryptDES:(NSString *)plainText operation:(CCOperation)operation {
    
    NSString *key = @"12345678";
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (operation == kCCEncrypt) {
        
        NSData *encryptData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [encryptData length];
        vplainText = (const void *)[encryptData bytes];
    }
    else {
        // 先 Base64 解密
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:plainText options:NSDataBase64DecodingIgnoreUnknownCharacters];
        plainTextBufferSize = [decodedData length];
        vplainText = [decodedData bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [key UTF8String];
    Byte  iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    
    ccStatus = CCCrypt(operation,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeDES,
                       iv,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
        
    NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    NSString *result;
    if (operation == kCCEncrypt) {
        // DES 加密后，使用 Base64 加密。
        result = [data base64EncodedStringWithOptions:0];
    }
    else {
        result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    }
    return result;
}



//////////////////////////////////////////////////////////
/////////////////////////   AES加解密   ///////////////////
//////////////////////////////////////////////////////////

+ (NSString *)hg_encryptAES:(NSString *)content{
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [publicKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [publicIv dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        NSData * temData = [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
        NSString * temString = [temData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString * encryptString = [IUMEncryptor encodeString:temString];
        return [NSString stringWithFormat:@"%@",encryptString];
    }
    free(encryptedBytes);
    return nil;
}

+ (NSString *)hg_decryptAES:(NSString *)content{

    NSString * decodedString = [IUMEncryptor decodeString:content];
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:decodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;

    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [publicKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptedBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [publicIv dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          decryptedBytes,
                                          decryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        NSData * temData = [NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize];
        NSString * temStr = [[NSString alloc] initWithData:temData encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"%@",temStr];
    }
    free(decryptedBytes);
    return nil;
}

//编码
+ (NSString*)encodeString:(NSString*)uncodeString{
    NSCharacterSet * charSet = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"] invertedSet];
//    NSString * encodedString = (NSString *)CFBridgingRelease((__bridge CFTypeRef _Nullable)([uncodeString stringByAddingPercentEncodingWithAllowedCharacters:charSet]));
    NSString * encodedString = [uncodeString stringByAddingPercentEncodingWithAllowedCharacters:charSet];
    return encodedString;
}
//解码
+ (NSString*)decodeString:(NSString*)decodeString{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(kCFAllocatorDefault, (CFStringRef)decodeString, CFSTR("")));
}



//////////////////////////////////////////////////////////
/////////////////////////   SM4加解密   ///////////////////
//////////////////////////////////////////////////////////

//加密
+ (NSString*)hg_encryptSM4:(NSString*)strInput{
    
    NSData* data = [strInput dataUsingEncoding:NSUTF8StringEncoding];
    int length = [[NSString stringWithFormat:@"%lu",(unsigned long)data.length] intValue];
    int plusLength = 16 - length % 16;
    int new_length = length + plusLength;
    
    //初始化
    Uchar *input = (Uchar*)malloc(sizeof(Uchar)*new_length);
    Uchar *output = (Uchar*)malloc(sizeof(Uchar)*new_length);
    
    //补位赋值
    const char *utfChar = [strInput UTF8String];
    // 全部用需要补位的个数填充
    memset(input, plusLength, new_length);
    // 除去需要补位的部分，其余赋值为输入的数据
    memcpy(input, utfChar, length);
    
    //加密
    Uchar key[16] = SecretKey;
    Uchar iv[16] = IV;
    sm4_context ctx;
    sm4_setkey_enc1(&ctx,key);
//    sm4_crypt_ecb(&ctx,1,new_length,input,output);
    sm4_crypt_cbc1(&ctx,1,new_length, iv,input,output);

    //转成base64字符串，再进行URLCode
    NSData * inputData = [NSData dataWithBytes:output length:new_length];
    NSString * inputString = [inputData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    inputString = [IUMEncryptor encodeString:inputString];

    free(input);
    free(output);
    return [NSString stringWithFormat:@"%@",inputString];
}

//解密
+ (NSString *)hg_decryptSM4:(NSString*)strInput{
 
    NSString * decodedString = [IUMEncryptor decodeString:strInput];
    NSData * contentData = [[NSData alloc] initWithBase64EncodedString:decodedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    int inputCharSize = [[NSString stringWithFormat:@"%lu",(unsigned long)contentData.length] intValue];
    
    //初始化
    Uchar* input = (Uchar*)malloc(sizeof(Uchar)*inputCharSize);
    Uchar* output = (Uchar*)malloc(sizeof(Uchar)*inputCharSize);
    
    //为输入赋值
    memset(input, 0, inputCharSize);
    memcpy(input,(Uchar*)[contentData bytes],inputCharSize);

    //解密
    Uchar key[16] = SecretKey;
    Uchar iv[16] = IV;
    sm4_context ctx;
    sm4_setkey_dec1(&ctx,key);
//    sm4_crypt_ecb(&ctx,0,inputCharSize,input,output);
    sm4_crypt_cbc1(&ctx,0,inputCharSize, iv,input,output);

    //去除补位信息
    Uchar p = output[inputCharSize - 1];
    int new_length = inputCharSize - p;
    if (new_length < 0) {
        new_length = 0;
    }
    
    //转字符串
    NSString * outputString = [[NSString alloc] initWithBytes:output length:new_length encoding:NSUTF8StringEncoding];
        
    free(input);
    free(output);
    return outputString;
}

@end
