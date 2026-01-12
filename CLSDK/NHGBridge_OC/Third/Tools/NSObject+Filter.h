//
//  NSObject+Filter.h
//  iUapMobile
//
//  Created by Chenly on 2017/8/8.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ObjectFilterOption) {
    ObjectFilterOptionNull = 1 << 0,
    ObjectFilterOptionEmptyString = 1 << 1,
    ObjectFilterOptionBoth = ObjectFilterOptionNull | ObjectFilterOptionEmptyString
};

@interface NSDictionary (Filter)

- (instancetype)dictionaryByFilterOutNull;
- (instancetype)dictionaryByFilterOutEmptyString;
- (instancetype)dictionaryByFilterValue:(id)value;

@end

@interface NSArray (Filter)

- (instancetype)arrayByFilterOutNull;
- (instancetype)arrayByFilterOutEmptyString;
- (instancetype)arrayByFilterValue:(id)value;

@end

@interface NSObject (Filter)

- (instancetype)filterWithOption:(ObjectFilterOption)option;

@end
