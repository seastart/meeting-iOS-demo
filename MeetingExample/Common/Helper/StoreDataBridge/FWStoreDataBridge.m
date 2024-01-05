//
//  FWStoreDataBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2022/3/4.
//  Copyright © 2022 SailorGa. All rights reserved.
//

#import "FWStoreDataBridge.h"

@interface FWStoreDataBridge ()

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

#pragma mark - 退出登录
/// 退出登录
- (void)logout {
    
    /// self.userModel = nil;
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
    
    NSString *nickname = [self valueWithKey:FWNICKNAMEKEY];
    if (!kStringIsEmpty(nickname)) {
        return nickname;
    }
    return [FWToolBridge getDeviceName];
}

#pragma mark - 设置用户昵称
/// 设置用户昵称
/// @param nickname 用户昵称
- (void)setNickname:(NSString *)nickname {
    
    [self storeValue:nickname withKey:FWNICKNAMEKEY];
}

#pragma mark - 获取房间编号
/// 获取房间编号
- (NSString *)getRoomNo {
    
    NSString *roomNo = [self valueWithKey:FWROOMNOKEY];
    if (!kStringIsEmpty(roomNo)) {
        return roomNo;
    }
    return RTCROOMNO;
}

#pragma mark - 设置房间编号
/// 设置房间编号
/// @param roomNo 房间编号
- (void)setRoomNo:(NSString *)roomNo {
    
    [self storeValue:roomNo withKey:FWROOMNOKEY];
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
