//
//  FWMessageChatManager.h
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWMessageChatModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 刷新数据事件回调
typedef void(^FWMessageChatManagerReloadDataBlock)(void);

@interface FWMessageChatManager : NSObject

#pragma mark - 初始化方法
/// 初始化方法
+ (FWMessageChatManager *)sharedManager;

#pragma mark - 清空聊天列表数据
/// 清空聊天列表数据
- (void)cleanChatsCache;

#pragma mark - 成员信息更新
/// 成员信息更新
/// @param uid 用户标识
- (void)changeMemberWithUserid:(nonnull NSString *)uid;

#pragma mark - 获取聊天数据
/// 获取聊天数据
- (NSArray<FWMessageChatModel *> *)getAllChats;

#pragma mark - 获取列表分组数
/// 获取列表分组数
- (NSInteger)numberOfSectionsInTableView;

#pragma mark - 获取列表每组数行数
/// 获取列表每组数行数
/// @param section 组索引
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

#pragma mark - 获取列表分组标题
/// 获取列表分组标题
/// @param section 组索引
- (NSString *)viewForHeaderInSection:(NSInteger)section;

#pragma mark - 获取聊天信息
/// 获取聊天信息
/// @param indexPath 索引路径
- (FWMessageChatItemModel *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 接收聊天消息
/// 接收聊天消息
/// - Parameters:
///   - accountModel: 发送成员信息
///   - content: 消息内容
///   - action: 消息标识
//- (void)receiveChatWithAccountModel:(RTCEngineUserModel *)accountModel content:(NSString *)content action:(nullable NSString *)action;

#pragma mark - 发送聊天消息
/// 发送聊天消息
/// - Parameter content: 消息内容
- (void)sendChatWithContent:(NSString *)content;

#pragma mark - 刷新数据事件回调
/// 刷新数据事件回调
@property (copy, nonatomic) FWMessageChatManagerReloadDataBlock reloadDataBlock;

/// 刷新数据事件回调
/// @param reloadDataBlock 刷新数据事件回调
- (void)reloadDataBlock:(FWMessageChatManagerReloadDataBlock)reloadDataBlock;

@end

NS_ASSUME_NONNULL_END
