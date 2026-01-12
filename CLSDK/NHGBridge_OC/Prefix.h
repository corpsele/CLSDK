//
//  Prefix.h
//  CLSDK
//
//  Created by  on 2021/9/10.
//

#ifndef Prefix_h
#define Prefix_h

//服务后缀
#define  UMSERVER_CORE_METHOD @"umserver/core"

#define WeakS __weak typeof(self) weakSelf = self
#define StrongS  __strong typeof(weakSelf) strongSelf = weakSelf

//颜色
#define HGColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define BASE_COLOUR HGColorFromRGB(0xEDEDED)
#define BLACK_COLOUR HGColorFromRGB(0x333333)
#define GRAY_COLOUR HGColorFromRGB(0x666666)
#define LIGHT_GRAY_COLOUR HGColorFromRGB(0x999999)
#define LINE_COLOUR HGColorFromRGB(0xEEEEEE)
#define BLUE_COLOUR HGColorFromRGB(0x2261c9)

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

/*
 导航栏/标签栏尺寸
 */
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height //状态栏高度
#define iPhoneXHeight  812 //iphonex 高度
#define kNavBarHeight  44.0 //导航栏高度
#define kTabBarHeight  (kStatusBarHeight > 20.0 ? 83.0 : 49) //标签栏的高度
#define kTopHeight kStatusBarHeight + kNavBarHeight //状态栏加导航栏高度
#define isTypeiPhoneX (kStatusBarHeight > 20.0 ? YES : NO)
#define kHomeHeight (isTypeiPhoneX ? 34 : 0)

#endif /* Prefix_h */
