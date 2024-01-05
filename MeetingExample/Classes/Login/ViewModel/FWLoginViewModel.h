//
//  FWLoginViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWLoginViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 验证码登录标识
@property (nonatomic, assign) BOOL isVcodeLogin;
/// 密码明文状态
@property (nonatomic, assign) BOOL isSecure;
/// 协议同意状态
@property (nonatomic, assign) BOOL isAgreement;

/// 手机号码
@property (nonatomic, copy) NSString *mobileText;
/// 用户密码
@property (nonatomic, copy) NSString *passwordText;
/// 验证码
@property (nonatomic, copy) NSString *vcodeText;
/// 版本信息
@property (nonatomic, copy) NSString *versionText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 登录成功订阅
@property (nonatomic, strong, readonly) RACSubject *loginSubject;
/// 验证码请求订阅
@property (nonatomic, strong, readonly) RACSubject *mobileCodeSubject;

/// 获取验证码
- (void)getMobileCode;
/// 请求登录
- (void)onLoginEvent;

@end

NS_ASSUME_NONNULL_END
