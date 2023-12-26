//
//  FWLoginViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWLoginViewModel.h"
#import "FWUserExtendModel.h"
#import "FWAuthToken.h"

@interface FWLoginViewModel()

/// 账户扩展信息
@property (nonatomic, strong) FWUserExtendModel *extendModel;

@end

@implementation FWLoginViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _loginSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _serverText = [[FWStoreDataBridge sharedManager] getServerUrl];
        _userSigText = [[FWStoreDataBridge sharedManager] getUserSig];
        _nicknameText = [[FWStoreDataBridge sharedManager] getNickname];
        /// _versionText = [NSString stringWithFormat:@"当前SDK版本信息：%@", [[FWEngineBridge sharedManager] version]];
        _buildText = [NSString stringWithFormat:@"Demo编译时间：%@", BundleVersion];
        _loading = NO;
    }
    return self;
}

#pragma mark - 懒加载账户扩展信息
/// 懒加载账户扩展信息
- (FWUserExtendModel *)extendModel {
    
    if (!_extendModel) {
        _extendModel = [[FWUserExtendModel alloc] init];
        _extendModel.videoState = NO;
        _extendModel.audioState = NO;
    }
    return _extendModel;
}

#pragma mark - 登录事件
/// 登录事件
- (void)onLoginEvent {
    
    if (kStringIsEmpty(self.serverText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入服务地址", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.userSigText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入token", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.nicknameText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入用户昵称", nil)];
        return;
    }
    
#ifdef DEBUG
    /// 接口获取用户签名userSig
    [self develop];
#else
    /// 手动输入用户签名userSig
    [self testing];
#endif
}

#pragma mark - 手动输入用户签名userSig
/// 手动输入用户签名userSig
- (void)testing {
    
    /// 缓存用户输入信息
    [[FWStoreDataBridge sharedManager] setServerUrl:self.serverText];
    [[FWStoreDataBridge sharedManager] setUserSig:self.userSigText];
    [[FWStoreDataBridge sharedManager] setNickname:self.nicknameText];
    
//    /// 创建账户对象
//    RTCEngineUserModel *userModel = [[RTCEngineUserModel alloc] init];
//    userModel.name = self.nicknameText;
//    userModel.avatar = FWDEFAULTAVATAR;
//    userModel.terminalType = RTCTerminalTypeIOS;
//    userModel.terminalDesc = RTCTERMINALDESC;
//    /// 设置账户扩展信息
//    userModel.props = self.extendModel;
//    
//    /// 创建配置对象
//    RTCEngineConfig *engineConfig = [[RTCEngineConfig alloc] init];
//    engineConfig.userSig = self.userSigText;
//    engineConfig.domain = self.serverText;
//    
//    /// 初始化RTC服务
//    RTCEngineError errorCode = [[FWEngineBridge sharedManager] initializeWithConfig:engineConfig userModel:userModel];
//    /// 根据返回值判断初始化是否成功
//    if (errorCode != RTCEngineErrorOK) {
//        NSString *toastStr = [NSString stringWithFormat:@"初始化RTC服务失败 errorCode = %ld", errorCode];
//        [self.toastSubject sendNext:toastStr];
//        SGLOG(@"%@", toastStr);
//        return;
//    }
//    
//    /// 缓存登录用户信息
//    [[FWStoreDataBridge sharedManager] login:userModel];
    /// 回调登录成功
    [self.loginSubject sendNext:nil];
}

#pragma mark - 接口获取用户签名userSig
/// 接口获取用户签名userSig
- (void)develop {
    
    /// 标记加载状态
    self.loading = YES;
    /// 创建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 用户标识
    [params setValue:[FWToolBridge getIdentifierForVendor] forKey:@"uid"];
    /// 向服务请求鉴权令牌
    [[FWNetworkBridge sharedManager] POST:FWSIGNATUREINFOFACE params:params className:@"FWAuthToken" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功处理
        if (result) {
            /// 获取请求结果对象
            FWAuthToken *model = (FWAuthToken *)data;
            
            /// 缓存用户输入信息
            [[FWStoreDataBridge sharedManager] setServerUrl:self.serverText];
            [[FWStoreDataBridge sharedManager] setUserSig:model.data.token];
            [[FWStoreDataBridge sharedManager] setNickname:self.nicknameText];
            
//            /// 创建账户对象
//            RTCEngineUserModel *userModel = [[RTCEngineUserModel alloc] init];
//            userModel.name = self.nicknameText;
//            userModel.avatar = FWDEFAULTAVATAR;
//            userModel.terminalType = RTCTerminalTypeIOS;
//            userModel.terminalDesc = RTCTERMINALDESC;
//            /// 设置账户扩展信息
//            userModel.props = self.extendModel;
//            
//            /// 创建配置对象
//            RTCEngineConfig *engineConfig = [[RTCEngineConfig alloc] init];
//            engineConfig.userSig = model.data.token;
//            engineConfig.domain = self.serverText;
//            
//            /// 初始化RTC服务
//            RTCEngineError errorCode = [[FWEngineBridge sharedManager] initializeWithConfig:engineConfig userModel:userModel];
//            /// 根据返回值判断初始化是否成功
//            if (errorCode != RTCEngineErrorOK) {
//                NSString *toastStr = [NSString stringWithFormat:@"初始化RTC服务失败 errorCode = %ld", errorCode];
//                [self.toastSubject sendNext:toastStr];
//                SGLOG(@"%@", toastStr);
//                return;
//            }
//            
//            /// 缓存登录用户信息
//            [[FWStoreDataBridge sharedManager] login:userModel];
            /// 回调登录成功
            [self.loginSubject sendNext:nil];
        } else {
            /// 提示信息
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

@end
