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

#pragma mark - 初始化方法
/// 初始化方法
+ (FWStoreDataBridge *)sharedManager;

#pragma mark - 退出登录
/// 退出登录
- (void)logout;

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

#pragma mark - 获取房间编号
/// 获取房间编号
- (NSString *)getRoomNo;

#pragma mark - 设置房间编号
/// 设置房间编号
/// @param roomNo 房间编号
- (void)setRoomNo:(NSString *)roomNo;

@end

NS_ASSUME_NONNULL_END
