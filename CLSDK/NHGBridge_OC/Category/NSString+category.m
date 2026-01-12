//
//  NSString+category.m
//  CLSDK
//
//  Created by  on 2021/9/13.
//

#import "NSString+category.h"

@implementation NSString (category)

// MARK: 判断字符串是否为空
+ (BOOL)isBlankString:string{
    
    if ([string isKindOfClass:[NSNull class]])
     {
         return YES;
     }
    if ([string isEqualToString:@""])
    {
        return YES;
    }
    
    if (string == nil)
    {
        return YES;
    }
    
    if (string == NULL)
    {
        return YES;
    }
    
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

// MARK: 汉字转拼音去空格
+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [[pinyin lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
