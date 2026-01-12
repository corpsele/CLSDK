//
//  NSObject+NullSensitive.h
//  IUMCore
//
//  Created by Chenly on 2017/4/10.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NullSensitive)

- (void)setValue:(id)value forKey:(NSString *)key nullSensitive:(BOOL)nullSensitive;

@end
