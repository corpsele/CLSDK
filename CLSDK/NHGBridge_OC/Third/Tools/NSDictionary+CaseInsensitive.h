//
//  NSDictionary+CaseInsensitive.h
//  IUMCore
//
//  Created by Chenly on 2017/4/1.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CaseInsensitive)


/**
 @param caseInsensitive YES:忽略 Key 的大小写，如果完全匹配时返回一个确定值，多个模糊匹配时返回用","隔开的字符串
 */
- (id)objectForKey:(id)aKey caseInsensitive:(BOOL)caseInsensitive;

@end
