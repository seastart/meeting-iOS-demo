//
//  FWMessageChatModel.h
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FWMessageChatItemModel;


@interface FWMessageChatModel : NSObject

/// 消息分组开始时间
@property (nonatomic, strong) NSDate *beginDate;
/// 消息分组结束时间
@property (nonatomic, strong) NSDate *endDate;

/// 消息列表数据
@property (nonatomic, strong) NSMutableArray <FWMessageChatItemModel *> *listData;

@end

@interface FWMessageChatItemModel : NSObject

/// 成员标识
@property (nonatomic, copy) NSString *uid;
/// 成员昵称
@property (nonatomic, copy) NSString *name;
/// 成员头像
@property (nonatomic, copy, nullable) NSString *avatar;
/// 消息内容
@property (nonatomic, copy) NSString *content;
/// 消息标识
@property (nonatomic, copy) NSString *action;
/// 是否为自己发送的信息
@property (nonatomic, assign) BOOL isMine;

@end

NS_ASSUME_NONNULL_END
