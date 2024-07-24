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
/// - Parameter micDisabled: 房间音频禁用状态，YES-禁用 NO-不禁用
/// - Parameter selfUnmuteMicDisabled: 是否禁止自我解除音频状态，YES-禁止 NO-不禁止
- (void)setRoomFrequencyState:(BOOL)micDisabled selfUnmuteMicDisabled:(BOOL)selfUnmuteMicDisabled;

/// 设置全体禁画状态
/// - Parameters:
///   - cameraDisabled: 房间视频禁用状态，YES-禁用 NO-不禁用
///   - selfUnmuteCameraDisabled: 是否禁止自我解除视频状态，YES-禁止 NO-不禁止
- (void)setRoomFramesState:(BOOL)cameraDisabled selfUnmuteCameraDisabled:(BOOL)selfUnmuteCameraDisabled;

/// 请求踢出成员
/// - Parameter userId: 成员标识
- (void)queryRoomKickoutWithUserId:(NSString *)userId;

/// 更新自己的昵称
/// - Parameter nickname: 新昵称
- (void)queryUpdateMineName:(NSString *)nickname;

/// 更新成员昵称
/// - Parameter userid: 用户标识
/// - Parameter nickname: 新昵称
- (void)queryUpdateName:(NSString *)userid nickname:(NSString *)nickname;

/// 请求打开成员摄像头
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminRequestUserOpenCamera:(NSString *)userId nickname:(NSString *)nickname;

/// 关闭远端用户摄像头
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminCloseUserCamera:(NSString *)userId nickname:(NSString *)nickname;

/// 请求打开成员麦克风
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminRequestUserOpenMic:(NSString *)userId nickname:(NSString *)nickname;

/// 关闭远端用户麦克风
/// - Parameter userId: 用户标识
/// - Parameter nickname: 用户名称
- (void)adminCloseUserMic:(NSString *)userId nickname:(NSString *)nickname;

/// 关闭共享
/// - Parameter nickname: 用户名称
- (void)adminStopRoomShare:(NSString *)nickname;

/// 变更用户角色
/// - Parameters:
///   - userId: 用户标识
///   - userRole: 用户角色
///   - nickname: 用户名称
- (void)adminUpdateUserRole:(NSString *)userId userRole:(SEAUserRole)userRole nickname:(NSString *)nickname;

/// 转移主持人
/// - Parameters:
///   - userId: 用户标识
///   - nickname: 用户名称
- (void)adminMoveHost:(NSString *)userId nickname:(NSString *)nickname;

/// 变更用户聊天状态
/// - Parameters:
///   - userId: 用户标识
///   - chatDisabled: 禁用状态，YES-禁用 NO-不禁用
///   - nickname: 用户名称
- (void)adminUpdateUserChatDisabled:(NSString *)userId chatDisabled:(BOOL)chatDisabled nickname:(NSString *)nickname;

@end

NS_ASSUME_NONNULL_END
