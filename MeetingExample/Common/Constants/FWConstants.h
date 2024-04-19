//
//  FWConstants.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// APPID
FOUNDATION_EXTERN NSString *__nonnull const FWENGINEAPPID;
/// APPKEY
FOUNDATION_EXTERN NSString *__nonnull const FWENGINEAPPKEY;
/// 服务器地址
FOUNDATION_EXTERN NSString *__nonnull const FWSERVICEURI;

/// 默认头像地址
FOUNDATION_EXTERN NSString *__nonnull const FWDEFAULTAVATAR;
/// 存储手机号码的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWMOBILEKEY;
/// 存储用户密码的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWPASSWORDKEY;
/// 存储用户昵称的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWNICKNAMEKEY;
/// 存储房间编号的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWROOMNOKEY;
/// 屏幕共享结束提示语的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWSCREENSHARINGENDKEY;

/// 免责声明地址
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTASSERTHOST;
/// 个人信息收集清单地址
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTPERSONALHOST;
/// 第三方信息共享清单地址
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTTHIRDPARTYHOST;
/// 用户协议地址
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTAGREEMENTHOST;
/// 隐私协议地址
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTPRIVACYHOST;

/// Bugly异常上报AppID
FOUNDATION_EXTERN NSString *__nonnull const FWBUGLYAPPID;
/// Bugly异常上报AppKey
FOUNDATION_EXTERN NSString *__nonnull const FWBUGLYAPPKEY;

/// Application Group Identifier
FOUNDATION_EXTERN NSString *__nonnull const FWAPPGROUP;

@interface FWConstants : NSObject

@end

NS_ASSUME_NONNULL_END
