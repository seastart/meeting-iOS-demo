//
//  FWConstants.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWConstants.h"

/// APPID
NSString * const FWENGINEAPPID = @"68b3ft51smhz0x5glscw9whm78bw57uu";
/// APPKEY
NSString * const FWENGINEAPPKEY = @"s1hf8my7v9js210xp5r6o6uefwgxd6il";

/// Application Group Identifier
NSString * const FWAPPGROUP = @"group.cn.seastart.meetingkit";

/// 默认头像地址
NSString * const FWDEFAULTAVATAR = @"icon_login_avatar2";
/// 存储手机号码的KEY
NSString * const FWMOBILEKEY = @"cn.seastart.meetingkit.mobile";
/// 存储用户密码的KEY
NSString * const FWPASSWORDKEY = @"cn.seastart.meetingkit.password";
/// 存储用户昵称的KEY
NSString * const FWNICKNAMEKEY = @"cn.seastart.meetingkit.nickname";
/// 存储用户头像的KEY
NSString * const FWUSERAVATARKEY = @"cn.seastart.meetingkit.avatar";

/// 免责声明地址
NSString * const FWACCOUNTASSERTHOST = @"https://www.pgyer.com";
/// 个人信息收集清单地址
NSString * const FWACCOUNTPERSONALHOST = @"https://www.apple.com";
/// 第三方信息共享清单地址
NSString * const FWACCOUNTTHIRDPARTYHOST = @"https://developer.apple.com";
/// 用户协议地址
NSString * const FWACCOUNTAGREEMENTHOST = @"https://www.jianshu.com";
/// 隐私协议地址
NSString * const FWACCOUNTPRIVACYHOST = @"https://www.baidu.com";

/// 服务器地址
NSString * const FWSERVICEURI = @"http://localv2.srtc.live:8087";
/// 数据请求短链接头部
NSString * const FWSERVICESHORTHEADER = @"/server/";
/// 获取用户签名
NSString * const FWSIGNATUREINFOFACE = @"user-auth/grant";
/// 退出签名用户
NSString * const FWUSERLOGOUT = @"user-auth/kickout";

@implementation FWConstants

@end
