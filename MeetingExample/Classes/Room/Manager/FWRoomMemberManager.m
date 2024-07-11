//
//  FWRoomMemberManager.m
//  MeetingExample
//
//  Created by SailorGa on 2024/5/11.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRoomMemberManager.h"
#import "FWExtendModel.h"

@interface FWRoomMemberManager()

/// 当前用户角色
@property (nonatomic, assign, readwrite) SEAUserRole role;
/// 房间内成员列表
@property (nonatomic, strong) NSMutableArray<FWRoomMemberModel *> *roomMemberArray;

/// 刷新成员列表回调
@property (nonatomic, copy) FWRoomMemberManagerReloadBlock reloadBlock;

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

#pragma mark - 创建成员列表
/// 创建成员列表
- (NSMutableArray<FWRoomMemberModel *> *)roomMemberArray {
    
    if (!_roomMemberArray) {
        _roomMemberArray = [NSMutableArray arrayWithCapacity:0];
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
- (NSArray<FWRoomMemberModel *> *)getAllMembers {
    
    return [NSArray arrayWithArray:self.roomMemberArray];
}

#pragma mark - 查找成员信息
/// 查找成员信息
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)findMemberWithUserId:(NSString *)userId {
    
    /// 声明成员信息
    __block FWRoomMemberModel *memberModel = nil;
    /// 遍历成员列表，查找对应成员
    [self.roomMemberArray enumerateObjectsUsingBlock:^(FWRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 匹配列表成员
        if ([userId isEqualToString:obj.uid]) {
            /// 保存成员信息
            memberModel = obj;
            /// 结束遍历
            *stop = YES;
        }
    }];
    /// 返回成员信息
    return memberModel;
}

#pragma mark - 成员共享状态变更
/// 成员共享状态变更
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)memberShareChangedWithUserId:(NSString *)userId {
    
    /// 声明成员信息
    __block FWRoomMemberModel *memberModel = nil;
    /// 遍历成员列表，查找对应成员
    [self.roomMemberArray enumerateObjectsUsingBlock:^(FWRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 恢复其它成员共享状态
        obj.isSharing = NO;
        /// 匹配列表成员
        if ([userId isEqualToString:obj.uid]) {
            /// 修改成员共享状态
            obj.isSharing = YES;
            /// 保存成员信息
            memberModel = obj;
        }
    }];
    /// 返回成员信息
    return memberModel;
}

#pragma mark - 成员进入房间
/// 成员进入房间
/// - Parameters:
///   - userId: 成员标识
///   - isMine: 是否为自己
- (FWRoomMemberModel *)onMemberEnterRoom:(NSString *)userId isMine:(BOOL)isMine {
    
    /// 声明成员信息
    __block FWRoomMemberModel *memberModel = nil;
    /// 遍历成员列表，查找对应成员
    [self.roomMemberArray enumerateObjectsUsingBlock:^(FWRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 匹配列表成员
        if ([userId isEqualToString:obj.uid]) {
            /// 保存成员信息
            memberModel = obj;
            /// 结束遍历
            *stop = YES;
        }
    }];
    /// 不存在该成员
    if (!memberModel) {
        /// 创建成员信息
        memberModel = [[FWRoomMemberModel alloc] init];
        memberModel.uid = userId;
        memberModel.isMine = isMine;
        memberModel.isSharing = NO;
        memberModel.subscribe = NO;
        memberModel.enterDate = [NSDate date];
        if (isMine) {
            /// 获取成员扩展信息
            FWUserExtendModel *extendModel = [FWUserExtendModel yy_modelWithJSON:[[MeetingKit sharedInstance] getMySelf].props];
            /// 保存用户角色
            self.role = extendModel.role;
            /// 插入到成员列表
            [self.roomMemberArray insertObject:memberModel atIndex:0];
        } else {
            /// 添加到成员列表
            [self.roomMemberArray addObject:memberModel];
        }
    }
    /// 返回成员信息
    return memberModel;
}

#pragma mark - 成员离开房间
/// 成员离开房间
/// - Parameter userId: 成员标识
- (FWRoomMemberModel *)onMemberExitRoom:(NSString *)userId {
    
    /// 声明成员信息
    __block FWRoomMemberModel *memberModel = nil;
    /// 遍历成员列表，查找对应成员
    [self.roomMemberArray enumerateObjectsUsingBlock:^(FWRoomMemberModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 匹配列表成员
        if ([userId isEqualToString:obj.uid]) {
            /// 保存成员信息
            memberModel = obj;
            /// 结束遍历
            *stop = YES;
        }
    }];
    /// 存在该成员
    if (memberModel) {
        /// 移除本地成员列表
        [self.roomMemberArray removeObject:memberModel];
    }
    /// 返回成员信息
    return memberModel;
}

#pragma mark - 刷新成员列表回调
/// 刷新成员列表回调
/// @param reloadBlock 刷新成员列表回调
- (void)reloadBlock:(nullable FWRoomMemberManagerReloadBlock)reloadBlock {
    
    self.reloadBlock = reloadBlock;
}

@end
