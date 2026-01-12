//
//  NSDictionary+CaseInsensitive.m
//  IUMCore
//
//  Created by Chenly on 2017/4/1.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import "NSDictionary+CaseInsensitive.h"

@implementation NSDictionary (CaseInsensitive)

- (id)objectForKey:(id)aKey caseInsensitive:(BOOL)caseInsensitive {
    
    if (!caseInsensitive || [self.allKeys containsObject:aKey]) {
        return [self objectForKey:aKey];
    }
    
    NSMutableArray *matchedValues = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([key compare:aKey options:NSDiacriticInsensitiveSearch]) {
            [matchedValues addObject:obj];
        }
    }];
    return matchedValues.count > 0 ? [matchedValues componentsJoinedByString:@","] : nil;
}

@end
