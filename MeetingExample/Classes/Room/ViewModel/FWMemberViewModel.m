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
/// - Parameter micDisabled: 全体音频禁用状态，YES-禁用 NO-不禁用
/// - Parameter selfUnmuteCameraDisabled: 是否允许自我解除，YES-允许 NO-不允许
- (void)setRoomFrequencyState:(BOOL)micDisabled selfUnmuteMicDisabled:(BOOL)selfUnmuteCameraDisabled {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人更新房间全体禁音频
    [[MeetingKit sharedInstance] adminUpdateRoomMicState:micDisabled selfUnmuteMicDisabled:selfUnmuteCameraDisabled onSuccess:^(id  _Nullable data) {
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
///   - cameraDisabled: 全体视频禁用状态，YES-禁用 NO-不禁用
///   - selfUnmuteCameraDisabled: 是否允许自我解除，YES-允许 NO-不允许
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

@end
