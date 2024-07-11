//
//  FWMemberViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMemberViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 操作成功订阅
@property (nonatomic, strong, readonly) RACSubject *succeedSubject;

/// 设置全体静音状态
/// - Parameter micDisabled: 全体音频禁用状态，YES-禁用 NO-不禁用
/// - Parameter selfUnmuteCameraDisabled: 是否允许自我解除，YES-允许 NO-不允许
- (void)setRoomFrequencyState:(BOOL)micDisabled selfUnmuteMicDisabled:(BOOL)selfUnmuteCameraDisabled;

/// 设置全体禁画状态
/// - Parameters:
///   - cameraDisabled: 全体视频禁用状态，YES-禁用 NO-不禁用
///   - selfUnmuteCameraDisabled: 是否允许自我解除，YES-允许 NO-不允许
- (void)setRoomFramesState:(BOOL)cameraDisabled selfUnmuteCameraDisabled:(BOOL)selfUnmuteCameraDisabled;

/// 请求踢出成员
/// - Parameter userId: 成员标识
- (void)queryRoomKickoutWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
