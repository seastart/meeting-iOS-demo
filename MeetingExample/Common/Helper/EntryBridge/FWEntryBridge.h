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

/// 初始化方法
+ (FWEntryBridge *)sharedManager;

#pragma mark - 获取全局AppDelegate
/// 获取全局AppDelegate
- (FWAppDelegate *)appDelegate;

#pragma mark - 部分基础设置
/// 部分基础设置
- (void)setupDefault;

#pragma mark - 设置窗口根视图
/// 设置窗口根视图
- (void)setWindowRootView;

#pragma mark - 切换登录视图
/// 切换登录视图
- (void)changeLoginView;

#pragma mark - 切换首页视图
/// 切换首页视图
- (void)changeHomeView;

#pragma mark - 请求会议授权
/// 请求会议授权
- (void)queryMeetingGrant;

#pragma mark - 开启后台任务
/// 开启后台任务
- (void)beginBackgroundTask;

#pragma mark - 取消后台任务
/// 取消后台任务
- (void)cancelBackgroundTask;

@end

NS_ASSUME_NONNULL_END
