//
//  FWTimerBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2023/3/3.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWTimerBridge : NSObject

/// 创建计时器
/// @param interval 时间间隔
/// @param repeats 是否重复
/// @param queue 工作队列
/// @param block 计时回调
+ (FWTimerBridge *)scheduledTimerWithTimeInterval:(int64_t)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block;

/// 释放计时器
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
