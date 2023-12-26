//
//  FWHomeViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWHomeViewModel.h"

@interface FWHomeViewModel()

@end

@implementation FWHomeViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _joinRoomSubject = [RACSubject subject];
        _logoutSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _roomNoText = [[FWStoreDataBridge sharedManager] getRoomNo];
        _loading = NO;
    }
    return self;
}

#pragma mark - 加入房间事件
/// 加入房间事件
- (void)onJoinRoomEvent {
    
    if (kStringIsEmpty(self.roomNoText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入房间号码", nil)];
        return;
    }
    
    if (![FWToolBridge isValidateRoomNo:self.roomNoText]) {
        [self.toastSubject sendNext:NSLocalizedString(@"房间号码包含无效字符", nil)];
        return;
    }
    
    /// 缓存房间编号
    [[FWStoreDataBridge sharedManager] setRoomNo:self.roomNoText];
    
    /// 通知加入房间订阅
    [self.joinRoomSubject sendNext:self.roomNoText];
}

#pragma mark - 退出登录事件
/// 退出登录事件
- (void)onLogoutEvent {
    
    /// 通知退出登录订阅
    [self.logoutSubject sendNext:nil];
}

@end
