//
//  FWMessageViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMessageViewModel : NSObject

/// 初始化方法
- (instancetype)initWithRoom:(BOOL)isRoom;

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;
/// 是否在房间中
@property (nonatomic, assign) BOOL isRoom;

/// 成员编号
@property (copy, nonatomic) NSString *accountNoText;
/// 消息内容
@property (copy, nonatomic, nullable) NSString *contentText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 发送消息订阅
@property (nonatomic, strong, readonly) RACSubject *sendSubject;

/// 发送消息事件
- (void)onSendEvent;

@end

NS_ASSUME_NONNULL_END
