//
//  FWAccountViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWAccountViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 退出订阅
@property (nonatomic, strong, readonly) RACSubject *logoutSubject;

/// 退出登录事件
- (void)onLogoutEvent;

@end

NS_ASSUME_NONNULL_END
