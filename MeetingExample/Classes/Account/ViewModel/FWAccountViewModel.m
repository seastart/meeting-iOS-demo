//
//  FWAccountViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountViewModel.h"

@implementation FWAccountViewModel

/// 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _logoutSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

/// 退出登录事件
- (void)onLogoutEvent {
    
    /// 会议组件登出
    [[MeetingKit sharedInstance] logout];
    /// 本地退出登录
    [[FWStoreDataBridge sharedManager] logout];
    /// 通知退出登录订阅
    [self.logoutSubject sendNext:nil];
}

@end
