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

@interface FWRoomMemberManager : NSObject

/// 获取成员管理实例
+ (FWRoomMemberManager *)sharedManager;

#pragma mark - 清空成员列表
/// 清空成员列表
- (void)cleanMembers;

#pragma mark - 获取当前所有成员
/// 获取当前所有成员
- (NSArray<FWRoomMemberModel *> *)getAllMembers;

#pragma mark - 查找成员信息
/// 查找成员信息
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)findMemberWithUserId:(NSString *)userId;

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

@end

NS_ASSUME_NONNULL_END
