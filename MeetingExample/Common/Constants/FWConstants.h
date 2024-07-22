//
//  FWConstants.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// Application Group Identifier
FOUNDATION_EXTERN NSString *__nonnull const FWAPPGROUP;

/// 默认头像地址
FOUNDATION_EXTERN NSString *__nonnull const FWDEFAULTAVATAR;
/// 存储用户数据的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWLOGINUSERKEY;
/// 存储手机号码的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWMOBILEKEY;
/// 存储用户密码的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWPASSWORDKEY;
/// 存储用户昵称的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWNICKNAMEKEY;
/// 存储用户头像的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWUSERAVATARKEY;

/// 服务器地址
FOUNDATION_EXTERN NSString *__nonnull const FWSERVICEURI;
/// 数据请求短链接头部
FOUNDATION_EXTERN NSString *__nonnull const FWSERVICESHORTHEADER;
/// 获取短信验证码
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTAUTHSMSCODE;
/// 请求用户注册
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTAUTHREGISTER;
/// 请求手机验证码登录
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTAUTHMOBILELOGIN;
/// 请求帐号密码登录
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTAUTHACCOUNTLOGIN;
/// 请求更新用户数据
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTMEMBERMEUPDATE;
/// 请求用户数据
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTMEMBERMEDETAIL;
/// 请求举报会议
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTMEMBERVIOLATION;
/// 请求文档详情
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTDOCUMENTDETAIL;
/// 请求会议授权
FOUNDATION_EXTERN NSString *__nonnull const FWREQUESTMEETINGGRANT;

/// 免责声明参数
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTASSERTPARAM;
/// 个人信息收集清单参数
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTPERSONALPARAM;
/// 第三方信息共享清单参数
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTTHIRDPARTPARAM;
/// 用户协议参数
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTAGREEMENTPARAM;
/// 隐私协议参数
FOUNDATION_EXTERN NSString *__nonnull const FWACCOUNTPRIVACYPARAM;

/// 远端头像地址1
FOUNDATION_EXTERN NSString *__nonnull FWREMOTEAVATAR1(void);
/// 远端头像地址2
FOUNDATION_EXTERN NSString *__nonnull FWREMOTEAVATAR2(void);

/// 免责声明地址
FOUNDATION_EXTERN NSString *__nonnull FWACCOUNTASSERTHOST(void);
/// 个人信息收集清单地址
FOUNDATION_EXTERN NSString *__nonnull FWACCOUNTPERSONALHOST(void);
/// 第三方信息共享清单地址
FOUNDATION_EXTERN NSString *__nonnull FWACCOUNTTHIRDPARTYHOST(void);
/// 用户协议地址
FOUNDATION_EXTERN NSString *__nonnull FWACCOUNTAGREEMENTHOST(void);
/// 隐私协议地址
FOUNDATION_EXTERN NSString *__nonnull FWACCOUNTPRIVACYHOST(void);


NS_ASSUME_NONNULL_END
