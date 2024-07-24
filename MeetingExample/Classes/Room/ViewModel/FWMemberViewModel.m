//
//  FWMemberViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMemberViewModel.h"

@interface FWMemberViewModel()

@end

@implementation FWMemberViewModel

#pragma mark - 初始化ViewModel
/// 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _succeedSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

#pragma mark - 设置全体静音状态
/// 设置全体静音状态
/// - Parameter micDisabled: 房间音频禁用状态，YES-禁用 NO-不禁用
/// - Parameter selfUnmuteMicDisabled: 是否禁止自我解除音频状态，YES-禁止 NO-不禁止
- (void)setRoomFrequencyState:(BOOL)micDisabled selfUnmuteMicDisabled:(BOOL)selfUnmuteMicDisabled {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人更新房间全体禁音频
    [[MeetingKit sharedInstance] adminUpdateRoomMicState:micDisabled selfUnmuteMicDisabled:selfUnmuteMicDisabled onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:micDisabled ? @"已开启全体静音" : @"已请求全体成员开麦"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"更新房间全体禁音频失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 设置全体禁画状态
/// 设置全体禁画状态
/// - Parameters:
///   - cameraDisabled: 房间视频禁用状态，YES-禁用 NO-不禁用
///   - selfUnmuteCameraDisabled: 是否禁止自我解除视频状态，YES-禁止 NO-不禁止
- (void)setRoomFramesState:(BOOL)cameraDisabled selfUnmuteCameraDisabled:(BOOL)selfUnmuteCameraDisabled {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人更新房间全体禁视频
    [[MeetingKit sharedInstance] adminUpdateRoomCameraState:cameraDisabled selfUnmuteCameraDisabled:selfUnmuteCameraDisabled onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:cameraDisabled ? @"已开启全体禁画" : @"已请求全体成员开启视频"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"更新房间全体禁视频失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 请求踢出成员
/// 请求踢出成员
/// - Parameter userId: 成员标识
- (void)queryRoomKickoutWithUserId:(NSString *)userId {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人踢出成员
    [[MeetingKit sharedInstance] adminKickUserOut:userId onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:@"移除成员成功"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"踢出成员失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 更新自己的昵称
/// 更新自己的昵称
/// - Parameter nickname: 新昵称
- (void)queryUpdateMineName:(NSString *)nickname {
    
    /// 如果新昵称为空
    if (kStringIsEmpty(nickname)) {
        /// 回调提示说明
        [self.toastSubject sendNext:@"新昵称不能为空"];
        /// 结束此次调用
        return;
    }
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 用户更新昵称
    [[MeetingKit sharedInstance] updateName:nickname onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:@"更新昵称成功"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"用户更新昵称失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 更新成员昵称
/// 更新成员昵称
/// - Parameter userid: 用户标识
/// - Parameter nickname: 新昵称
- (void)queryUpdateName:(NSString *)userid nickname:(NSString *)nickname {
    
    /// 如果新昵称为空
    if (kStringIsEmpty(nickname)) {
        /// 回调提示说明
        [self.toastSubject sendNext:@"新昵称不能为空"];
        /// 结束此次调用
        return;
    }
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人更新用户昵称
    [[MeetingKit sharedInstance] adminUpdateNickname:userid nickname:nickname onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:@"更新昵称成功"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人更新用户昵称失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 请求打开成员摄像头
/// 请求打开成员摄像头
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminRequestUserOpenCamera:(NSString *)userId nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人请求打开成员摄像头
    [[MeetingKit sharedInstance] adminRequestUserOpenCamera:userId onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"已请求%@开启摄像头。", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人请求打开成员摄像头失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 关闭远端用户摄像头
/// 关闭远端用户摄像头
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminCloseUserCamera:(NSString *)userId nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人关闭远端用户摄像头
    [[MeetingKit sharedInstance] adminCloseUserCamera:userId onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"已将%@的摄像头关闭。", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人关闭远端用户摄像头失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 请求打开成员麦克风
/// 请求打开成员麦克风
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminRequestUserOpenMic:(NSString *)userId nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人请求打开成员麦克风
    [[MeetingKit sharedInstance] adminRequestUserOpenMic:userId onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"已请求%@开启麦克风。", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人请求打开成员麦克风失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 关闭远端用户麦克风
/// 关闭远端用户麦克风
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminCloseUserMic:(NSString *)userId nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人关闭远端用户麦克风
    [[MeetingKit sharedInstance] adminCloseUserMic:userId onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"已将%@的麦克风关闭。", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人关闭远端用户麦克风失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 关闭共享
/// 关闭共享
/// - Parameter nickname: 用户名称
- (void)adminStopRoomShare:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人关闭共享
    [[MeetingKit sharedInstance] adminStopRoomShare:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"已将%@的共享关闭。", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人关闭共享失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 变更用户角色
/// 变更用户角色
/// - Parameters:
///   - userId: 用户标识
///   - userRole: 用户角色
///   - nickname: 用户名称
- (void)adminUpdateUserRole:(NSString *)userId userRole:(SEAUserRole)userRole nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人更新用户角色
    [[MeetingKit sharedInstance] adminUpdateUserRole:userId userRole:userRole onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"%@ 参会角色已变更。", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人更新用户角色失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 转移主持人
/// 转移主持人
/// - Parameters:
///   - userId: 用户标识
///   - nickname: 用户名称
- (void)adminMoveHost:(NSString *)userId nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人转移
    [[MeetingKit sharedInstance] adminMoveHost:userId onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"已将主持人转移给 %@", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人转移失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 变更用户聊天状态
/// 变更用户聊天状态
/// - Parameters:
///   - userId: 用户标识
///   - chatDisabled: 禁用状态，YES-禁用 NO-不禁用
///   - nickname: 用户名称
- (void)adminUpdateUserChatDisabled:(NSString *)userId chatDisabled:(BOOL)chatDisabled nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人更新用户聊天状态
    [[MeetingKit sharedInstance] adminUpdateUserChatDisabled:userId chatDisabled:chatDisabled onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:[NSString stringWithFormat:@"成员 %@ 的聊天状态已变更", nickname]];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人更新用户聊天状态失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

@end
