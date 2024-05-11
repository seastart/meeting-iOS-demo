//
//  FWMessageManager.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 刷新数据回调
typedef void(^FWMessageManagerReloadDataBlock)(void);

@interface FWMessageManager : NSObject

/// 获取消息管理实例
+ (FWMessageManager *)sharedManager;

/// 清空聊天列表数据
- (void)cleanChatsCache;

/// 成员信息更新
/// @param uid 用户标识
- (void)changeMemberWithUserid:(nonnull NSString *)uid;

/// 获取聊天数据
- (NSArray<FWMessageModel *> *)getAllChats;

/// 获取列表分组数
- (NSInteger)numberOfSectionsInTableView;

/// 获取列表每组数行数
/// @param section 组索引
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/// 获取列表分组标题
/// @param section 组索引
- (NSString *)viewForHeaderInSection:(NSInteger)section;

/// 获取聊天信息
/// @param indexPath 索引路径
- (FWMessageItemModel *)cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/// 接收聊天消息
/// - Parameters:
///   - accountModel: 发送成员信息
///   - content: 消息内容
///   - messageType: 消息类型
- (void)receiveChatWithAccountModel:(nullable RTCEngineUserModel *)accountModel content:(NSString *)content messageType:(SEAMessageType)messageType;

/// 发送聊天消息
/// - Parameter content: 消息内容
/// - (void)sendChatWithContent:(NSString *)content;

/// 刷新数据回调
/// @param reloadDataBlock 刷新数据回调
- (void)reloadDataBlock:(FWMessageManagerReloadDataBlock)reloadDataBlock;

@end

NS_ASSUME_NONNULL_END
