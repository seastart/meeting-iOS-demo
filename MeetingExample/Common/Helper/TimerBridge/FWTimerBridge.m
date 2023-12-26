//
//  FWTimerBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/3.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWTimerBridge.h"

@interface FWTimerBridge ()

@property (strong, nonatomic) dispatch_source_t timer;

@end

@implementation FWTimerBridge

/// 创建计时器
/// @param interval 计时器间隔
/// @param repeats 是否重复
/// @param queue 工作队列
/// @param block 计时回调
- (instancetype)initWithInterval:(int64_t)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block {
    
    self = [super init];
    if (self) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        /// int64_t delta = inmilli ? (interval * NSEC_PER_MSEC) : (interval * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, interval), interval, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (!repeats) {
                dispatch_source_cancel(self.timer);
                self.timer = nil;
            }
            block();
        });
        dispatch_resume(self.timer);
    }
    return self;
}

/// 创建计时器
/// @param interval 时间间隔
/// @param repeats 是否重复
/// @param queue 工作队列
/// @param block 计时回调
+ (FWTimerBridge *)scheduledTimerWithTimeInterval:(int64_t)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block {
    
    /// 创建计时器
    FWTimerBridge *timer = [[FWTimerBridge alloc] initWithInterval:interval repeats:repeats queue:queue block:block];
    /// 返回计时器对象
    return timer;
}

/// 释放计时器
- (void)invalidate {
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

/// 释放资源
- (void)dealloc {
    
    /// 释放计时器
    [self invalidate];
}

@end
