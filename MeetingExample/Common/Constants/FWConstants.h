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

/// Application Group Identifier
FOUNDATION_EXTERN NSString *__nonnull const FWAPPGROUP;

/// 默认头像地址
FOUNDATION_EXTERN NSString *__nonnull const FWDEFAULTAVATAR;
/// 存储手机号码的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWMOBILEKEY;
/// 存储用户密码的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWPASSWORDKEY;
/// 存储用户昵称的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWNICKNAMEKEY;
/// 存储用户头像的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWUSERAVATARKEY;

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

/// 服务器地址
FOUNDATION_EXTERN NSString *__nonnull const FWSERVICEURI;
/// 数据请求短链接头部
FOUNDATION_EXTERN NSString *__nonnull const FWSERVICESHORTHEADER;
/// 获取用户签名
FOUNDATION_EXTERN NSString *__nonnull const FWSIGNATUREINFOFACE;
/// 退出签名用户
FOUNDATION_EXTERN NSString *__nonnull const FWUSERLOGOUT;

@interface FWConstants : NSObject

@end

NS_ASSUME_NONNULL_END
