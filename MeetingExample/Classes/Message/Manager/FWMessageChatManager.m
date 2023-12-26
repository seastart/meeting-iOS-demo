//
//  FWMessageChatManager.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWMessageChatManager.h"

@interface FWMessageChatManager()

/// 聊天消息列表
@property (nonatomic, strong) NSMutableArray<FWMessageChatModel *> *listData;

@end

@implementation FWMessageChatManager

#pragma mark - 初始化方法
/// 初始化方法
+ (FWMessageChatManager *)sharedManager {
    
    static FWMessageChatManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWMessageChatManager alloc] init];
    });
    return manager;
}

#pragma mark - 懒加载聊天消息列表
/// 懒加载聊天消息列表
- (NSMutableArray <FWMessageChatModel *> *)listData {
    
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
/// @param uid 用户标识
- (void)changeMemberWithUserid:(nonnull NSString *)uid {
    
    if (kStringIsEmpty(uid)) {
        /// 目标用户标识为空，丢弃该指令
        return;
    }
    
//    /// 获取成员详细信息
//    RTCEngineUserModel *memberModel = [[FWEngineBridge sharedManager] findMemberWithUserId:uid];
//    
//    @synchronized (self.listData) {
//        /// 遍历消息分组数据
//        [self.listData enumerateObjectsUsingBlock:^(FWMessageChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            /// 遍历消息列表数据
//            [obj.listData enumerateObjectsUsingBlock:^(FWMessageChatItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                /// 寻找对应发送者
//                if ([uid isEqualToString:obj.uid]) {
//                    /// 更改成员昵称
//                    obj.name = memberModel.name;
//                    /// 更改成员头像
//                    obj.avatar = memberModel.avatar;
//                }
//            }];
//        }];
//    }
    
    /// 通知刷新列表
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}

#pragma mark - 获取聊天数据
/// 获取聊天数据
- (NSArray<FWMessageChatModel *> *)getAllChats {
    
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
    
    FWMessageChatModel *chatModel = [self.listData objectAtIndex:section];
    return chatModel.listData.count;
}

#pragma mark - 获取列表分组标题
/// 获取列表分组标题
/// @param section 组索引
- (NSString *)viewForHeaderInSection:(NSInteger)section {
    
    FWMessageChatModel *chatModel = [self.listData objectAtIndex:section];
    NSString *title = [FWDateBridge dateConversionNSString:chatModel.beginDate format:@"HH:mm"];
    return title;
}

#pragma mark - 获取聊天信息
/// 获取聊天信息
/// @param indexPath 索引路径
- (FWMessageChatItemModel *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FWMessageChatModel *chatModel = [self.listData objectAtIndex:indexPath.section];
    FWMessageChatItemModel *itemModel = [chatModel.listData objectAtIndex:indexPath.row];
    return itemModel;
}

#pragma mark - 接收聊天消息
/// 接收聊天消息
/// - Parameters:
///   - accountModel: 发送成员信息
///   - content: 消息内容
///   - action: 消息标识
//- (void)receiveChatWithAccountModel:(RTCEngineUserModel *)accountModel content:(NSString *)content action:(nullable NSString *)action {
//    
//    if ([[[FWStoreDataBridge sharedManager] getUserModel].uid isEqualToString:accountModel.uid]) {
//        /// 过滤接收到的自己的消息
//        return;
//    }
//    
//    /// 构建自定义聊天信息
//    FWMessageChatItemModel *itemModel = [[FWMessageChatItemModel alloc] init];
//    itemModel.uid = accountModel.uid;
//    itemModel.name = accountModel.name;
//    itemModel.avatar = accountModel.avatar;
//    itemModel.content = content;
//    itemModel.action = action;
//    itemModel.isMine = NO;
//    
//    /// 将自定义聊天信息对象添加到数据源
//    [self appendlistDataWithItemModel:itemModel];
//}

#pragma mark - 发送聊天消息
/// 发送聊天消息
/// - Parameter content: 消息内容
- (void)sendChatWithContent:(NSString *)content {
    
//    /// 构建自定义聊天信息
//    FWMessageChatItemModel *itemModel = [[FWMessageChatItemModel alloc] init];
//    itemModel.uid = [[FWStoreDataBridge sharedManager] getUserModel].uid;
//    itemModel.name = [[FWStoreDataBridge sharedManager] getUserModel].name;
//    itemModel.avatar = [[FWStoreDataBridge sharedManager] getUserModel].avatar;
//    itemModel.content = content;
//    itemModel.action = @"default";
//    itemModel.isMine = YES;
//    
//    /// 将自定义聊天信息对象添加到数据源
//    [self appendlistDataWithItemModel:itemModel];
}

#pragma mark - 将自定义聊天信息对象添加到数据源
/// 将自定义聊天信息对象添加到数据源
/// @param itemModel 聊天信息
- (void)appendlistDataWithItemModel:(FWMessageChatItemModel *)itemModel {
    
    /// 记录收到消息时间
    NSDate *date = [NSDate date];
    
    /// 默认不存在该消息
    __block FWMessageChatModel *chatModel = nil;
    /// 遍历消息列表(分组)，判断插入分组
    [self.listData enumerateObjectsUsingBlock:^(FWMessageChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        chatModel = [[FWMessageChatModel alloc] init];
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

#pragma mark - 刷新数据事件回调
/// 刷新数据事件回调
/// @param reloadDataBlock 刷新数据事件回调
- (void)reloadDataBlock:(FWMessageChatManagerReloadDataBlock)reloadDataBlock {
    
    self.reloadDataBlock = reloadDataBlock;
}

@end
