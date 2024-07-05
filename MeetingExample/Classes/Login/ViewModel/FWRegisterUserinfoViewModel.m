//
//  FWRegisterUserinfoViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/8.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRegisterUserinfoViewModel.h"

@interface FWRegisterUserinfoViewModel()

@end

@implementation FWRegisterUserinfoViewModel

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
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 获取鉴权令牌
    NSString *authToken = [FWStoreDataBridge sharedManager].authToken;
    /// 组件登录
    [[MeetingKit sharedInstance] loginWithToken:authToken appGroup:FWAPPGROUP onSuccess:^(id _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 获取用户信息
        SEAUserInfo *userInfo = (SEAUserInfo *)data;
        /// 保存用户信息
        [[FWStoreDataBridge sharedManager] configWithUserInfo:userInfo];
        /// 设置用户昵称
        [[FWStoreDataBridge sharedManager] setNickname:self.namenickText];
        /// 声明用户头像
        NSString *imageName = @"icon_login_avatar2";
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
        /// 回调确定成功订阅
        [self.confirmSubject sendNext:nil];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 隐藏加载状态
        [SVProgressHUD dismiss];
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"组件登录失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:logStr];
        SGLOG(@"%@", logStr);
    }];
}

@end
