//
//  NSObject+NullSensitive.m
//  IUMCore
//
//  Created by Chenly on 2017/4/10.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import "NSObject+NullSensitive.h"
#import <objc/runtime.h>

@implementation NSObject (NullSensitive)

- (void)setValue:(id)value forKey:(NSString *)key nullSensitive:(BOOL)nullSensitive {

    if (nullSensitive && ([value isEqual:[NSNull null]])) {
        
        objc_property_t property = class_getProperty(self.class, key.UTF8String);
        if (!property) {
            NSLog(@"(Warning) no property %@ for Class %@", key, NSStringFromClass(self.class));
            return;
        }        
        const char *attributes = property_getAttributes(property);
        NSString *typeString = [NSString stringWithUTF8String:attributes];
        
        if ([typeString hasPrefix:@"T@"]) {
            // id 类型
            [self setValue:nil forKey:key];
        }
        else {
            [self setValue:@0 forKey:key];
        }
    }
    else {
        [self setValue:value forKey:key];
    }
}

@end
