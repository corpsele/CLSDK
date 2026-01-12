//
//  IUMResourceMacro.h
//  iUapMobile
//
//  Created by Chenly on 2017/8/22.
//  Copyright © 2017年 Yonyou. All rights reserved.
//

#ifndef IUMResourceMacro_h
#define IUMResourceMacro_h

#define IUM_GET_CURRENT_BUNDLE() \
({\
    Class cls;\
    NSString *function = [NSString stringWithFormat:@"%s", __FUNCTION__];\
    if ([function hasPrefix:@"+"]) {\
        cls = (Class)self;\
    }\
    else if ([function hasPrefix:@"-"]) {\
        cls = self.class;\
    }\
    NSBundle *bundle = cls ? [NSBundle bundleForClass:cls] : [NSBundle mainBundle];\
    bundle;\
})

#define IUM_IMAGE_NAMED(name) \
    [UIImage imageNamed:name inBundle:IUM_GET_CURRENT_BUNDLE() compatibleWithTraitCollection:nil]

#define IUM_PATH_FOR_RESOURCE(name, ext) \
    [IUM_GET_CURRENT_BUNDLE() pathForResource:name ofType:ext]

#endif /* IUMResourceMacro_h */
