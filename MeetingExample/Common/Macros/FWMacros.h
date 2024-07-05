//
//  FWMacros.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#ifndef FWMacros_h
#define FWMacros_h

/// 自定义输出
#define SGLOG(format,...) NSLog((@"[SGLOG][%@][%d] " format), [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,##__VA_ARGS__)
/// #define SGLOG(str, args...) ((void)0)

/// 检测是否是iPad
#define isPad [[UIDevice currentDevice].model isEqualToString:@"iPad"]
/// 是否是iPhone
#define isPhone [[UIDevice currentDevice].model isEqualToString:@"iPhone"]

/// 获取设备屏幕宽度/高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/// 顶部安全区高度
#define SafeBarTopHeight ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top)
/// 底部安全区高度
#define SafeBarMottomHeight ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom)

/// 应用名字
#define BundleDisplayName [(__bridge NSDictionary *)CFBundleGetInfoDictionary(CFBundleGetMainBundle())objectForKey:@"CFBundleDisplayName"]
/// 应用构建版本
#define BundleVersion [(__bridge NSDictionary *)CFBundleGetInfoDictionary(CFBundleGetMainBundle())objectForKey:@"CFBundleVersion"]
/// 应用包标识
#define BundleIdentifier [(__bridge NSDictionary *)CFBundleGetInfoDictionary(CFBundleGetMainBundle())objectForKey:@"CFBundleIdentifier"]
/// 应用版本号
#define BundleShortVersion [(__bridge NSDictionary *)CFBundleGetInfoDictionary(CFBundleGetMainBundle())objectForKey:@"CFBundleShortVersionString"]

/// 根据名字获取图片
#define kGetImage(imageName) [UIImage imageNamed:imageName]

/// 字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
/// 数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
/// 字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
/// 是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

/// 弱引用
#define WeakSelf() __weak typeof(self) weakSelf = self
#define StrongSelf(weakSelf) __strong typeof(self) strongSelf = weakSelf

/// 类名转换成字符串
#define kStringFromClass(className) NSStringFromClass([className class])

/// 取色值相关的方法
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:1.f]

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:(a)]

#define RGBOF(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(rgbValue & 0xFF))/255.0 \
                                            alpha:1.0]

#define RGBA_OF(rgbValue) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
                                            green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
                                             blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
                                            alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a) [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
                                            green:((float)(((v) & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(v & 0xFF))/255.0 \
                                            alpha:a]

/// 回归主线程执行操作
static inline void FWDispatchAscyncOnMainQueue(void(^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

/// 延时执行操作
static inline void FWDispatchAfter(int64_t time, void(^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)time), dispatch_get_main_queue(), ^{
        if (block) {
            block();
        }
    });
}

#endif /* FWMacros_h */
