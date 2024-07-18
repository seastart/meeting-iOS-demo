//
//  FWRoomMemberManager.m
//  MeetingExample
//
//  Created by SailorGa on 2024/5/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRoomMemberManager.h"

@interface FWRoomMemberManager()

/// 房间内成员列表
/// 成员标识作为Key
/// 成员对象组成Value
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, FWRoomMemberModel *> *roomMemberArray;

/// 刷新成员列表回调
@property (nonatomic, copy) FWRoomMemberManagerReloadBlock reloadBlock;
/// 当前角色变更回调
@property (nonatomic, copy) FWRoomMemberManagerRoleChangedBlock roleChangedBlock;

@end

@implementation FWRoomMemberManager

#pragma mark - 获取成员管理实例
/// 获取成员管理实例
+ (FWRoomMemberManager *)sharedManager {
    
    static FWRoomMemberManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWRoomMemberManager alloc] init];
    });
    return manager;
}

#pragma mark 创建成员列表
/// 创建成员列表
- (NSMutableDictionary<NSString *, FWRoomMemberModel *> *)roomMemberArray {
    
    if (!_roomMemberArray) {
        _roomMemberArray = [NSMutableDictionary dictionary];
    }
    return _roomMemberArray;
}

#pragma mark - 清空成员列表
/// 清空成员列表
- (void)cleanMembers {
    
    /// 成员列表数据清空
    [self.roomMemberArray removeAllObjects];
}

#pragma mark - 刷新成员列表
/// 刷新成员列表
- (void)reloadMemberLists {
    
    if (self.reloadBlock) {
        self.reloadBlock();
    }
}

#pragma mark - 获取当前所有成员
/// 获取当前所有成员
- (nullable NSArray<FWRoomMemberModel *> *)getAllMembers {
    
    return self.roomMemberArray.allValues;
}

#pragma mark - 查找成员信息
/// 查找成员信息
/// - Parameter userId: 成员标识
- (nullable FWRoomMemberModel *)findMemberWithUserId:(NSString *)userId {
    
    /// 获取对应标识的成员数据
    FWRoomMemberModel *memberModel = [self.roomMemberArray objectForKey:userId];
    /// 返回成员数据
    return memberModel;
}

#pragma mark - 成员共享状态变更
/// 成员共享状态变更
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)memberShareChangedWithUserId:(NSString *)userId {
    
    /// 遍历成员列表重置共享状态
    [self.roomMemberArray enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FWRoomMemberModel * _Nonnull obj, BOOL * _Nonnull stop) {
        /// 重置共享状态
        obj.isSharing = NO;
    }];
    
    /// 获取对应标识的成员数据
    FWRoomMemberModel *memberModel = [self.roomMemberArray objectForKey:userId];
    /// 存在该成员
    if (memberModel) {
        /// 标记成员共享状态
        memberModel.isSharing = YES;
    }
    /// 返回成员数据
    return memberModel;
}

#pragma mark - 成员进入房间
/// 成员进入房间
/// - Parameters:
///   - userId: 成员标识
///   - isMine: 是否为自己
- (FWRoomMemberModel *)onMemberEnterRoom:(NSString *)userId isMine:(BOOL)isMine {
    
    /// 获取对应标识的成员数据
    FWRoomMemberModel *memberModel = [self.roomMemberArray objectForKey:userId];
    /// 不存在该成员
    if (!memberModel) {
        /// 获取用户数据
        SEAUserModel *userModel = [[MeetingKit sharedInstance] findMemberWithUserId:userId];
        
        /// 创建成员信息
        memberModel = [[FWRoomMemberModel alloc] init];
        memberModel.userId = userId;
        memberModel.userRole = userModel.extend.role;
        memberModel.isMine = isMine;
        memberModel.isSharing = NO;
        memberModel.enterDate = [NSDate date];
        
        /// 添加到成员列表
        [self.roomMemberArray setValue:memberModel forKey:userId];
    }
    /// 返回成员数据
    return memberModel;
}

#pragma mark - 成员离开房间
/// 成员离开房间
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)onMemberExitRoom:(NSString *)userId {
    
    /// 获取对应标识的成员数据
    FWRoomMemberModel *memberModel = [self.roomMemberArray objectForKey:userId];
    /// 存在该成员
    if (memberModel) {
        /// 移除本地成员列表
        [self.roomMemberArray removeObjectForKey:userId];
    }
    /// 返回成员数据
    return memberModel;
}

#pragma mark - 变更成员角色
/// 变更成员角色
/// - Parameters:
///   - userId: 成员标识
///   - userRole: 用户角色
- (FWRoomMemberModel *)userRoleChanged:(NSString *)userId userRole:(SEAUserRole)userRole {
    
    /// 获取对应标识的成员数据
    FWRoomMemberModel *memberModel = [self.roomMemberArray objectForKey:userId];
    /// 存在该成员
    if (memberModel) {
        /// 变更成员角色
        memberModel.userRole = userRole;
    }
    /// 如果当前用户角色发生变更
    if (memberModel.isMine) {
        /// 通知回调刷新必要视图
        if (self.roleChangedBlock) {
            self.roleChangedBlock();
        }
    }
    /// 返回成员数据
    return memberModel;
}

#pragma mark - 获取当前用户角色
/// 获取当前用户角色
- (SEAUserRole)getUserRole {
    
    /// 获取用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    /// 返回用户角色
    return userModel.extend.role;
}

#pragma mark - 获取当前用户是否为共享发起者
/// 获取当前用户是否为共享发起者
- (BOOL)isShareSponsor {
    
    /// 获取用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    /// 获取房间详情数据
    SEARoomModel *roomModel = [[MeetingKit sharedInstance] getRoomDetails];
    /// 如果共享者标识为当前用户
    if ([userModel.userId isEqualToString:roomModel.extend.shareUid]) {
        return YES;
    }
    return NO;
}

#pragma mark - 获取房间共享类型
/// 获取房间共享类型
- (SEAShareType)getSharingType {
    
    /// 获取房间详情数据
    SEARoomModel *roomModel = [[MeetingKit sharedInstance] getRoomDetails];
    /// 返回共享类型
    return roomModel.extend.shareType;
}

#pragma mark - 刷新成员列表回调
/// 刷新成员列表回调
/// @param reloadBlock 刷新成员列表回调
- (void)reloadBlock:(nullable FWRoomMemberManagerReloadBlock)reloadBlock {
    
    self.reloadBlock = reloadBlock;
}

#pragma mark - 当前角色变更回调
/// 当前角色变更回调
/// @param roleChangedBlock 当前角色变更回调
- (void)roleChangedBlock:(nullable FWRoomMemberManagerRoleChangedBlock)roleChangedBlock {
    
    self.roleChangedBlock = roleChangedBlock;
}

@end
