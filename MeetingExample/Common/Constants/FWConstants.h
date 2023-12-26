//
//  FWConstants.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 用户签名
FOUNDATION_EXTERN NSString *__nonnull const RTCENGINEUSERSIG;
#pragma mark - 服务地址
FOUNDATION_EXTERN NSString *__nonnull const RTCENGINEURI;
#pragma mark - 房间号码
FOUNDATION_EXTERN NSString *__nonnull const RTCROOMNO;
#pragma mark - 平台描述
FOUNDATION_EXTERN NSString *__nonnull const RTCTERMINALDESC;

#pragma mark - 默认头像地址
FOUNDATION_EXTERN NSString *__nonnull const FWDEFAULTAVATAR;
#pragma mark - 存储服务器地址的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWSERVERURLKEY;
#pragma mark - 存储USERSIG的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWUSERSIGKEY;
#pragma mark - 存储用户昵称的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWNICKNAMEKEY;
#pragma mark - 存储房间编号的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWROOMNOKEY;
#pragma mark - 屏幕共享结束提示语的KEY
FOUNDATION_EXTERN NSString *__nonnull const FWSCREENSHARINGENDKEY;

#pragma mark - Bugly异常上报相关
/// Bugly异常上报AppID
FOUNDATION_EXTERN NSString *__nonnull const FWBUGLYAPPID;
/// Bugly异常上报AppKey
FOUNDATION_EXTERN NSString *__nonnull const FWBUGLYAPPKEY;

/// Application Group Identifier
FOUNDATION_EXTERN NSString *__nonnull const FWAPPGROUP;

@interface FWConstants : NSObject

@end

NS_ASSUME_NONNULL_END
