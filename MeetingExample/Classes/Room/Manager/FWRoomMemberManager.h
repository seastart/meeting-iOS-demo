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

@interface FWRoomMemberManager : NSObject

/// 获取成员管理实例
+ (FWRoomMemberManager *)sharedManager;

#pragma mark - 清空成员列表
/// 清空成员列表
- (void)cleanMembers;

#pragma mark - 刷新成员列表
/// 刷新成员列表
- (void)reloadMemberLists;

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

#pragma mark - 刷新成员列表回调
/// 刷新成员列表回调
/// @param reloadBlock 刷新成员列表回调
- (void)reloadBlock:(nullable FWRoomMemberManagerReloadBlock)reloadBlock;

#pragma mark - 当前角色变更回调
/// 当前角色变更回调
/// @param roleChangedBlock 当前角色变更回调
- (void)roleChangedBlock:(nullable FWRoomMemberManagerRoleChangedBlock)roleChangedBlock;

@end

NS_ASSUME_NONNULL_END
