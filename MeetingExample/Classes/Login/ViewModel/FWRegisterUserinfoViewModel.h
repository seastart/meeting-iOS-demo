//
//  FWRegisterUserinfoViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/8.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWRegisterUserinfoViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 性别标识，YES-男 NO-女
@property (nonatomic, assign) BOOL isSexState;

/// 用户昵称
@property (nonatomic, copy) NSString *namenickText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 确定成功订阅
@property (nonatomic, strong, readonly) RACSubject *confirmSubject;

/// 请求确定
- (void)onConfirmEvent;

@end

NS_ASSUME_NONNULL_END
