//
//  FWConstants.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWConstants.h"

//#pragma mark - 用户签名
//NSString * const RTCENGINEUSERSIG = 替换成获取到的UserSig
#pragma mark - 用户签名
NSString * const RTCENGINEUSERSIG = @"n/vspiABgssjSS0GNklnubZWv3RqnHqZlkl59cdgZ9IthFQWfBaAgvW65IyZ2AdyCTipWwunqqVRX3M9EMRarzE6N48bMd1w+zyZQYWZikNH0SHtAwP6mKKW7MMF7+mI2B1J62zeXfsPykwa97IXJpWN5g2/Gtyn1BrwX8xghhw=";
#pragma mark - 服务地址
NSString * const RTCENGINEURI = @"https://localv2.srtc.live:9000";
#pragma mark - 房间号码
NSString * const RTCROOMNO = @"90909090";
#pragma mark - 平台描述
NSString * const RTCTERMINALDESC = @"iOS 移动终端";

#pragma mark - 默认头像地址
NSString * const FWDEFAULTAVATAR = @"http://assets.sailorhub.cn/avatar.png";
#pragma mark - 存储手机号码的KEY
NSString * const FWMOBILEKEY = @"cn.seastart.meetingkit.freewind.mobile";
#pragma mark - 存储用户密码的KEY
NSString * const FWPASSWORDKEY = @"cn.seastart.meetingkit.freewind.password";
#pragma mark - 存储用户昵称的KEY
NSString * const FWNICKNAMEKEY = @"cn.seastart.meetingkit.freewind.nickname";
#pragma mark - 存储房间编号的KEY
NSString * const FWROOMNOKEY = @"cn.seastart.meetingkit.freewind.roomno";
#pragma mark - 屏幕共享结束提示语的KEY
NSString * const FWSCREENSHARINGENDKEY = @"cn.seastart.meetingkit.freewind.screenend";

#pragma mark - Bugly异常上报相关
/// Bugly异常上报APPID
NSString * const FWBUGLYAPPID = @"21acd998ee";
/// Bugly异常上报APPKey
NSString * const FWBUGLYAPPKEY = @"928570f4-a493-4e58-b78f-3f856a4c8c31";

/// Application Group Identifier
NSString * const FWAPPGROUP = @"group.cn.seastart.meetingkit";

@implementation FWConstants

@end
