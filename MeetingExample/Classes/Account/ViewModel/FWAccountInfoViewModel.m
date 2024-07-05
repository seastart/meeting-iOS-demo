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
    
    /// 设置用户昵称
    [[FWStoreDataBridge sharedManager] setNickname:self.namenickText];
    /// 声明用户头像
    NSString *imageName = FWDEFAULTAVATAR;
    /// 根据性别标识设置头像
    if (self.isSexState) {
        /// 标识男性
        imageName = @"icon_login_avatar1";
    } else {
        /// 标识女性
        imageName = @"icon_login_avatar2";
    }
    /// 设置用户头像
    [[FWStoreDataBridge sharedManager] setAvatar:imageName];
    
    /// 提示信息
    [self.toastSubject sendNext:@"个人信息已更新"];
    /// 回调确定成功订阅
    [self.confirmSubject sendNext:nil];
}

@end
