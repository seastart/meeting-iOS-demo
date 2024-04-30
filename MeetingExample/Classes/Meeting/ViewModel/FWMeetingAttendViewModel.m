//
//  FWMeetingAttendViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingAttendViewModel.h"
#import "FWMeetingEnterModel.h"

@implementation FWMeetingAttendViewModel

#pragma mark - 初始化方法
/// 初始化方法
/// @param type 参会入口类型
- (instancetype)initWithType:(FWMeetingEntryType)type {
    
    if (self = [super init]) {
        /// 初始化参数变量
        [self initType:type];
    }
    return self;
}

#pragma mark - 初始化方法
/// 初始化方法
/// @param type 参会入口类型
- (void)initType:(FWMeetingEntryType)type {
    
    _succeedSubject = [RACSubject subject];
    _toastSubject = [RACSubject subject];
    _isMicrophone = YES;
    _isCamera = YES;
    _loading = NO;
    _type = type;
}

#pragma mark - 复制房间号码
/// 复制房间号码
- (void)onCopyRoomNo {
    
    /// 字符串转换房间号码
    NSString *roomNo = [FWToolBridge stringDiversionRoomno:self.roomnoText];
    
    if (kStringIsEmpty(roomNo)) {
        [self.toastSubject sendNext:NSLocalizedString(@"房间号码为空，不允许复制到剪切板", nil)];
        return;
    }
    
    /// 房间号码复制到剪切板
    [[UIPasteboard generalPasteboard] setString:roomNo];
    /// 回调提示信息
    [self.toastSubject sendNext:NSLocalizedString(@"房间号码已复制到剪切板", nil)];
}

#pragma mark - 请求确定
/// 请求确定
- (void)onConfirmEvent {
    
    /// 字符串转换房间号码
    NSString *roomNo = [FWToolBridge stringDiversionRoomno:self.roomnoText];
    
    if (kStringIsEmpty(roomNo)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入房间号码", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.nicknameText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入您的昵称", nil)];
        return;
    }
    
    /// 标记加载状态
    self.loading = YES;
    /// 根据会议入口类型
    if (self.type == FWMeetingEntryTypeCreate) {
        /// 首先先创建会议，再加入会议
        [self createRoom:@"SailorGa 的测试会议" nickname:self.nicknameText];
    } else {
        /// 直接加入会议
        [self enterRoom:roomNo nickname:self.nicknameText];
    }
}

#pragma mark - 创建房间
/// 创建房间
/// - Parameter title: 房间标题
/// - Parameter nickname: 参会昵称
- (void)createRoom:(NSString *)title nickname:(NSString *)nickname {
    
    @weakify(self);
    /// 构建会议参数
    SEAMeetingParam *meetingParam = [[SEAMeetingParam alloc] init];
    meetingParam.title = title;
    /// 创建房间
    [[MeetingKit sharedInstance] createRoom:meetingParam onSuccess:^(id _Nullable data) {
        @strongify(self);
        /// 获取房间号码
        NSString *roomNo = (NSString *)data;
        /// 创建房间成功，加入房间
        [self enterRoom:roomNo nickname:nickname];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"创建房间失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 加入房间
/// 加入房间
/// - Parameter roomNo: 房间号码
/// - Parameter nickname: 参会昵称
- (void)enterRoom:(NSString *)roomNo nickname:(NSString *)nickname {
    
    /// 恢复加载状态
    self.loading = NO;
    /// 创建加入房间对象
    FWMeetingEnterModel *enterModel = [[FWMeetingEnterModel alloc] init];
    enterModel.roomNo = roomNo;
    enterModel.nickname = nickname;
    enterModel.audioState = self.isMicrophone;
    enterModel.videoState = self.isCamera;
    /// 回调请求成功
    [self.succeedSubject sendNext:enterModel];
}

@end
