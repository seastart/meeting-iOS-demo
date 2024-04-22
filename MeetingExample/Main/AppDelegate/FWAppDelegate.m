//
//  FWAppDelegate.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWAppDelegate.h"

@interface FWAppDelegate ()

@end

@implementation FWAppDelegate

#pragma mark - 懒加载window
- (UIWindow *)window {
    
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

#pragma mark - 完成启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /// 相关基础的设置
    [self baseSet:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

#pragma mark - 相关基础的设置
- (void)baseSet:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef DEBUG
    /// DEBUG模式日志说明
    SGLOG(@"DEBUG模式下，不开启日志重定向文件，日志统一输出到控制台");
#else
    /// 非DEBUG模式下开启日志重定向文件
    [[FWLogTraceBridge sharedManager] enableFileLogSystem];
#endif
    
    /// 基础设置
    [[FWEntryBridge sharedManager] setupDefault];
    /// 设置根视图为登录模块
    [[FWEntryBridge sharedManager] setWindowRootEntry];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    /// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    /// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    /// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    /// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    /// 开启后台任务
    [[FWEntryBridge sharedManager] beginBackgroundTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    /// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    /// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /// 取消后台任务
    [[FWEntryBridge sharedManager] cancelBackgroundTask];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    /// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
