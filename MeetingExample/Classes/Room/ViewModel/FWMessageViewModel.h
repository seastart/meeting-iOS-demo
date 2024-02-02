//
//  FWMessageViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMessageViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 消息内容
@property (nonatomic, copy, nullable) NSString *contentText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 发送消息订阅
@property (nonatomic, strong, readonly) RACSubject *sendSubject;

/// 发送消息事件
- (void)onSendEvent;

@end

NS_ASSUME_NONNULL_END
