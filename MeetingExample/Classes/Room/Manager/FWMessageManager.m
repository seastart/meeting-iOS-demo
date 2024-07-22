//
//  FWMessageManager.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMessageManager.h"

@interface FWMessageManager()

/// 刷新数据回调
@property (copy, nonatomic) FWMessageManagerReloadDataBlock reloadDataBlock;
/// 聊天消息列表
@property (strong, nonatomic) NSMutableArray<FWMessageModel *> *listData;

@end

@implementation FWMessageManager

#pragma mark - 获取消息管理实例
/// 获取消息管理实例
+ (FWMessageManager *)sharedManager {
    
    static FWMessageManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWMessageManager alloc] init];
    });
    return manager;
}

#pragma mark - 创建聊天消息列表
/// 创建聊天消息列表
- (NSMutableArray <FWMessageModel *> *)listData {
    
    if (!_listData) {
        _listData = [NSMutableArray arrayWithCapacity:0];
    }
    return _listData;
}

#pragma mark - 清空聊天列表数据
/// 清空聊天列表数据
- (void)cleanChatsCache {
    
    /// 聊天列表数据清空
    [self.listData removeAllObjects];
}

#pragma mark - 成员信息更新
/// 成员信息更新
/// @param userId 用户标识
- (void)changeMemberWithUserid:(NSString *)userId {
    
    if (kStringIsEmpty(userId)) {
        /// 目标用户标识为空，丢弃该指令
        return;
    }
    
    /// 获取发送者数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] findMemberWithUserId:userId];
    /// 同步锁保护列表篡改
    @synchronized (self.listData) {
        /// 遍历消息分组数据
        [self.listData enumerateObjectsUsingBlock:^(FWMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            /// 遍历消息列表数据
            [obj.listData enumerateObjectsUsingBlock:^(FWMessageItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                /// 寻找对应发送者
                if ([userId isEqualToString:obj.userId]) {
                    /// 更改成员昵称
                    obj.name = userModel.name;
                }
            }];
        }];
    }
    /// 通知刷新列表
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}

#pragma mark - 获取聊天数据
/// 获取聊天数据
- (NSArray<FWMessageModel *> *)getAllChats {
    
    return [NSArray arrayWithArray:self.listData];
}

#pragma mark - 获取列表分组数
/// 获取列表分组数
- (NSInteger)numberOfSectionsInTableView {
    
    return self.listData.count;
}

#pragma mark - 获取列表每组数行数
/// 获取列表每组数行数
/// @param section 组索引
- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    
    FWMessageModel *chatModel = [self.listData objectAtIndex:section];
    return chatModel.listData.count;
}

#pragma mark - 获取列表分组标题
/// 获取列表分组标题
/// @param section 组索引
- (NSString *)viewForHeaderInSection:(NSInteger)section {
    
    FWMessageModel *chatModel = [self.listData objectAtIndex:section];
    NSString *title = [FWDateBridge dateConversionNSString:chatModel.beginDate format:@"HH:mm"];
    return title;
}

#pragma mark - 获取聊天信息
/// 获取聊天信息
/// @param indexPath 索引路径
- (FWMessageItemModel *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FWMessageModel *chatModel = [self.listData objectAtIndex:indexPath.section];
    FWMessageItemModel *itemModel = [chatModel.listData objectAtIndex:indexPath.row];
    return itemModel;
}

#pragma mark - 接收聊天消息
/// 接收聊天消息
/// - Parameters:
///   - senderId: 发送者标识
///   - content: 消息内容
///   - messageType: 消息类型
- (void)receiveChatWithSenderId:(nullable NSString *)senderId content:(NSString *)content messageType:(SEAMessageType)messageType {
    
    /// 获取发送者数据
    SEAUserModel *senderModel = [[MeetingKit sharedInstance] findMemberWithUserId:senderId];
    /// 获取当前账户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    
    /// 构建自定义聊天信息
    FWMessageItemModel *itemModel = [[FWMessageItemModel alloc] init];
    itemModel.userId = senderModel.userId;
    itemModel.name = senderModel.name;
    itemModel.avatar = senderModel.extend.avatar;
    itemModel.content = content;
    itemModel.messageType = messageType;
    itemModel.isMine = [userModel.userId isEqualToString:senderId];
    
    /// 将自定义聊天信息对象添加到数据源
    [self appendlistDataWithItemModel:itemModel];
}

#pragma mark - 将自定义聊天信息对象添加到数据源
/// 将自定义聊天信息对象添加到数据源
/// @param itemModel 聊天信息
- (void)appendlistDataWithItemModel:(FWMessageItemModel *)itemModel {
    
    /// 记录收到消息时间
    NSDate *date = [NSDate date];
    
    /// 默认不存在该消息
    __block FWMessageModel *chatModel = nil;
    /// 遍历消息列表(分组)，判断插入分组
    [self.listData enumerateObjectsUsingBlock:^(FWMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSComparisonResult beginResult = [date compare:obj.beginDate];
        NSComparisonResult endResult = [obj.endDate compare:date];
        /// 如果该条消息收到时间处于消息分组开始时间和消息分组结束时间之间
        /// 说明查找到该分组
        if (beginResult > NSOrderedAscending && endResult > NSOrderedAscending) {
            chatModel = obj;
            *stop = YES;
        }
    }];
    
    /// 不存在这样的聊天分组
    if (!chatModel) {
        /// 创建聊天分组
        chatModel = [[FWMessageModel alloc] init];
        /// 设置创建时间
        chatModel.beginDate = date;
        /// 消息分组结束时间设定为3分钟
        chatModel.endDate = [NSDate dateWithTimeInterval:3 * 60 sinceDate:date];
        /// 初始化消息列表数据
        chatModel.listData = [NSMutableArray arrayWithCapacity:0];
        /// 将聊天分组添加到数据源
        [self.listData addObject:chatModel];
    }
    
    /// 将新聊天消息添加到这个分组
    [chatModel.listData addObject:itemModel];
    
    /// 通知刷新列表
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}

#pragma mark - 刷新数据回调
/// 刷新数据回调
/// @param reloadDataBlock 刷新数据回调
- (void)reloadDataBlock:(FWMessageManagerReloadDataBlock)reloadDataBlock {
    
    self.reloadDataBlock = reloadDataBlock;
}

@end
