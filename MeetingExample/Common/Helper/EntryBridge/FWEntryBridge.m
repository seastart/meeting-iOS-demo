//
//  FWEntryBridge.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWAuthToken.h"
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
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    /// 添加内存监测白名单
    [NSObject addClassNamesToWhitelist:@[@"UIAlertController", @"UITextField", @"UITextView", @"SFSafariViewController", @"RPSystemBroadcastPickerView", @"RPBroadcastPickerStandaloneViewController"]];
}

#pragma mark - 设置窗口根视图
/// 设置窗口根视图
- (void)setWindowRootView {
    
    /// 获取登录用户数据
    FWUserModel *userModel = [[FWStoreDataBridge sharedManager] findUserModel];
    /// 根据本地用户数据来确定用户是否为登录状态
    if (userModel) {
        /// 用户为登录状态，首先请求会议授权，然后初始化会议组件
        [self queryMeetingGrant];
    } else {
        /// 用户为非登录状态，直接切换到登录视图
        [self changeLoginView];
    }
}

#pragma mark - 切换登录视图
/// 切换登录视图
- (void)changeLoginView {
    
    FWBaseNavigationViewController *navigation = [[FWBaseNavigationViewController alloc] initWithRootViewController:[[FWLoginViewController alloc] init]];
    [navigation setNavigationBarHidden:YES animated:YES];
    [UIView transitionWithView:[self appDelegate].window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self appDelegate].window.rootViewController = navigation;
    } completion:nil];
}

#pragma mark - 切换首页视图
/// 切换首页视图
- (void)changeHomeView {
    
    FWBaseTabBarViewController *tabBar = [[FWBaseTabBarViewController alloc] initTabBarViewController];
    [UIView transitionWithView:[self appDelegate].window duration:0.5f options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        [self appDelegate].window.rootViewController = tabBar;
    } completion:nil];
}

#pragma mark - 请求会议授权
/// 请求会议授权
- (void)queryMeetingGrant {
    
    @weakify(self);
    /// 设置加载状态
    [SVProgressHUD show];
    /// 发起请求
    [[FWNetworkBridge sharedManager] GET:FWREQUESTMEETINGGRANT params:nil className:@"FWAuthToken" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 隐藏加载状态
        [SVProgressHUD dismiss];
        /// 请求成功处理
        if (result) {
            /// 获取请求结果对象
            FWAuthToken *authToken = (FWAuthToken *)data;
            /// 登录会议组件
            [self loginMeetingModuleWithToken:authToken.data];
        } else {
            /// 切换登录视图
            [self changeLoginView];
            /// 失败提示信息
            [SVProgressHUD showInfoWithStatus:errorMsg];
        }
    }];
}

#pragma mark - 登录会议组件
/// 登录会议组件
/// - Parameter authToken: 会议授权令牌
- (void)loginMeetingModuleWithToken:(NSString *)authToken {
    
    @weakify(self);
    /// 设置加载状态
    [SVProgressHUD show];
    /// 组件登录
    [[MeetingKit sharedInstance] loginWithToken:authToken appGroup:FWAPPGROUP onSuccess:^(id _Nullable data) {
        @strongify(self);
        /// 隐藏加载状态
        [SVProgressHUD dismiss];
        /// 切换首页视图
        [self changeHomeView];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 隐藏加载状态
        [SVProgressHUD dismiss];
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"组件登录失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:logStr];
        SGLOG(@"%@", logStr);
    }];
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
