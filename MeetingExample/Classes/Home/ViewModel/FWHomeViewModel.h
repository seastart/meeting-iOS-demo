//
//  FWHomeViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/26.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FWHomeModel;

@interface FWHomeViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 房间号码
@property (copy, nonatomic) NSString *roomNoText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 加入房间订阅
@property (nonatomic, strong, readonly) RACSubject *joinRoomSubject;
/// 退出登录订阅
@property (nonatomic, strong, readonly) RACSubject *logoutSubject;

/// 加入房间事件
- (void)onJoinRoomEvent;

/// 退出登录事件
- (void)onLogoutEvent;

@end

NS_ASSUME_NONNULL_END
