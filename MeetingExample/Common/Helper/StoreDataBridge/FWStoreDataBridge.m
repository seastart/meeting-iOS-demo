//
//  FWStoreDataBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2022/3/4.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import "FWStoreDataBridge.h"

@interface FWStoreDataBridge ()

/// 用户数据
@property (nonatomic, strong, readwrite) FWUserModel *userModel;
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

#pragma mark - 登录用户
/// @param userModel 用户数据
- (void)login:(FWUserModel *)userModel {
    
    /// 如果用户数据为空
    if (!userModel) {
        /// 丢弃此次操作
        return;
    }
    /// 保存用户数据
    self.userModel = userModel;
    /// 保存登录用户数据
    [self storeValue:[userModel yy_modelToJSONString] withKey:FWLOGINUSERKEY];
    /// 设置登录令牌
    [[FWNetworkBridge sharedManager] setUserToken:userModel.data.token];
}

#pragma mark - 获取登录用户数据
/// 获取登录用户数据
- (nullable FWUserModel *)findUserModel {
    
    /// 获取本地存储用户数据
    NSString *userJson = [self valueWithKey:FWLOGINUSERKEY];
    /// 如果本地存储数据为空
    if (kStringIsEmpty(userJson)) {
        /// 返回用户数据为空
        return nil;
    }
    /// 转换成用户数据对象
    self.userModel = [FWUserModel yy_modelWithJSON:userJson];
    /// 设置登录令牌
    [[FWNetworkBridge sharedManager] setUserToken:self.userModel.data.token];
    /// 返回用户数据
    return self.userModel;
}

#pragma mark - 更新用户令牌
/// 更新用户令牌
/// - Parameter authToken: 用户令牌
- (void)updateAuthToken:(NSString *)authToken {
    
    /// 如果用户令牌为空
    if (kStringIsEmpty(authToken)) {
        /// 丢弃此次设置
        return;
    }
    /// 重置用户令牌
    self.userModel.data.token = authToken;
    /// 模拟登录一次，替换本地数据以及数据请求登录令牌
    [self login:self.userModel];
}

#pragma mark - 更新用户基本数据
/// 更新用户基本数据
/// - Parameters:
///   - name: 用户昵称
///   - avatar: 用户头像
- (void)updateUserInfo:(NSString *)name avatar:(NSString *)avatar {
    
    /// 重置用户昵称
    self.userModel.data.nickname = name;
    /// 重置用户头像
    self.userModel.data.avatar = avatar;
    /// 模拟登录一次，替换本地数据以及数据请求登录令牌
    [self login:self.userModel];
}

#pragma mark - 退出登录
/// 退出登录
- (void)logout {
    
    /// 重置用户数据
    self.userModel = nil;
    /// 清除登录用户数据
    [self storeValue:nil withKey:FWLOGINUSERKEY];
    /// 清除登录令牌
    [[FWNetworkBridge sharedManager] clearUserToken];
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
- (void)setMobileText:(nullable NSString *)mobileText {
    
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
- (void)setPasswordText:(nullable NSString *)passwordText {
    
    [self storeValue:passwordText withKey:FWPASSWORDKEY];
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
