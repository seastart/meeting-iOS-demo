//
//  FWAccountInfoViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountInfoViewModel.h"

@interface FWAccountInfoViewModel()

@end

@implementation FWAccountInfoViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _toastSubject = [RACSubject subject];
        _confirmSubject = [RACSubject subject];
        _isSexState = YES;
        _loading = NO;
    }
    return self;
}

#pragma mark - 请求确定
/// 请求确定
- (void)onConfirmEvent {
    
    if (kStringIsEmpty(self.namenickText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请设置您的昵称", nil)];
        return;
    }
    
    /// 标记加载状态
    self.loading = YES;
    /// 恢复加载状态
    self.loading = NO;
    
    /// 缓存登录用户信息
    /// [[FWStoreDataBridge sharedManager] login:userModel];
    /// 提示信息
    [self.toastSubject sendNext:@"个人信息已更新"];
    /// 回调确定成功订阅
    [self.confirmSubject sendNext:nil];
}

@end
