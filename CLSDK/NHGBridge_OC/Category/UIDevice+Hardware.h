//
//  UIDevice+Hardware.h
//  IUMCore
//
//  Created by Chenly on 2016/11/1.
//  Copyright © 2016年 Yonyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Hardware)

@property (nonatomic, readonly) NSString *platform;

@property (nonatomic, readonly) NSUInteger cpuFrequency;
@property (nonatomic, readonly) NSUInteger busFrequency;
@property (nonatomic, readonly) NSUInteger cpuCount;

@property (nonatomic, readonly) NSUInteger totalMemory;
@property (nonatomic, readonly) NSUInteger userMemory;

@property (nonatomic, readonly) NSNumber *totalDiskSpace;
@property (nonatomic, readonly) NSNumber *freeDiskSpace;

@property (nonatomic, readonly) NSString *macAddress;

@property (nonatomic, readonly) NSString *UUID;
@property (nonatomic, readonly) NSString *SSID;

@property (nonatomic, readonly) BOOL isIphoneX;

@end
