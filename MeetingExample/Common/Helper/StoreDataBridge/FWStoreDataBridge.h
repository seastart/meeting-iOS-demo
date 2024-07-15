//
//  FWStoreDataBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2022/3/4.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FWStoreDataBridge : NSObject

/// 用户数据
@property (nonatomic, strong, readonly) FWUserModel *userModel;
/// 房间号码
@property (nonatomic, copy, readonly) NSString *roomNo;
/// 房间标识
@property (nonatomic, copy, readonly) NSString *roomId;

#pragma mark - 初始化方法
/// 初始化方法
+ (FWStoreDataBridge *)sharedManager;

#pragma mark - 登录用户
/// @param userModel 用户数据
- (void)login:(FWUserModel *)userModel;

#pragma mark - 获取登录用户数据
/// 获取登录用户数据
- (nullable FWUserModel *)findUserModel;

#pragma mark - 更新用户令牌
/// 更新用户令牌
/// - Parameter authToken: 用户令牌
- (void)updateAuthToken:(NSString *)authToken;

#pragma mark - 更新用户基本数据
/// 更新用户基本数据
/// - Parameters:
///   - name: 用户昵称
///   - avatar: 用户头像
- (void)updateUserInfo:(NSString *)name avatar:(NSString *)avatar;

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
- (void)setMobileText:(nullable NSString *)mobileText;

#pragma mark - 获取用户密码
/// 获取用户密码
- (NSString *)getPasswordText;

#pragma mark - 设置用户密码
/// 设置用户密码
/// @param passwordText 用户密码
- (void)setPasswordText:(nullable NSString *)passwordText;

@end

NS_ASSUME_NONNULL_END
