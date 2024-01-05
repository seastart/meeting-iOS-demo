//
//  FWRegisterViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWRegisterViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 密码明文状态
@property (nonatomic, assign) BOOL isSecure;
/// 密码确认明文状态
@property (nonatomic, assign) BOOL isSecureCheck;
/// 协议同意状态
@property (nonatomic, assign) BOOL isAgreement;

/// 手机号码
@property (nonatomic, copy) NSString *mobileText;
/// 验证码
@property (nonatomic, copy) NSString *vcodeText;
/// 用户密码
@property (nonatomic, copy) NSString *passwordText;
/// 用户确认密码
@property (nonatomic, copy) NSString *passwordCheckText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 注册成功订阅
@property (nonatomic, strong, readonly) RACSubject *registerSubject;
/// 验证码请求订阅
@property (nonatomic, strong, readonly) RACSubject *mobileCodeSubject;

/// 获取验证码
- (void)getMobileCode;
/// 请求注册
- (void)onRegisterEvent;

@end

NS_ASSUME_NONNULL_END
