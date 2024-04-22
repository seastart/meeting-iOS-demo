//
//  FWEntryBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWEntryBridge.h"
#import "FWLoginViewController.h"
#import "FWBaseTabBarViewController.h"
#import "FWBaseNavigationViewController.h"

@interface FWEntryBridge()

@end

@implementation FWEntryBridge

#pragma mark - 初始化方法
/// 初始化方法
+ (FWEntryBridge *)sharedManager {
    
    static FWEntryBridge *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[FWEntryBridge alloc] init];
    });
    return manager;
}

#pragma mark - 获取全局AppDelegate
- (FWAppDelegate *)appDelegate {
    
    return (FWAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - 部分基础设置
/// 部分基础设置
- (void)setupDefault {
    
    /// 启用键盘功能
    [[IQKeyboardManager sharedManager] setEnable:YES];
    /// 键盘弹出时点击背景键盘收回
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    /// 禁用IQKeyboard的Toolbar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    /// 添加内存监测白名单
    [NSObject addClassNamesToWhitelist:@[@"UIAlertController", @"UITextField", @"UITextView", @"RPSystemBroadcastPickerView", @"RPBroadcastPickerStandaloneViewController"]];
}

#pragma mark - 设置根视图为登录模块(未登录状态下)
/// 设置根视图为登录模块(未登录状态下)
- (void)setWindowRootEntry {
    
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:[[FWLoginViewController alloc] init]];
    [navigation setNavigationBarHidden:YES animated:YES];
    [UIView transitionWithView:[self appDelegate].window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self appDelegate].window.rootViewController = navigation;
    } completion:nil];
}

#pragma mark - 设置根视图为主功能模块(登录状态下)
/// 设置根视图为主功能模块(登录状态下)
- (void)setWindowRootHome {
    
    @weakify(self);
    /// 获取鉴权令牌
    NSString *authToken = [FWStoreDataBridge sharedManager].authToken;
    /// 登录组件
    [[MeetingKit sharedInstance] loginWithToken:authToken appGroup:FWAPPGROUP onSuccess:^{
        @strongify(self);
        /// 设置首页根视图
        [self _setWindowRootHome];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"组件登录失败 code = %ld, message = %@", code, message];
        [FWToastBridge showToastAction:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 设置首页根视图
/// 设置首页根视图
- (void)_setWindowRootHome {
    
    FWBaseTabBarViewController *tabBar = [[FWBaseTabBarViewController alloc] initTabBarViewController];
    [UIView transitionWithView:[self appDelegate].window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self appDelegate].window.rootViewController = tabBar;
    } completion:nil];
}

@end
