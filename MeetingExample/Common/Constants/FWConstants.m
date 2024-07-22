//
//  FWConstants.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWConstants.h"


/// Application Group Identifier
NSString * const FWAPPGROUP = @"group.cn.seastart.meetingkit";

/// 默认头像地址
NSString * const FWDEFAULTAVATAR = @"icon_login_avatar2";
/// 存储用户数据的KEY
NSString * const FWLOGINUSERKEY = @"cn.seastart.meetingkit.user";
/// 存储手机号码的KEY
NSString * const FWMOBILEKEY = @"cn.seastart.meetingkit.mobile";
/// 存储用户密码的KEY
NSString * const FWPASSWORDKEY = @"cn.seastart.meetingkit.password";
/// 存储用户昵称的KEY
NSString * const FWNICKNAMEKEY = @"cn.seastart.meetingkit.nickname";
/// 存储用户头像的KEY
NSString * const FWUSERAVATARKEY = @"cn.seastart.meetingkit.avatar";

/// 服务器地址
NSString * const FWSERVICEURI = @"http://192.168.0.172:8089";
/// 数据请求短链接头部
NSString * const FWSERVICESHORTHEADER = @"/api/v1/";
/// 获取短信验证码
NSString * const FWREQUESTAUTHSMSCODE = @"auth/sms-code";
/// 请求用户注册
NSString * const FWREQUESTAUTHREGISTER = @"auth/register";
/// 请求手机验证码登录
NSString * const FWREQUESTAUTHMOBILELOGIN = @"auth/login-mobile";
/// 请求帐号密码登录
NSString * const FWREQUESTAUTHACCOUNTLOGIN = @"auth/login-account";
/// 请求更新用户数据
NSString * const FWREQUESTMEMBERMEUPDATE = @"member/self-update";
/// 请求用户数据
NSString * const FWREQUESTMEMBERMEDETAIL = @"member/self-detail";
/// 请求举报会议
NSString * const FWREQUESTMEMBERVIOLATION = @"member/report-violation";
/// 请求文档详情
NSString * const FWREQUESTDOCUMENTDETAIL = @"document/get-detail";
/// 请求会议授权
NSString * const FWREQUESTMEETINGGRANT = @"meeting/grant";

/// 免责声明参数
NSString * const FWACCOUNTASSERTPARAM = @"?key=disclaimer&html=yes";
/// 个人信息收集清单参数
NSString * const FWACCOUNTPERSONALPARAM = @"?key=check-list&html=yes";
/// 第三方信息共享清单参数
NSString * const FWACCOUNTTHIRDPARTPARAM = @"?key=share-list&html=yes";
/// 用户协议参数
NSString * const FWACCOUNTAGREEMENTPARAM = @"?key=user-agreement&html=yes";
/// 隐私协议参数
NSString * const FWACCOUNTPRIVACYPARAM = @"?key=privacy-policy&html=yes";

/// 远端头像地址1
NSString * FWREMOTEAVATAR1(void) {
    
    return [NSString stringWithFormat:@"%@%@", FWSERVICEURI, @"/resource/avatar01.png"];
}

/// 远端头像地址2
NSString * FWREMOTEAVATAR2(void) {
    
    return [NSString stringWithFormat:@"%@%@", FWSERVICEURI, @"/resource/avatar02.png"];
}

/// 免责声明地址
NSString * FWACCOUNTASSERTHOST(void) {
    
    return [NSString stringWithFormat:@"%@%@%@%@", FWSERVICEURI, FWSERVICESHORTHEADER, FWREQUESTDOCUMENTDETAIL, FWACCOUNTASSERTPARAM];
}

/// 个人信息收集清单地址
NSString * FWACCOUNTPERSONALHOST(void) {
    
    return [NSString stringWithFormat:@"%@%@%@%@", FWSERVICEURI, FWSERVICESHORTHEADER, FWREQUESTDOCUMENTDETAIL, FWACCOUNTPERSONALPARAM];
}

/// 第三方信息共享清单地址
NSString * FWACCOUNTTHIRDPARTYHOST(void) {
    
    return [NSString stringWithFormat:@"%@%@%@%@", FWSERVICEURI, FWSERVICESHORTHEADER, FWREQUESTDOCUMENTDETAIL, FWACCOUNTTHIRDPARTPARAM];
}

/// 用户协议地址
NSString * FWACCOUNTAGREEMENTHOST(void) {
    
    return [NSString stringWithFormat:@"%@%@%@%@", FWSERVICEURI, FWSERVICESHORTHEADER, FWREQUESTDOCUMENTDETAIL, FWACCOUNTAGREEMENTPARAM];
}

/// 隐私协议地址
NSString * FWACCOUNTPRIVACYHOST(void) {
    
    return [NSString stringWithFormat:@"%@%@%@%@", FWSERVICEURI, FWSERVICESHORTHEADER, FWREQUESTDOCUMENTDETAIL, FWACCOUNTPRIVACYPARAM];
}
