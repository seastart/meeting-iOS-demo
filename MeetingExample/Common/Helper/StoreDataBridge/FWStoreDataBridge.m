//
//  FWStoreDataBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2022/3/4.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import "FWStoreDataBridge.h"

@interface FWStoreDataBridge ()

/// 鉴权令牌
@property (nonatomic, copy, readwrite) NSString *authToken;
/// 用户信息
@property (nonatomic, strong, readwrite) SEAUserInfo *userInfo;
/// 房间号码
@property (nonatomic, copy, readwrite) NSString *roomNo;
/// 房间标识
@property (nonatomic, copy, readwrite) NSString *roomId;

@end

@implementation FWStoreDataBridge

#pragma mark - 初始化方法
/// 初始化方法
+ (FWStoreDataBridge *)sharedManager {
    
    static FWStoreDataBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWStoreDataBridge alloc] init];
    });
    return manager;
}

#pragma mark - 设置用户信息
/// 设置用户信息
/// - Parameter userInfo: 用户信息
- (void)configWithUserInfo:(SEAUserInfo *)userInfo {
    
    self.userInfo = userInfo;
}

#pragma mark - 登录用户
/// @param authToken 鉴权令牌
- (void)login:(NSString *)authToken {
    
    if (kStringIsEmpty(authToken)) {
        return;
    }
    self.authToken = authToken;
}

#pragma mark - 退出登录
/// 退出登录
- (void)logout {
    
    self.authToken = nil;
    self.userInfo = nil;
}

#pragma mark - 加入会议
/// 加入会议
/// - Parameters:
///   - roomNo: 会议号码
///   - roomId: 会议标识
- (void)enterRoom:(NSString *)roomNo roomId:(NSString *)roomId {
    
    self.roomNo = roomNo;
    self.roomId = roomId;
}

#pragma mark - 离开会议
/// 离开会议
- (void)exitRoom {
    
    self.roomNo = nil;
    self.roomId = nil;
}

#pragma mark - 获取手机号码
/// 获取手机号码
- (NSString *)getMobileText {
    
    NSString *mobileText = [self valueWithKey:FWMOBILEKEY];
    if (!kStringIsEmpty(mobileText)) {
        return mobileText;
    }
    return @"";
}

#pragma mark - 设置手机号码
/// 设置手机号码
/// @param mobileText 手机号码
- (void)setMobileText:(NSString *)mobileText {
    
    [self storeValue:mobileText withKey:FWMOBILEKEY];
}

#pragma mark - 获取用户密码
/// 获取用户密码
- (NSString *)getPasswordText {
    
    NSString *passwordText = [self valueWithKey:FWPASSWORDKEY];
    if (!kStringIsEmpty(passwordText)) {
        return passwordText;
    }
    return @"";
}

#pragma mark - 设置用户密码
/// 设置用户密码
/// @param passwordText 用户密码
- (void)setPasswordText:(NSString *)passwordText {
    
    [self storeValue:passwordText withKey:FWPASSWORDKEY];
}

#pragma mark - 获取用户昵称
/// 获取用户昵称
- (NSString *)getNickname {
    
    /// 构建存储KEY
    NSString *key = [NSString stringWithFormat:@"%@-%@", self.userInfo.userId, FWNICKNAMEKEY];
    /// 获取保存的昵称
    NSString *nickname = [self valueWithKey:key];
    if (!kStringIsEmpty(nickname)) {
        return nickname;
    }
    /// [FWToolBridge getDeviceName]
    return self.userInfo.userId;
}

#pragma mark - 设置用户昵称
/// 设置用户昵称
/// @param nickname 用户昵称
- (void)setNickname:(NSString *)nickname {
    
    /// 构建存储KEY
    NSString *key = [NSString stringWithFormat:@"%@-%@", self.userInfo.userId, FWNICKNAMEKEY];
    /// 保存用户昵称
    [self storeValue:nickname withKey:key];
}

#pragma mark - 设置用户头像
/// 设置用户头像
- (NSString *)getAvatar {
    
    /// 构建存储KEY
    NSString *key = [NSString stringWithFormat:@"%@-%@", self.userInfo.userId, FWUSERAVATARKEY];
    /// 获取保存的头像
    NSString *avatar = [self valueWithKey:key];
    if (!kStringIsEmpty(avatar)) {
        return avatar;
    }
    return FWDEFAULTAVATAR;
}

#pragma mark - 设置用户头像
/// 设置用户头像
/// - Parameter avatar: 用户头像
- (void)setAvatar:(NSString *)avatar {
    
    /// 构建存储KEY
    NSString *key = [NSString stringWithFormat:@"%@-%@", self.userInfo.userId, FWUSERAVATARKEY];
    /// 保存用户头像
    [self storeValue:avatar withKey:key];
}

#pragma mark - 存储数据
/// 存储数据
/// @param value 存储值
/// @param key 存储Key
- (void)storeValue:(nullable id)value withKey:(NSString *)key {
    
    NSParameterAssert(key);
    /// value值转化为NSData，后进行存储
    if (value == nil) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    } else {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[value copy]];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 获取数据
/// 获取数据
/// @param key 存储Key
- (id)valueWithKey:(NSString *)key {
    
    NSParameterAssert(key);
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

@end
