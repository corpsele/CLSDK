//
//  NSObject+Filter.m
//  iUapMobile
//
//  Created by Chenly on 2017/8/8.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import "NSObject+Filter.h"

@implementation NSDictionary (Filter)

- (instancetype)dictionaryByFilterValue:(id)value {
    
    NSMutableDictionary *dictionary = [self mutableCopy];
    NSMutableDictionary *changedValues = [NSMutableDictionary dictionary];
    NSSet *keys = [dictionary keysOfEntriesPassingTest:^BOOL(id key, id obj, BOOL *stop) {
        
        if ([obj isEqual:value]) {
            return YES;
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            changedValues[key] = [obj dictionaryByFilterValue:value];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            changedValues[key] = [obj arrayByFilterValue:value];
        }
        return NO;
    }];
    [dictionary removeObjectsForKeys:keys.allObjects];
    [dictionary setValuesForKeysWithDictionary:changedValues];
    return [dictionary isKindOfClass:[NSMutableDictionary class]] ? dictionary : [dictionary copy];
}

- (instancetype)dictionaryByFilterOutNull {
    return [self dictionaryByFilterValue:[NSNull null]];
}

- (instancetype)dictionaryByFilterOutEmptyString {
    return [self dictionaryByFilterValue:@""];
}

@end

@implementation NSArray (Filter)

- (instancetype)arrayByFilterValue:(id)value {
    
    NSMutableArray *array = [self mutableCopy];
    NSMutableDictionary *changedValues = [NSMutableDictionary dictionary];
    NSIndexSet *indexes = [array indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isEqual:value]) {
            return YES;
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            changedValues[@(idx)] = [obj dictionaryByFilterValue:value];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            changedValues[@(idx)] = [obj arrayByFilterValue:value];
        }
        return NO;
    }];
    [array removeObjectsAtIndexes:indexes];
    [changedValues enumerateKeysAndObjectsUsingBlock:^(NSNumber *idx, id obj, BOOL *stop) {
        array[idx.integerValue] = obj;
    }];
    return [array isKindOfClass:[NSMutableArray class]] ? array : [array copy];
}

- (instancetype)arrayByFilterOutNull {
    return [self arrayByFilterValue:[NSNull null]];
}

- (instancetype)arrayByFilterOutEmptyString {
    return [self arrayByFilterValue:@""];
}

@end

@implementation NSObject (Filter)

- (instancetype)filterWithOption:(ObjectFilterOption)option {

    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = (NSDictionary *)self;
        if (option & ObjectFilterOptionNull) {
            dictionary = [dictionary dictionaryByFilterOutNull];
        }
        if (option & ObjectFilterOptionEmptyString) {
            dictionary = [dictionary dictionaryByFilterOutEmptyString];
        }
        return dictionary;
    }
    else if ([self isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray *)self;
        if (option & ObjectFilterOptionNull) {
            array = [array arrayByFilterOutNull];
        }
        if (option & ObjectFilterOptionEmptyString) {
            array = [array arrayByFilterOutEmptyString];
        }
        return array;
    }
    return self;
}

@end
