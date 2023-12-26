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

/// 服务地址
@property (copy, nonatomic) NSString *serverText;
/// 用户签名
@property (copy, nonatomic) NSString *userSigText;
/// 用户昵称
@property (copy, nonatomic) NSString *nicknameText;
/// SDK版本
@property (copy, nonatomic) NSString *versionText;
/// 编译时间
@property (copy, nonatomic) NSString *buildText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 登录成功订阅
@property (nonatomic, strong, readonly) RACSubject *loginSubject;

/// 登录事件
- (void)onLoginEvent;

@end

NS_ASSUME_NONNULL_END
