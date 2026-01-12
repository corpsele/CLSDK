//
//  NSString+category.h
//  CLSDK
//
//  Created by  on 2021/9/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (category)

/// 判断字符串是否为空
/// @param string 字符串
+ (BOOL)isBlankString:string;

/// 汉字转拼音
/// @param chinese 汉字
+ (NSString *)transform:(NSString *)chinese;

@end

NS_ASSUME_NONNULL_END
