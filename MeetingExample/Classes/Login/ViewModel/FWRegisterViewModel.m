//
//  FWRegisterViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRegisterViewModel.h"
#import "FWAuthToken.h"
#import "FWUserModel.h"

@interface FWRegisterViewModel()

@end

@implementation FWRegisterViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _toastSubject = [RACSubject subject];
        _registerSubject = [RACSubject subject];
        _mobileCodeSubject = [RACSubject subject];
        _isSecureCheck = YES;
        _isAgreement = YES;
        _isSecure = YES;
        _loading = NO;
    }
    return self;
}

#pragma mark - 获取验证码
/// 获取验证码
- (void)getMobileCode {
    
    if (kStringIsEmpty(self.mobileText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入您的手机号", nil)];
        return;
    }
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 创建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 手机号码
    [params setValue:self.mobileText forKey:@"mobile"];
    /// 请求场景
    [params setValue:@"register" forKey:@"scene"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWREQUESTAUTHSMSCODE params:params className:@"FWBaseModel" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功处理
        if (result) {
            /// 回调验证码获取成功
            [self.mobileCodeSubject sendNext:NSLocalizedString(@"验证码发送成功", nil)];
        } else {
            /// 提示信息
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

#pragma mark - 请求注册
/// 请求注册
- (void)onRegisterEvent {
    
    if (kStringIsEmpty(self.mobileText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入您的手机号", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.vcodeText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入验证码", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.passwordText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入用户密码", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.passwordCheckText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入确认密码", nil)];
        return;
    }
    
    if (![self.passwordText isEqualToString:self.passwordCheckText]) {
        [self.toastSubject sendNext:NSLocalizedString(@"两次密码不一致，请核对", nil)];
        return;
    }
    
    if (!self.isAgreement) {
        [self.toastSubject sendNext:NSLocalizedString(@"请阅读并同意用户协议和隐私协议", nil)];
        return;
    }
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 创建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 手机号码
    [params setValue:self.mobileText forKey:@"mobile"];
    /// 短信验证码
    [params setValue:self.vcodeText forKey:@"captcha"];
    /// 账号密码
    [params setValue:self.passwordText forKey:@"password"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWREQUESTAUTHREGISTER params:params className:@"FWUserModel" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功处理
        if (result) {
            /// 获取请求结果对象
            FWUserModel *userModel = (FWUserModel *)data;
            /// 设置用户登录
            [[FWStoreDataBridge sharedManager] login:userModel];
            /// 设置手机号码
            [[FWStoreDataBridge sharedManager] setMobileText:self.mobileText];
            /// 设置登录密码
            [[FWStoreDataBridge sharedManager] setPasswordText:self.passwordText];
            /// 回调注册成功
            [self.registerSubject sendNext:nil];
        } else {
            /// 提示信息
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

@end
