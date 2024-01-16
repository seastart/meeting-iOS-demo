//
//  FWMeetingAttendViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingAttendViewModel.h"

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
    _isCamera = NO;
    _loading = NO;
    _type = type;
}

#pragma mark - 复制房间号码
/// 复制房间号码
- (void)onCopyRoomNo {
    
    if (kStringIsEmpty(self.roomnoText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"房间号码为空，不允许复制到剪切板", nil)];
        return;
    }
    
    /// 房间号码复制到剪切板
    [[UIPasteboard generalPasteboard] setString:self.roomnoText];
    /// 回调提示信息
    [self.toastSubject sendNext:NSLocalizedString(@"房间号码已复制到剪切板", nil)];
}

#pragma mark - 请求确定
/// 请求确定
- (void)onConfirmEvent {
    
    if (kStringIsEmpty(self.roomnoText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入房间ID", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.nicknameText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入您的昵称", nil)];
        return;
    }
    
    /// 标记加载状态
    self.loading = YES;
    /// 恢复加载状态
    self.loading = NO;
    
    /// 回调请求成功
    [self.succeedSubject sendNext:nil];
}

@end
