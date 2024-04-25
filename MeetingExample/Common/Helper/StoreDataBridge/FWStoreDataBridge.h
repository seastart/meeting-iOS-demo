//
//  FWStoreDataBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2022/3/4.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWStoreDataBridge : NSObject

/// 鉴权令牌
@property (nonatomic, copy, readonly) NSString *authToken;
/// 用户信息
@property (nonatomic, strong, readonly) SEAUserInfo *userInfo;
/// 房间号码
@property (nonatomic, copy, readonly) NSString *roomNo;
/// 房间标识
@property (nonatomic, copy, readonly) NSString *roomId;

#pragma mark - 初始化方法
/// 初始化方法
+ (FWStoreDataBridge *)sharedManager;

#pragma mark - 设置用户信息
/// 设置用户信息
/// - Parameter userInfo: 用户信息
- (void)configWithUserInfo:(SEAUserInfo *)userInfo;

#pragma mark - 登录用户
/// @param authToken 鉴权令牌
- (void)login:(NSString *)authToken;

#pragma mark - 退出登录
/// 退出登录
- (void)logout;

#pragma mark - 加入会议
/// 加入会议
/// - Parameters:
///   - roomNo: 会议号码
///   - roomId: 会议标识
- (void)enterRoom:(NSString *)roomNo roomId:(NSString *)roomId;

#pragma mark - 离开会议
/// 离开会议
- (void)exitRoom;

#pragma mark - 获取手机号码
/// 获取手机号码
- (NSString *)getMobileText;

#pragma mark - 设置手机号码
/// 设置手机号码
/// @param mobileText 手机号码
- (void)setMobileText:(NSString *)mobileText;

#pragma mark - 获取用户密码
/// 获取用户密码
- (NSString *)getPasswordText;

#pragma mark - 设置用户密码
/// 设置用户密码
/// @param passwordText 用户密码
- (void)setPasswordText:(NSString *)passwordText;

#pragma mark - 获取用户昵称
/// 获取用户昵称
- (NSString *)getNickname;

#pragma mark - 设置用户昵称
/// 设置用户昵称
/// @param nickname 用户昵称
- (void)setNickname:(NSString *)nickname;

@end

NS_ASSUME_NONNULL_END
