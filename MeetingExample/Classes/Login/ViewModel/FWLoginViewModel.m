//
//  FWLoginViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWLoginViewModel.h"
#import "FWAuthToken.h"

@interface FWLoginViewModel()

@end

@implementation FWLoginViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _loginSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _mobileCodeSubject = [RACSubject subject];
        _mobileText = [[FWStoreDataBridge sharedManager] getMobileText];
        _passwordText = [[FWStoreDataBridge sharedManager] getPasswordText];
        _versionText = [NSString stringWithFormat:@"当前SDK版本信息 %@", [[MeetingKit sharedInstance] version]];
        _isVcodeLogin = NO;
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
    [params setValue:@"login-mobile" forKey:@"scene"];
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

#pragma mark - 请求登录
/// 请求登录
- (void)onLoginEvent {
    
    if (kStringIsEmpty(self.mobileText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入您的手机号", nil)];
        return;
    }
    
    if (!self.isAgreement) {
        [self.toastSubject sendNext:NSLocalizedString(@"请阅读并同意用户协议和隐私协议", nil)];
        return;
    }
    
    /// 根据分段栏目确定登录方式
    self.isVcodeLogin ? [self handleVcodeLogin] : [self handlePasswordLogin];
}

#pragma mark - 验证码登录
/// 验证码登录
- (void)handleVcodeLogin {
    
    if (kStringIsEmpty(self.vcodeText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入验证码", nil)];
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
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWREQUESTAUTHMOBILELOGIN params:params className:@"FWUserModel" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
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
            [[FWStoreDataBridge sharedManager] setPasswordText:nil];
            /// 回调登录成功
            [self.loginSubject sendNext:nil];
        } else {
            /// 提示信息
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

#pragma mark - 密码登录
/// 密码登录
- (void)handlePasswordLogin {
    
    if (kStringIsEmpty(self.passwordText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入用户密码", nil)];
        return;
    }
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 创建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 手机号码
    [params setValue:self.mobileText forKey:@"account"];
    /// 账号密码
    [params setValue:self.passwordText forKey:@"password"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWREQUESTAUTHACCOUNTLOGIN params:params className:@"FWUserModel" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
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
            /// 回调登录成功
            [self.loginSubject sendNext:nil];
        } else {
            /// 提示信息
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

@end
