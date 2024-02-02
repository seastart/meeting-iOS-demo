//
//  FWMessageModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class FWMessageItemModel;

@interface FWMessageModel : NSObject

/// 消息分组开始时间
@property (nonatomic, strong) NSDate *beginDate;
/// 消息分组结束时间
@property (nonatomic, strong) NSDate *endDate;

/// 消息列表数据
@property (nonatomic, strong) NSMutableArray <FWMessageItemModel *> *listData;

@end

@interface FWMessageItemModel : NSObject

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
