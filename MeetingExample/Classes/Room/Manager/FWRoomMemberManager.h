//
//  FWRoomMemberManager.h
//  MeetingExample
//
//  Created by SailorGa on 2024/5/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWRoomMemberModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 刷新成员列表回调
typedef void(^FWRoomMemberManagerReloadBlock)(void);
/// 当前角色变更回调
typedef void(^FWRoomMemberManagerRoleChangedBlock)(void);
/// 当前用户聊天禁用状态变更回调
typedef void(^FWRoomMemberManagerUserChatDisabledChangedBlock)(BOOL chatDisabled);
/// 当前房间聊天禁用状态变更回调
typedef void(^FWRoomMemberManagerRoomChatDisabledChangedBlock)(BOOL chatDisabled);

@interface FWRoomMemberManager : NSObject

/// 获取成员管理实例
+ (FWRoomMemberManager *)sharedManager;

#pragma mark - 清空成员列表
/// 清空成员列表
- (void)cleanMembers;

#pragma mark - 刷新成员列表
/// 刷新成员列表
- (void)reloadMemberLists;

#pragma mark - 用户聊天禁用状态变更
/// 用户聊天禁用状态变更
/// - Parameter chatDisabled: 禁用状态，YES-禁用 NO-不禁用
- (void)userChatDisabledChanged:(BOOL)chatDisabled;

#pragma mark - 房间聊天禁用状态变更
/// 房间聊天禁用状态变更
/// - Parameter chatDisabled: 禁用状态，YES-禁用 NO-不禁用
- (void)roomChatDisabledChanged:(BOOL)chatDisabled;

#pragma mark - 获取当前所有成员
/// 获取当前所有成员
- (nullable NSArray<FWRoomMemberModel *> *)getAllMembers;

#pragma mark - 查找成员信息
/// 查找成员信息
/// - Parameter userId: 成员标识
- (nullable FWRoomMemberModel *)findMemberWithUserId:(NSString *)userId;

#pragma mark - 成员共享状态变更
/// 成员共享状态变更
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)memberShareChangedWithUserId:(NSString *)userId;

#pragma mark - 成员进入房间
/// 成员进入房间
/// - Parameters:
///   - userId: 成员标识
///   - isMine: 是否为自己
- (FWRoomMemberModel *)onMemberEnterRoom:(NSString *)userId isMine:(BOOL)isMine;

#pragma mark - 成员离开房间
/// 成员离开房间
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)onMemberExitRoom:(NSString *)userId;

#pragma mark - 变更成员角色
/// 变更成员角色
/// - Parameters:
///   - userId: 成员标识
///   - userRole: 用户角色
- (FWRoomMemberModel *)userRoleChanged:(NSString *)userId userRole:(SEAUserRole)userRole;

#pragma mark - 获取当前用户角色
/// 获取当前用户角色
- (SEAUserRole)getUserRole;

#pragma mark - 获取当前用户是否为共享发起者
/// 获取当前用户是否为共享发起者
- (BOOL)isShareSponsor;

#pragma mark - 获取房间共享类型
/// 获取房间共享类型
- (SEAShareType)getSharingType;

#pragma mark - 刷新成员列表回调
/// 刷新成员列表回调
/// @param reloadBlock 刷新成员列表回调
- (void)reloadBlock:(nullable FWRoomMemberManagerReloadBlock)reloadBlock;

#pragma mark - 当前角色变更回调
/// 当前角色变更回调
/// @param roleChangedBlock 当前角色变更回调
- (void)roleChangedBlock:(nullable FWRoomMemberManagerRoleChangedBlock)roleChangedBlock;

#pragma mark - 当前用户聊天禁用状态变更回调
/// 当前用户聊天禁用状态变更回调
/// @param userChatDisabledChangedBlock 当前用户聊天禁用状态变更回调
- (void)userChatDisabledChangedBlock:(nullable FWRoomMemberManagerUserChatDisabledChangedBlock)userChatDisabledChangedBlock;

#pragma mark - 当前房间聊天禁用状态变更回调
/// 当前房间聊天禁用状态变更回调
/// @param roomChatDisabledChangedBlock 当前房间聊天禁用状态变更回调
- (void)roomChatDisabledChangedBlock:(nullable FWRoomMemberManagerRoomChatDisabledChangedBlock)roomChatDisabledChangedBlock;

@end

NS_ASSUME_NONNULL_END
