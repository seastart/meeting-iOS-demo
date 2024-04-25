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

/// 后台保活音频播放器
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation FWEntryBridge

#pragma mark - 创建音频播放器
- (AVAudioPlayer *)audioPlayer {
    
    if (!_audioPlayer) {
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"audio_background_task" withExtension:@"wav"] error:nil];
        /// 无限播放
        _audioPlayer.numberOfLoops = -1;
        /// 设置音量
        _audioPlayer.volume = 0;
    }
    return _audioPlayer;
}

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
    /// 组件登录
    [[MeetingKit sharedInstance] loginWithToken:authToken appGroup:FWAPPGROUP onSuccess:^(id _Nullable data) {
        @strongify(self);
        /// 获取用户信息
        SEAUserInfo *userInfo = (SEAUserInfo *)data;
        /// 保存用户信息
        [[FWStoreDataBridge sharedManager] configWithUserInfo:userInfo];
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

#pragma mark - 开启后台任务
/// 开启后台任务
- (void)beginBackgroundTask {
    
    /// 停止播放音频
    [self.audioPlayer stop];
    
    /// 设置后台模式和锁屏模式下依然能够播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    
    /// 开始播放音频
    [self.audioPlayer play];
}

#pragma mark - 取消后台任务
/// 取消后台任务
- (void)cancelBackgroundTask {
    
    /// 停止播放音频
    [self.audioPlayer stop];
}

@end
