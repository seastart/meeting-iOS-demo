//
//  FWRoomViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWReportViewController.h"
#import "FWRoomViewController.h"
#import "FWRoomMemberModel.h"
#import "FWRoomViewModel.h"
#import "FWRoomMainView.h"

@interface FWRoomViewController () <MeetingKitDelegate, FWRoomMainViewDelegate>

/// 房间主窗口视图
@property (weak, nonatomic) IBOutlet FWRoomMainView *roomMainView;

/// ViewModel
@property (strong, nonatomic) FWRoomViewModel *viewModel;
/// 房间加入状态
@property (assign, nonatomic) BOOL joinRoomStatus;
/// 房间是否被我解散，YES-是 NO-不是
@property (assign, nonatomic) BOOL WhetherDissolvedByMe;

@end

@implementation FWRoomViewController

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 隐藏顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    /// 限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    /// 禁用IQKeyboard
    [[IQKeyboardManager sharedManager] setEnable:NO];
    /// 禁用IQKeyboard的Toolbar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    /// 更改状态栏颜色为白色
    [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleLightContent];
}

#pragma mark - 页面渲染完成
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    /// 加入房间状态未标记
    if (!self.joinRoomStatus) {
        /// 数据完成设置后加入房间
        [self handleJoinRoom];
    }
}

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 更改状态栏颜色为黑色
    [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleDefault];
}

#pragma mark - 初始化操作
- (void)buildView {
    
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWRoomViewModel alloc] initWithMeetingEnterModel:self.info];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
}

#pragma mark - 加入房间
/// 加入房间
- (void)handleJoinRoom {
    
    @weakify(self);
    
    /// 设置事件回调
    [[MeetingKit sharedInstance] addDelegate:self];
    /// 标记加载状态
    self.viewModel.loading = YES;
    /// 构建加入会议参数
    SEAMeetingEnterParam *meetingEnterParam = [[SEAMeetingEnterParam alloc] init];
    meetingEnterParam.roomNo = self.viewModel.enterModel.roomNo;
    meetingEnterParam.nickname = self.viewModel.enterModel.nickname;
    meetingEnterParam.avatar = self.viewModel.enterModel.avatar;
    /// 加入房间
    [[MeetingKit sharedInstance] enterRoom:meetingEnterParam onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.viewModel.loading = NO;
        /// 获取房间标识
        NSString *roomId = (NSString *)data;
        /// 保存加入会议信息
        [[FWStoreDataBridge sharedManager] enterRoom:self.viewModel.enterModel.roomNo roomId:roomId];
        /// 设置主窗口显示状态
        self.roomMainView.hidden = NO;
        /// 标记加入房间状态
        self.joinRoomStatus = YES;
        /// 标记我未解散房间
        self.WhetherDissolvedByMe = NO;
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.viewModel.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"加入房间失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:logStr];
        SGLOG(@"%@", logStr);
        /// 加入房间失败，结束并退出当前页面
        [self exitRoom:SEALeaveReasonNormal error:code describe:message];
    }];
}

#pragma mark - 离开房间
/// 离开房间
/// - Parameter reason: 离开原因
/// - Parameter error: 错误码
/// - Parameter describe: 错误描述
- (void)exitRoom:(SEALeaveReason)reason error:(SEAError)error describe:(nullable NSString *)describe {
    
    /// 离开房间
    [[MeetingKit sharedInstance] exitRoom:nil];
    /// 清空成员列表
    [[FWRoomMemberManager sharedManager] cleanMembers];
    /// 清空聊天列表数据
    [[FWMessageManager sharedManager] cleanChatsCache];
    /// 清空房间信息缓存
    [[FWStoreDataBridge sharedManager] exitRoom];
    /// 移除加载指示框
    [SVProgressHUD dismiss];
    /// 离开房间页面
    [self pop:1];
    /// 离开房间时的警告提示弹窗
    [self exitWarnAlert:reason];
    /// 离开房间时的错误提示弹窗
    [self exitErrorAlert:error describe:describe];
}

#pragma mark - 解散房间
/// 解散房间
- (void)destroyRoom {
    
    @weakify(self);
    /// 标记我解散了房间
    self.WhetherDissolvedByMe = YES;
    /// 主持人解散房间
    [[MeetingKit sharedInstance] adminDestroyRoom:nil onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 标记我未解散房间
        self.WhetherDissolvedByMe = NO;
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求解散房间失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:toastStr];;
        SGLOG(@"%@", toastStr);
    }];
}

#pragma mark - 离开房间时的警告提示弹窗
/// 离开房间时的警告提示弹窗
/// - Parameter reason: 离开原因
- (void)exitWarnAlert:(SEALeaveReason)reason {
    
    /// 如果是主动离开会议，无需做任何提示处理
    if (reason == SEALeaveReasonNormal) {
        /// 丢弃此次回调处理
        return;
    }
    
    /// 如果是我主动解散了会议，无需做任何提示处理
    if (self.WhetherDissolvedByMe) {
        /// 丢弃此次回调处理
        return;
    }
    
    /// 声明提示信息
    NSString *message = @"您已经主动离开会议";
    switch (reason) {
        case SEALeaveReasonNormal:
            message = @"您已经主动离开会议";
            break;
        case SEALeaveReasonKickout:
            message = @"您已被管理员踢出会议";
            break;
        case SEALeaveReasonReplaced:
            message = @"您已在其它设备登录，请用新设备重新加入会议";
            break;
        case SEALeaveReasonTimeout:
            message = @"您已超时离线";
            break;
        case SEALeaveReasonDestroy:
            message = @"会议已经解散";
            break;
        default:
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    [[FWEntryBridge sharedManager].appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 离开房间时的错误提示弹窗
/// 离开房间时的错误提示弹窗
/// - Parameters:
///   - error: 错误码
///   - describe: 错误描述
- (void)exitErrorAlert:(SEAError)error describe:(nullable NSString *)describe {
    
    /// 如果没有发生错误，无需做任何提示处理
    if (error == SEAErrorOK) {
        /// 丢弃此次回调处理
        return;
    }
    
    /// 声明提示信息
    NSString *message = describe;
    if (kStringIsEmpty(describe)) {
        message = [NSString stringWithFormat:@"发生不可恢复的错误，需要您重新登录(%ld)", error];
    } else {
        message = [NSString stringWithFormat:@"%@(%ld)", describe, error];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    [[FWEntryBridge sharedManager].appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 主持人邀请开启摄像头提示弹窗
/// 主持人邀请开启摄像头提示弹窗
- (void)adminInviteOpenCameraAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"主持人邀请您开启摄像头" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"保持关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"开启摄像头" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 请求开启视频
        [self.roomMainView requestOpenVideo:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [[FWEntryBridge sharedManager].appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 主持人邀请开启麦克风提示弹窗
/// 主持人邀请开启麦克风提示弹窗
- (void)adminInviteOpenMicAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"主持人邀请您开启麦克风" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"保持关闭" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"开启麦克风" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 请求开启音频
        [self.roomMainView requestOpenAudio:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [[FWEntryBridge sharedManager].appDelegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - ----- MeetingKitDelegate 代理方法 -----
#pragma mark ----- 错误事件回调 -----
#pragma mark 错误事件回调
/// 错误事件回调
/// 发生不可恢复的错误，这个事件触发一般需要获取新的令牌重新入会。
/// - Parameters:
///   - errCode: 错误码
///   - errMsg: 错误信息
- (void)onError:(SEAError)errCode errMsg:(nullable NSString *)errMsg {
    
    /// 日志埋点
    SGLOG(@"发生了错误(%ld)，%@", errCode, errMsg);
    /// 离开房间
    [self exitRoom:SEALeaveReasonNormal error:errCode describe:errMsg];
}


#pragma mark ----- 连接事件回调 -----
#pragma mark 开始重连事件回调
/// 开始重连事件回调
/// 收到该事件说明连接出现异常，正在尝试重连，如：网络异常等。
- (void)onReconnecting {
    
    /// 日志埋点
    SGLOG(@"%@", @"服务开始重连");
    /// 提示操作信息
    NSString *toastStr = [NSString stringWithFormat:@"服务正在重连..."];
    /// 显示加载动画
    [SVProgressHUD showWithStatus:toastStr];
}

#pragma mark 重连成功事件回调
/// 重连成功事件回调
/// 当连接恢复时，会收到该事件通知。
- (void)onReconnected {
    
    /// 日志埋点
    SGLOG(@"%@", @"服务重连成功");
    /// 提示操作信息
    NSString *toastStr = [NSString stringWithFormat:@"服务重连成功"];
    /// 改变显示内容
    [SVProgressHUD setStatus:toastStr];
    /// 隐藏加载动画
    [SVProgressHUD dismissWithDelay:2.f];
}


#pragma mark ----- 我的相关回调 -----
#pragma mark 进入房间事件回调
/// 进入房间事件回调
/// 调用 enterRoom: 接口执行加入房间操作后，会收到该事件通知，如果遇到错误会通过方法的 onFailed 参数抛出。
/// - Parameters:
///   - meetingId: 会议标识
///   - userId: 用户标识
- (void)onEnterRoom:(NSString *)meetingId userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"加入房间成功，%@ %@", meetingId, userId);
    /// 成员进入房间
    [[FWRoomMemberManager sharedManager] onMemberEnterRoom:userId isMine:YES];
    /// 进入房间
    [self.roomMainView enterRoom:userId enterModel:self.viewModel.enterModel];
}

#pragma mark 离开房间事件回调
/// 离开房间事件回调
/// 当前用户非主动离开时，会收到该事件通知，如：被主持人踢出房间、会议解散等。
/// - Parameter reason: 离开原因
- (void)onExitRoom:(SEALeaveReason)reason {
    
    /// 日志埋点
    SGLOG(@"%@", @"您已经离开房间");
    /// 离开房间
    [self exitRoom:reason error:SEAErrorOK describe:nil];
}

#pragma mark 请求开启摄像头回调
/// 请求开启摄像头回调
/// 主持人调用 adminRequestUserOpenCamera: 接口执行请求打开成员摄像头后，对应成员会收到该事件通知。
/// - Parameter userId: 请求者标识
- (void)onRequestOpenCamera:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"%@", @"主持人请求你开启摄像头");
    /// 主持人邀请我开启摄像头提示弹窗
    [self adminInviteOpenCameraAlert];
}

#pragma mark 请求开启麦克风回调
/// 请求开启麦克风回调
/// 主持人调用 adminRequestUserOpenMic: 接口执行请求打开成员麦克风后，对应成员会收到该事件通知。
/// - Parameter userId: 请求者标识
- (void)onRequestOpenMic:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"%@", @"主持人请求你开启麦克风");
    /// 主持人邀请我开启麦克风提示弹窗
    [self adminInviteOpenMicAlert];
}


#pragma mark ----- 房间事件回调 -----
#pragma mark 房间摄像头禁用状态变更回调
/// 房间摄像头禁用状态变更回调
/// 主持人调用 adminUpdateRoomCameraState: 接口执行更新房间全体禁视频后，当前房间所有成员都会收到该事件通知。
/// - Parameter cameraDisabled: 房间视频禁用状态，YES-禁用 NO-不禁用
/// - Parameter selfUnmuteCameraDisabled: 是否禁止自我解除视频状态，YES-禁止 NO-不禁止
/// - Parameter userId: 操作者标识
- (void)onRoomCameraStateChanged:(BOOL)cameraDisabled selfUnmuteCameraDisabled:(BOOL)selfUnmuteCameraDisabled userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"房间摄像头禁用状态变更通知，cameraDisabled = %d selfUnmuteCameraDisabled = %d", cameraDisabled, selfUnmuteCameraDisabled);
    
    /// 获取当前用户角色
    SEAUserRole userRole = [[FWRoomMemberManager sharedManager] getUserRole];
    /// 如果当前用户为主持人
    if (userRole == SEAUserRoleHost || userRole == SEAUserRoleUnionHost) {
        /// 无需处理该回调
        return;
    }
    
    /// 获取当前用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    /// 判断主持人请求我摄像头状态
    if (cameraDisabled) {
        /// 主持人关闭我的摄像头
        /// 如果当前摄像头状态是打开的，关闭当前摄像头
        if (userModel.extend.cameraState == SEADeviceStateOpen) {
            /// 提示主持人关闭摄像头
            [SVProgressHUD showInfoWithStatus:@"主持人已将您的摄像头关闭"];
            /// 请求关闭视频
            [self.roomMainView requestCloseVideo:nil];
        }
    } else {
        /// 主持人邀请我开启摄像头提示弹窗
        [self adminInviteOpenCameraAlert];
    }
}

#pragma mark 房间麦克风禁用状态变更回调
/// 房间麦克风禁用状态变更回调
/// 主持人调用 adminUpdateRoomMicState: 接口执行更新房间全体禁音频后，当前房间所有成员都会收到该事件通知。
/// - Parameter micDisabled: 房间音频禁用状态，YES-禁用 NO-不禁用
/// - Parameter selfUnmuteMicDisabled: 是否禁止自我解除音频状态，YES-禁止 NO-不禁止
/// - Parameter userId: 操作者标识
- (void)onRoomMicStateChanged:(BOOL)micDisabled selfUnmuteMicDisabled:(BOOL)selfUnmuteMicDisabled userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"房间麦克风禁用状态变更通知，micDisabled = %d selfUnmuteMicDisabled = %d", micDisabled, selfUnmuteMicDisabled);
    /// 获取当前用户角色
    SEAUserRole userRole = [[FWRoomMemberManager sharedManager] getUserRole];
    /// 如果当前用户为主持人
    if (userRole == SEAUserRoleHost || userRole == SEAUserRoleUnionHost) {
        /// 无需处理该回调
        return;
    }
    
    /// 获取当前用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    /// 判断主持人请求我麦克风状态
    if (micDisabled) {
        /// 主持人关闭我的麦克风
        /// 如果当前麦克风状态是打开的，关闭当前麦克风
        if (userModel.extend.micState == SEADeviceStateOpen) {
            /// 提示主持人关闭麦克风
            [SVProgressHUD showInfoWithStatus:@"主持人已将您的麦克风关闭"];
            /// 请求关闭音频
            [self.roomMainView requestCloseAudio:nil];
        }
    } else {
        /// 主持人邀请我开启麦克风提示弹窗
        [self adminInviteOpenMicAlert];
    }
}

#pragma mark 房间聊天禁用状态变更回调
/// 房间聊天禁用状态变更回调
/// 主持人调用 adminUpdateRoomChatDisabled: 接口执行更新房间聊天禁用状态后，当前房间所有成员都会收到该事件通知。
/// - Parameter chatDisabled: 禁用状态，YES-禁用 NO-不禁用
/// - Parameter userId: 操作者标识
- (void)onRoomChatDisabledChanged:(BOOL)chatDisabled userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"房间聊天禁用状态变更通知，chatDisabled = %d", chatDisabled);
    /// 如果房间聊天状态禁用被解除
    if (!chatDisabled) {
        /// 提示房间聊天禁用状态已被解除
        [SVProgressHUD showInfoWithStatus:@"房间聊天禁用状态已被主持人解除。"];
    }
    /// 房间聊天禁用状态变更
    [[FWRoomMemberManager sharedManager] roomChatDisabledChanged:chatDisabled];
}

#pragma mark 房间截图禁用状态变更回调
/// 房间截图禁用状态变更回调
/// 主持人调用 adminUpdateRoomScreenshotDisabled: 接口执行更新房间截屏开关状态后，当前房间所有成员都会收到该事件通知。
/// - Parameter screenshotDisabled: 禁用状态，YES-禁用 NO-不禁用
/// - Parameter userId: 操作者标识
- (void)onRoomScreenshotDisabledChanged:(BOOL)screenshotDisabled userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"房间截图禁用状态变更通知，screenshotDisabled = %d", screenshotDisabled);
}

#pragma mark 房间水印禁用状态变更回调
/// 房间水印禁用状态变更回调
/// 主持人调用 adminUpdateRoomWatermarkDisabled: 接口执行更新房间水印开关状态后，当前房间所有成员都会收到该事件通知。
/// - Parameter watermarkDisabled: 禁用状态，YES-禁用 NO-不禁用
/// - Parameter userId: 操作者标识
- (void)onRoomWatermarkDisabledChanged:(BOOL)watermarkDisabled userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"房间水印禁用状态变更通知，watermarkDisabled = %d", watermarkDisabled);
}

#pragma mark 房间锁定状态变化回调
/// 房间锁定状态变化回调
/// 主持人调用 adminUpdateRoomLocked: 接口执行更新房间锁定状态后，当前房间所有成员都会收到该事件通知。
/// - Parameter locked: 锁定状态，YES-开启 NO-关闭
/// - Parameter userId: 操作者标识
- (void)onRoomLockedChanged:(BOOL)locked userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"房间锁定状态变化通知，locked = %d", locked);
}

#pragma mark 房间转移主持人回调
/// 房间转移主持人回调
/// 主持人调用 adminMoveHost: 接口执行主持人转移操作后，当前房间所有成员都会收到该事件通知。
/// - Parameters:
///   - userId: 新主持人用户标识
///   - sourceUserId: 原主持人用户标识
- (void)onRoomMoveHost:(NSString *)userId sourceUserId:(NSString *)sourceUserId {
    
    /// 日志埋点
    SGLOG(@"房间转移主持人通知，userId = %@ sourceUserId = %@", userId, sourceUserId);
    /// 刷新成员列表
    [[FWRoomMemberManager sharedManager] reloadMemberLists];
    
    /// 变更新主持人成员角色(更新成员操作按钮等)
    [[FWRoomMemberManager sharedManager] userRoleChanged:userId userRole:SEAUserRoleHost];
    /// 变更新主持人成员角色(顶部操作栏按钮标题等)
    [self.roomMainView userRoleChanged:userId userRole:SEAUserRoleHost];
    
    /// 变更原主持人成员角色(更新成员操作按钮等)
    [[FWRoomMemberManager sharedManager] userRoleChanged:sourceUserId userRole:SEAUserRoleNormal];
    /// 变更原主持人成员角色(顶部操作栏按钮标题等)
    [self.roomMainView userRoleChanged:sourceUserId userRole:SEAUserRoleNormal];
}

#pragma mark 共享开始回调
/// 共享开始回调
/// 成员调用 requestShare: 接口执行请求开启共享后，如果服务允许此用户开启共享操作，当前房间所有成员都会收到该事件通知，注：如果当前房间正在共享，后续加入的成员也会收到该事件通知。
/// - Parameter userId: 共享成员标识
/// - Parameter shareType: 共享类型
- (void)onRoomShareStart:(NSString *)userId shareType:(SEAShareType)shareType {
    
    /// 日志埋点
    SGLOG(@"共享开始通知，userId = %@ shareType = %ld", userId, shareType);
    /// 开始共享电子白板，更改状态栏颜色为黑色
    if (shareType == SEAShareTypeDrawing) {
        /// 更改状态栏颜色
        [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleDefault];
    }
    /// 用户开始共享
    [self.roomMainView userRoomShareStart:userId shareType:shareType];
}

#pragma mark 共享结束回调
/// 共享结束回调
/// 成员调用 stopShare: 接口执行关闭共享或者主持人调用 adminStopRoomShare: 接口执行关闭共享后，当前房间所有成员都会收到该事件通知，注：如果共享成员未结束共享直接执行退出操作，此时其他成员也会收到该事件通知。
/// - Parameter userId: 共享成员标识
/// - Parameter shareType: 共享类型
- (void)onRoomShareStop:(NSString *)userId shareType:(SEAShareType)shareType {
    
    /// 日志埋点
    SGLOG(@"共享结束通知，userId = %@", userId);
    /// 结束共享电子白板，更改状态栏颜色为白色
    if (shareType == SEAShareTypeDrawing) {
        /// 更改状态栏颜色
        [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleLightContent];
    }
    /// 用户结束共享
    [self.roomMainView userRoomStopStart:userId shareType:shareType];
}

#pragma mark 房间成员举手状态变化回调
/// 房间成员举手状态变化回调
/// 成员调用 requestHandup: 接口执行请求举手后，拥有管理权限的成员会收到该事件通知。
/// - Parameter userId: 成员标识
/// - Parameter enable: 举手状态，YES-申请举手 NO-取消举手
/// - Parameter handupType: 举手申请类型
- (void)onRoomHandUpChanged:(NSString *)userId enable:(BOOL)enable handupType:(SEAHandupType)handupType {
    
    /// 日志埋点
    SGLOG(@"房间成员举手状态变化通知，userId = %@ %@ handupType = %ld", userId, enable ? @"申请举手" : @"取消举手", handupType);
}


#pragma mark ----- 用户事件回调 -----
#pragma mark 远端用户加入房间回调
/// 远端用户加入房间回调
/// 成员调用 enterRoom: 接口执行加入房间后，当前房间所有成员都会收到该事件通知。
/// - Parameter userId: 成员标识
- (void)onUserEnter:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"远端用户加入房间通知，userId = %@", userId);
    /// 成员进入房间
    [[FWRoomMemberManager sharedManager] onMemberEnterRoom:userId isMine:NO];
    /// 刷新成员列表
    [[FWRoomMemberManager sharedManager] reloadMemberLists];
    /// 成员加入房间
    [self.roomMainView memberUserEnter:userId];
}

#pragma mark 远端用户离开房间回调
/// 远端用户离开房间回调
/// 成员调用 exitRoom: 接口执行离开房间后，当前房间所有成员都会收到该事件通知。
/// - Parameter userId: 成员标识
- (void)onUserExit:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"远端用户离开房间通知，userId = %@", userId);
    /// 成员离开房间
    [[FWRoomMemberManager sharedManager] onMemberExitRoom:userId];
    /// 刷新成员列表
    [[FWRoomMemberManager sharedManager] reloadMemberLists];
    /// 成员离开房间
    [self.roomMainView memberUserExit:userId];
}

#pragma mark 用户昵称变化回调
/// 用户昵称变化回调
/// 成员调用 updateName: 接口执行更新昵称或者主持人调用 adminUpdateNickname: 接口执行更新用户昵称后，当前房间所有成员都会收到该事件通知。
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - nickname: 用户昵称
- (void)onUserNameChanged:(NSString *)targetUserId nickname:(NSString *)nickname {
    
    /// 日志埋点
    SGLOG(@"用户昵称变化，userId = %@ nickname = %@", targetUserId, nickname);
    /// 刷新成员列表
    [[FWRoomMemberManager sharedManager] reloadMemberLists];
    /// 成员信息更新
    [[FWMessageManager sharedManager] changeMemberWithUserid:targetUserId];
    /// 成员昵称变化
    [self.roomMainView userNameChanged:targetUserId nickname:nickname];
}

#pragma mark 用户角色变化回调
/// 用户角色变化回调
/// 主持人调用 adminUpdateUserRole: 接口执行更新用户角色后，当前房间所有成员都会收到该事件通知。
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - userRole: 用户角色
- (void)onUserRoleChanged:(NSString *)targetUserId userRole:(SEAUserRole)userRole {
    
    /// 日志埋点
    SGLOG(@"用户角色变化，userId = %@ userRole = %ld", targetUserId, userRole);
    /// 刷新成员列表
    [[FWRoomMemberManager sharedManager] reloadMemberLists];
    
    /// 变更成员角色(更新成员操作按钮等)
    [[FWRoomMemberManager sharedManager] userRoleChanged:targetUserId userRole:userRole];
    /// 变更成员角色(顶部操作栏按钮标题等)
    [self.roomMainView userRoleChanged:targetUserId userRole:userRole];
}

#pragma mark 用户摄像头状态变化回调
/// 用户摄像头状态变化回调
/// 成员调用 requestOpenCamera: 或 closeCamera: 接口执行打开/关闭摄像头以及主持人调用 adminCloseUserCamera: 接口执行关闭远端用户摄像头后，当前房间所有成员都会收到该事件通知，注：当房间内已经有成员开启了摄像头，这时进入房间时也会收到该事件通知。
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - cameraState: 视频状态
- (void)onUserCameraStateChanged:(NSString *)targetUserId cameraState:(SEADeviceState)cameraState {
    
    /// 日志埋点
    SGLOG(@"用户摄像头状态变化，userId = %@ cameraState = %ld", targetUserId, cameraState);
    /// 刷新成员列表
    [[FWRoomMemberManager sharedManager] reloadMemberLists];
    /// 用户摄像头状态变化
    [self.roomMainView userCameraStateChanged:targetUserId cameraState:cameraState];
}

#pragma mark 用户麦克风状态变化回调
/// 用户麦克风状态变化回调
/// 成员调用 requestOpenMic: 或 closeMic: 接口执行打开/关闭麦克风以及主持人调用 adminCloseUserMic: 接口执行关闭远端用户麦克风后，当前房间所有成员都会收到该事件通知，注：当房间内已经有成员开启了麦克风，这时进入房间时也会收到该事件通知。
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - micState: 音频状态
- (void)onUserMicStateChanged:(NSString *)targetUserId micState:(SEADeviceState)micState {
    
    /// 日志埋点
    SGLOG(@"用户麦克风状态变化，userId = %@ micState = %ld", targetUserId, micState);
    /// 刷新成员列表
    [[FWRoomMemberManager sharedManager] reloadMemberLists];
    /// 用户麦克风状态变化
    [self.roomMainView userMicStateChanged:targetUserId micState:micState];
}

#pragma mark 用户聊天能力禁用状态变化回调
/// 用户聊天能力禁用状态变化回调
/// 主持人调用 adminUpdateUserChatDisabled: 接口对成员执行聊天禁用操作后，对应成员会收到该事件通知。
/// - Parameter chatDisabled: 禁用状态，YES-禁用 NO-不禁用
/// - Parameter userId: 操作者标识
- (void)onUserChatDisabledChanged:(BOOL)chatDisabled userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"用户聊天能力禁用状态变化，chatDisabled = %d", chatDisabled);
    /// 如果用户聊天状态禁用被解除
    if (!chatDisabled) {
        /// 提示用户解除了聊天禁用状态
        [SVProgressHUD showInfoWithStatus:@"您的聊天禁用状态已被主持人解除。"];
    }
    /// 用户聊天禁用状态变更
    [[FWRoomMemberManager sharedManager] userChatDisabledChanged:chatDisabled];
}

#pragma mark 举手处理结果回调
/// 举手处理结果回调
/// 成员通过 requestHandup: 接口执行请求举手，主持人会收到来自组件的 onRoomHandUpChanged:enable:handupType:() 事件通知；主持人通过 adminConfirmHandup:() 接口执行处理举手后，对应成员会收到该事件通知。
/// - Parameter handupType: 申请类型
/// - Parameter approve: 处理结果
/// - Parameter userId: 处理人标识
- (void)onHandupConfirm:(SEAHandupType)handupType approve:(BOOL)approve userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"举手处理结果通知(主持人回馈了你的举手操作)，handupType = %ld approve = %d", handupType, approve);
}


#pragma mark ----- 消息事件回调 -----
#pragma mark 收到聊天消息回调
/// 收到聊天消息回调
/// 成员通过 sendRoomChatMessage:() 或者 sendRoomCustomMessage:() 接口执行发送消息后，对应成员会收到该事件通知。
/// - Parameter senderId: 发送者标识
/// - Parameter message: 消息内容
/// - Parameter messageType: 消息类型
- (void)onReceiveChatMessage:(NSString *)senderId message:(NSString *)message messageType:(SEAMessageType)messageType {
    
    /// 日志埋点
    SGLOG(@"收到聊天消息，senderId = %@ message = %@ messageType = %ld", senderId, message, messageType);
    /// 根据业务要求进行处理，本示例DEMO暂时无需处理自定义消息
    if (messageType == SEAMessageTypeCustom) {
        /// 丢弃此次回调
        return;
    }
    /// 设置接收聊天消息
    [[FWMessageManager sharedManager] receiveChatWithSenderId:senderId content:message messageType:messageType];
}

#pragma mark 收到系统消息回调
/// 收到系统消息回调
/// - Parameters:
///   - message: 消息内容
///   - messageType: 消息类型
- (void)onReceiveSystemMessage:(NSString *)message messageType:(SEAMessageType)messageType {
    
    /// 日志埋点
    SGLOG(@"收到系统消息，message = %@ messageType = %ld", message, messageType);
}


#pragma mark ----- 屏幕采集事件回调 -----
#pragma mark 屏幕共享状态回调
/// 屏幕共享状态回调
/// @param status 状态码
- (void)onScreenRecordStatus:(SEAScreenRecordStatus)status {
    
    /// 日志埋点
    SGLOG(@"屏幕共享状态通知，status = %ld", status);
    
    switch (status) {
        case SEAScreenRecordStatusError:
            /// 屏幕共享连接错误
            /// [SVProgressHUD showInfoWithStatus:@"桌面采集连接失败"];
            break;
        case SEAScreenRecordStatusStop:
            /// 请求关闭房间共享
            [self.roomMainView requestStopSharing:SEAShareTypeScreen];
            break;
        case SEAScreenRecordStatusStart:
            /// 请求开始共享屏幕
            [self.roomMainView requestStartScreen];
            break;
        default:
            break;
    }
}


#pragma mark ----- 音频事件回调 -----
#pragma mark 音频路由变更回调
/// 音频路由变更回调
/// @param route 音频路由
/// @param previousRoute 变更前的音频路由
- (void)onAudioRouteChange:(SEAAudioRoute)route previousRoute:(SEAAudioRoute)previousRoute {
    
    /// 日志埋点
    SGLOG(@"音频路由变更通知，route = %ld previousRoute = %ld", route, previousRoute);
}

#pragma mark 远程成员音频状态回调
/// 远程成员音频状态回调
/// @param audioArray 成员音频列表
- (void)onRemoteMemberAudioStatus:(NSArray<RTCStreamAudioModel *> *)audioArray {
    
    /// 暂不做处理
}


#pragma mark ----- 音频事件回调 -----
#pragma mark 下行码率自适应状态回调
/// 下行码率自适应状态回调
/// @param userId 用户标识
/// @param state 下行码率自适应状态
- (void)onDownBitrateAdaptiveUserId:(NSString *)userId state:(RTCDownBitrateAdaptiveState)state {
    
    /// 暂不做处理
}

#pragma mark 上行码率自适应状态回调
/// 上行码率自适应状态回调
/// @param state 上行码率自适应状态
- (void)onUploadBitrateAdaptiveState:(RTCUploadBitrateAdaptiveState)state {
    
    /// 暂不做处理
}

#pragma mark 下行平均丢包档位变化回调
/// 下行平均丢包档位变化回调
/// @param state 下行平均丢包档位
- (void)onDownLossLevelChangeState:(RTCDownLossLevelState)state {
    
    /// 暂不做处理
}

#pragma mark 下行平均丢包率回调
/// 下行平均丢包率回调
/// @param average 下行平均丢包率
- (void)onDownLossRateAverage:(CGFloat)average {
    
    /// 暂不做处理
}

#pragma mark 流媒体发送状态数据回调
/// 流媒体发送状态数据回调
/// @param sendModel 流媒体发送状态数据
- (void)onSendStreamModel:(RTCStreamSendModel *)sendModel {
    
    /// 暂不做处理
}

#pragma mark 流媒体接收状态数据回调
/// 流媒体接收状态数据回调
/// @param receiveModel 流媒体接收状态数据
- (void)onReceiveStreamModel:(RTCStreamReceiveModel *)receiveModel {
    
    /// 暂不做处理
}


#pragma mark ----- 音频事件回调 -----
#pragma mark 应用性能使用情况回调
/// 应用性能使用情况回调
/// @param memory 内存占用
/// @param cpuUsage CUP使用率
- (void)onApplicationPerformance:(CGFloat)memory cpuUsage:(CGFloat)cpuUsage {
    
    /// 暂不做处理
}


#pragma mark - ----- FWRoomMainViewDelegate的代理方法 -----
#pragma mark 聊天事件回调
/// 聊天事件回调
/// @param mainView 主窗口视图
- (void)onChatEventMainView:(FWRoomMainView *)mainView {
    
    /// 跳转消息页面
    [self push:@"FWMessageViewController" block:nil];
}

#pragma mark 成员管理事件回调
/// 成员管理事件回调
/// @param mainView 主窗口视图
- (void)onMemberEventMainView:(FWRoomMainView *)mainView {
    
    /// 跳转参会成员页面
    [self push:@"FWMemberViewController" block:nil];
}

#pragma mark 举报事件回调
/// 举报事件回调
/// @param mainView 主窗口视图
- (void)onReportEventMainView:(FWRoomMainView *)mainView {
    
    /// 创建举报视图
    FWReportViewController *reportVC = [FWReportViewController creatReportViewWithTitle:@"举报"];
    /// 跳转举报视图
    [self presentViewController:reportVC animated:NO completion:nil];
}

#pragma mark 开启共享事件回调
/// 开启共享事件回调
/// @param mainView 主窗口视图
- (void)onStartScreenMainView:(FWRoomMainView *)mainView {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *screenAction = [UIAlertAction actionWithTitle:@"共享屏幕" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 唤醒屏幕录制组件视图
        [self.roomMainView wakeupBroadcastPickerView];
    }];
    UIAlertAction *whiteboardAction = [UIAlertAction actionWithTitle:@"共享白板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 请求开始共享电子画板
        [self.roomMainView requestStartDrawing];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:screenAction];
    [alert addAction:whiteboardAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 停止共享事件回调
/// 停止共享事件回调
/// @param mainView 主窗口视图
/// @param sharingType 共享类型
- (void)onStopScreenMainView:(FWRoomMainView *)mainView sharingType:(SEAShareType)sharingType {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要停止共享吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 请求关闭房间共享
        [self.roomMainView requestStopSharing:sharingType];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 电子画板退出回调
/// 电子画板退出回调
/// @param mainView 主窗口视图
- (void)onLeaveWhiteboardMainView:(FWRoomMainView *)mainView {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出电子画板吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 关闭房间共享电子画板
        [self.roomMainView requestStopSharing:SEAShareTypeDrawing];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 挂断事件回调
/// 挂断事件回调
/// @param mainView 主窗口视图
- (void)onHangupEventMainView:(FWRoomMainView *)mainView {
    
    /// 获取当前用户角色
    SEAUserRole userRole = [[FWRoomMemberManager sharedManager] getUserRole];
    /// 根据当前用户角色显示弹窗交互
    if (userRole == SEAUserRoleHost || userRole == SEAUserRoleUnionHost) {
        /// 主持人挂断弹窗
        [self hostHangupEventAlert];
    } else {
        /// 普通成员挂断弹窗
        [self normalHangupEventAlert];
    }
}

#pragma mark 成员选择回调
/// 成员选择回调
/// @param mainView 主窗口视图
/// @param memberModel 成员数据
- (void)mainView:(FWRoomMainView *)mainView didSelectItemAtMemberModel:(FWRoomMemberModel *)memberModel {
    
    /// TODO...
}

#pragma mark - 普通成员挂断弹窗
/// 普通成员挂断弹窗
- (void)normalHangupEventAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定离开房间吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间
        [self exitRoom:SEALeaveReasonNormal error:SEAErrorOK describe:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:leaveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 主持人挂断弹窗
/// 主持人挂断弹窗
- (void)hostHangupEventAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *finishAction = [UIAlertAction actionWithTitle:@"结束房间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 主持人解散房间弹窗
        [self hostDestroyRoomAlert];
    }];
    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"离开房间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 主持人离开房间弹窗
        [self hostLeaveRoomAlert];
    }];
    [alert addAction:cancelAction];
    [alert addAction:finishAction];
    [alert addAction:leaveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 主持人离开房间弹窗
/// 主持人离开房间弹窗
- (void)hostLeaveRoomAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"离开房间后，将无主持人" message:@"离开后会造成无人管理房间秩序，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确认离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间
        [self exitRoom:SEALeaveReasonNormal error:SEAErrorOK describe:nil];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 主持人解散房间弹窗
/// 主持人解散房间弹窗
- (void)hostDestroyRoomAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"结束房间" message:@"结束房间，正在房间的人员将全部退出。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 解散房间
        [self destroyRoom];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 资源释放
- (void)dealloc {
    
    /// 启用IQKeyboard
    [[IQKeyboardManager sharedManager] setEnable:YES];
    /// 启用IQKeyboard的Toolbar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    /// 取消限制锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    /// 移除所有监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
