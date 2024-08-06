//
//  FWEntryBridge.h
//  MeetingExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWEntryBridge : NSObject

/// 当前是否在房间内
@property (nonatomic, assign, readonly) BOOL isRoomBusy;

/// 初始化方法
+ (FWEntryBridge *)sharedManager;

/// 获取全局委托
- (FWAppDelegate *)appDelegate;

/// 设置应用忙碌状态
/// - Parameter state: 忙碌状态，YES-忙碌 NO-空闲
- (void)setRoomBusy:(BOOL)state;

/// 部分基础设置
- (void)setupDefault;

/// 设置窗口根视图
- (void)setWindowRootView;

/// 切换登录视图
- (void)changeLoginView;

/// 切换首页视图
- (void)changeHomeView;

/// 开启后台任务
- (void)beginBackgroundTask;

/// 取消后台任务
- (void)cancelBackgroundTask;

@end

NS_ASSUME_NONNULL_END
