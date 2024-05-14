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
            [FWToastBridge showToastAction];
        } else {
            [FWToastBridge hiddenToastAction];
        }
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [FWToastBridge showToastAction:message];
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
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 恢复加载状态
        self.viewModel.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"创建房间失败 code = %ld, message = %@", code, message];
        [FWToastBridge showToastAction:logStr];
        SGLOG(@"%@", logStr);
        /// 加入房间失败，结束并退出当前页面
        [self joinRoomFailAlert:code];
    }];
}


#pragma mark - ----- MeetingKitDelegate 代理方法 -----
#pragma mark ----- 错误事件回调 -----
#pragma mark 错误事件回调
/// 错误事件回调
/// - Parameters:
///   - errCode: 错误码
///   - errMsg: 错误信息
- (void)onError:(SEAError)errCode errMsg:(nullable NSString *)errMsg {
    
    /// 日志埋点
    SGLOG(@"发生了错误(%ld)，%@", errCode, errMsg);
}


#pragma mark ----- 连接事件回调 -----
#pragma mark 连接成功回调
/// 连接成功回调
- (void)onConnected {
    
    /// 日志埋点
    SGLOG(@"%@", @"服务已经连接");
}

#pragma mark 连接断开回调
/// 连接断开回调
- (void)onDisconnected {
    
    /// 日志埋点
    SGLOG(@"%@", @"服务已经断开");
}


#pragma mark ----- 房间事件回调 -----
#pragma mark 进入房间事件回调
/// 进入房间事件回调
/// - Parameters:
///   - roomId: 房间标识
///   - userId: 用户标识
- (void)onRoomEnter:(NSString *)roomId userId:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"加入房间成功，%@ %@", roomId, userId);
    /// 成员进入房间
    [[FWRoomMemberManager sharedManager] onMemberEnterRoom:userId isMine:YES];
    /// 获取默认音频状态
    BOOL audioState = self.viewModel.enterModel.audioState;
    /// 获取默认视频状态
    BOOL videoState = self.viewModel.enterModel.videoState;
    /// 设置默认音视频状态
    [self.roomMainView setupDefaultAudioState:audioState videoState:videoState];
}

#pragma mark 共享开始回调
/// 共享开始回调
/// - Parameter userId: 共享成员标识
/// - Parameter shareType: 共享类型
/// - Parameter userModel: 发送成员信息
- (void)onRoomShareStart:(NSString *)userId shareType:(SEAShareType)shareType userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"共享开始通知，userId = %@ shareType = %ld", userId, shareType);
}

#pragma mark 共享结束回调
/// 共享结束回调
/// - Parameter userId: 成员标识
/// - Parameter userModel: 发送成员信息
- (void)onRoomShareStop:(NSString *)userId userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"共享结束通知，userId = %@", userId);
}

#pragma mark 房间举手状态变化回调
/// 房间举手状态变化回调
/// - Parameter userId: 成员标识
/// - Parameter enable: 举手状态，YES-申请举手 NO-取消举手
/// - Parameter handupType: 举手申请类型
/// - Parameter userModel: 发送成员信息
- (void)onRoomHandUpChanged:(NSString *)userId enable:(BOOL)enable handupType:(SEAHandupType)handupType userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间举手状态变化通知，userId = %@ %@ handupType = %ld", userId, enable ? @"申请举手" : @"取消举手", handupType);
}

#pragma mark 房间被解散回调
/// 房间被解散回调
/// - Parameter userModel: 发送成员信息
- (void)onRoomDestroy:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间被解散通知");
}

#pragma mark 房间摄像头禁用状态变更回调
/// 房间摄像头禁用状态变更回调
/// - Parameter cameraDisabled: 进入房间是否关闭视频，YES-关闭 NO-不关闭
/// - Parameter selfUnmuteCameraDisabled: 是否允许自我解除，YES-允许 NO-不允许
/// - Parameter userModel: 发送成员信息
- (void)onRoomCameraStateChanged:(BOOL)cameraDisabled selfUnmuteCameraDisabled:(BOOL)selfUnmuteCameraDisabled userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间摄像头禁用状态变更通知，cameraDisabled = %d selfUnmuteCameraDisabled = %d", cameraDisabled, selfUnmuteCameraDisabled);
}

#pragma mark 房间麦克风禁用状态变更回调
/// 房间麦克风禁用状态变更回调
/// - Parameter micDisabled: 进入房间是否关闭音频，YES-关闭 NO-不关闭
/// - Parameter selfUnmuteMicDisabled: 是否允许自我解除，YES-允许 NO-不允许
/// - Parameter userModel: 发送成员信息
- (void)onRoomMicStateChanged:(BOOL)micDisabled selfUnmuteMicDisabled:(BOOL)selfUnmuteMicDisabled userModel:(nullable RTCEngineUserModel *)userModelm {
    
    /// 日志埋点
    SGLOG(@"房间麦克风禁用状态变更通知，micDisabled = %d selfUnmuteMicDisabled = %d", micDisabled, selfUnmuteMicDisabled);
}

#pragma mark 房间聊天禁用状态变更回调
/// 房间聊天禁用状态变更回调
/// - Parameter chatDisabled: 禁用状态，YES-禁用 NO-不禁用
/// - Parameter userModel: 发送成员信息
- (void)onRoomChatDisabledChanged:(BOOL)chatDisabled userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间聊天禁用状态变更通知，chatDisabled = %d", chatDisabled);
}

#pragma mark 房间截图禁用状态变更回调
/// 房间截图禁用状态变更回调
/// - Parameter screenshotDisabled: 禁用状态，YES-禁用 NO-不禁用
/// - Parameter userModel: 发送成员信息
- (void)onRoomScreenshotDisabledChanged:(BOOL)screenshotDisabled userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间截图禁用状态变更通知，screenshotDisabled = %d", screenshotDisabled);
}

#pragma mark 房间水印禁用状态变更回调
/// 房间水印禁用状态变更回调
/// - Parameter watermarkDisabled: 水印状态，YES-开启 NO-关闭
/// - Parameter userModel: 发送成员信息
- (void)onRoomWatermarkDisabledChanged:(BOOL)watermarkDisabled userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间水印禁用状态变更通知，watermarkDisabled = %d", watermarkDisabled);
}

#pragma mark 房间锁定状态变化回调
/// 房间锁定状态变化回调
/// - Parameter locked: 锁定状态，YES-开启 NO-关闭
/// - Parameter userModel: 发送成员信息
- (void)onRoomLockedChanged:(BOOL)locked userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间锁定状态变化通知，locked = %d", locked);
}

#pragma mark 房间转移主持人回调
/// 房间转移主持人回调
/// - Parameters:
///   - userId: 新主持人用户标识
///   - sourceUserId: 原主持人用户标识
///   - userModel: 发送成员信息
- (void)onRoomMoveHost:(NSString *)userId sourceUserId:(NSString *)sourceUserId userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间转移主持人通知，userId = %@ sourceUserId = %@", userId, sourceUserId);
}

#pragma mark 房间踢出成员回调
/// 房间踢出成员回调
/// - Parameters:
///   - userId: 成员标识
///   - userModel: 发送成员信息
- (void)onRoomKickedOut:(NSString *)userId userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"房间踢出成员通知，userId = %@", userId);
}


#pragma mark ----- 用户事件回调 -----
#pragma mark 远端用户加入房间回调
/// 远端用户加入房间回调
/// - Parameter userId: 成员标识
- (void)onUserEnter:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"远端用户加入房间通知，userId = %@", userId);
    /// 成员进入房间
    [[FWRoomMemberManager sharedManager] onMemberEnterRoom:userId isMine:NO];
    /// 成员加入房间
    [self.roomMainView memberUserEnter:userId];
}

#pragma mark 远端用户离开房间回调
/// 远端用户离开房间回调
/// - Parameter userId: 成员标识
- (void)onUserExit:(NSString *)userId {
    
    /// 日志埋点
    SGLOG(@"远端用户离开房间通知，userId = %@", userId);
    /// 成员离开房间
    [[FWRoomMemberManager sharedManager] onMemberExitRoom:userId];
    /// 成员离开房间
    [self.roomMainView memberUserExit:userId];
}

#pragma mark 用户昵称变化回调
/// 用户昵称变化回调
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - userModel: 发送成员信息
///   - nickname: 用户昵称
- (void)onUserNameChanged:(NSString *)targetUserId userModel:(nullable RTCEngineUserModel *)userModel nickname:(NSString *)nickname {
    
    /// 日志埋点
    SGLOG(@"用户昵称变化，userId = %@ nickname = %@", targetUserId, nickname);
}

#pragma mark 用户角色变化回调
/// 用户角色变化回调
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - userModel: 发送成员信息
///   - userRole: 用户角色
- (void)onUserRoleChanged:(NSString *)targetUserId userModel:(nullable RTCEngineUserModel *)userModel userRole:(SEAUserRole)userRole {
    
    /// 日志埋点
    SGLOG(@"用户角色变化，userId = %@ userRole = %ld", targetUserId, userRole);
}

#pragma mark 用户摄像头状态变化回调
/// 用户摄像头状态变化回调
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - userModel: 发送成员信息
///   - cameraDisabled: 预留字段
///   - cameraState: 视频状态
- (void)onUserCameraStateChanged:(NSString *)targetUserId userModel:(nullable RTCEngineUserModel *)userModel cameraDisabled:(BOOL)cameraDisabled cameraState:(SEADeviceState)cameraState {
    
    /// 日志埋点
    SGLOG(@"用户摄像头状态变化，userId = %@ cameraState = %ld", targetUserId, cameraState);
    /// 用户摄像头状态变化
    [self.roomMainView userCameraStateChanged:targetUserId cameraState:cameraState];
}

#pragma mark 用户麦克风状态变化回调
/// 用户麦克风状态变化回调
/// - Parameters:
///   - targetUserId: 目标成员标识
///   - userModel: 发送成员信息
///   - micDisabled: 预留字段
///   - micState: 音频状态
- (void)onUserMicStateChanged:(NSString *)targetUserId userModel:(nullable RTCEngineUserModel *)userModel micDisabled:(BOOL)micDisabled micState:(SEADeviceState)micState {
    
    /// 日志埋点
    SGLOG(@"用户麦克风状态变化，userId = %@ micState = %ld", targetUserId, micState);
    /// 用户麦克风状态变化
    [self.roomMainView userMicStateChanged:targetUserId micState:micState];
}

#pragma mark 用户聊天能力禁用状态变化回调
/// 用户聊天能力禁用状态变化回调
/// - Parameter targetUserId: 目标成员标识
/// - Parameter chatDisabled: 禁用状态，YES-禁用 NO-不禁用
/// - Parameter userModel: 发送成员信息
- (void)onUserChatDisabledChanged:(NSString *)targetUserId chatDisabled:(BOOL)chatDisabled userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"用户聊天能力禁用状态变化，userId = %@ chatDisabled = %d", targetUserId, chatDisabled);
}

#pragma mark 举手处理结果回调
/// 举手处理结果回调
/// - Parameter targetUserId: 目标成员标识
/// - Parameter handupType: 申请类型
/// - Parameter approve: 处理结果
/// - Parameter userModel: 发送成员信息
- (void)onHandupConfirm:(NSString *)targetUserId handupType:(SEAHandupType)handupType approve:(BOOL)approve userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"举手处理结果通知，userId = %@ handupType = %ld approve = %d", targetUserId, handupType, approve);
}


#pragma mark ----- 消息事件回调 -----
#pragma mark 收到聊天消息回调
/// 收到聊天消息回调
/// - Parameter senderId: 发送者标识
/// - Parameter message: 消息内容
/// - Parameter messageType: 消息类型
/// - Parameter userModel: 发送成员信息
- (void)onReceiveChatMessage:(NSString *)senderId message:(NSString *)message messageType:(SEAMessageType)messageType userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 设置接收聊天消息
    [[FWMessageManager sharedManager] receiveChatWithAccountModel:userModel content:message messageType:messageType];
    /// 日志埋点
    SGLOG(@"收到聊天消息，senderId = %@ message = %@ messageType = %ld", senderId, message, messageType);
}

#pragma mark 收到自定义消息回调
/// 收到自定义消息回调
/// - Parameters:
///   - senderId: 发送者标识
///   - content: 自定义消息内容
///   - userModel: 发送成员信息
- (void)onReceiveCustomMessage:(NSString *)senderId content:(NSString *)content userModel:(nullable RTCEngineUserModel *)userModel {
    
    /// 日志埋点
    SGLOG(@"收到自定义消息，senderId = %@ content = %@", senderId, content);
}


#pragma mark ----- 屏幕采集事件回调 -----
#pragma mark 屏幕共享状态回调
/// 屏幕共享状态回调
/// @param status 状态码
- (void)onScreenRecordStatus:(RTCScreenRecordStatus)status {
    
    /// 日志埋点
    SGLOG(@"屏幕共享状态通知，status = %ld", status);
}


#pragma mark ----- 音频事件回调 -----
#pragma mark 音频路由变更回调
/// 音频路由变更回调
/// @param route 音频路由
/// @param previousRoute 变更前的音频路由
- (void)onAudioRouteChange:(RTCAudioRoute)route previousRoute:(RTCAudioRoute)previousRoute {
    
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
        /// 请求开启房间共享(共享屏幕)
        [self.roomMainView requestStartSharing:FWMeetingSharingTypeScreen];
    }];
    UIAlertAction *whiteboardAction = [UIAlertAction actionWithTitle:@"共享白板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 更改状态栏颜色为黑色
        [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleDefault];
        /// 请求开启房间共享(共享白板)
        [self.roomMainView requestStartSharing:FWMeetingSharingTypeWhiteboard];
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
- (void)onStopScreenMainView:(FWRoomMainView *)mainView sharingType:(FWMeetingSharingType)sharingType {
    
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
        /// 更改状态栏颜色为白色
        [self statusBarAppearanceUpdateWithHiden:NO barStyle:UIStatusBarStyleLightContent];
        /// 关闭房间共享电子画板
        [self.roomMainView requestStopSharing:FWMeetingSharingTypeWhiteboard];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 挂断事件回调
/// 挂断事件回调
/// @param mainView 主窗口视图
- (void)onHangupEventMainView:(FWRoomMainView *)mainView {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定离开房间吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间
        [self leaveRoom];
    }];
    [alert addAction:cancelAction];
    [alert addAction:leaveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 成员选择回调
/// 成员选择回调
/// @param mainView 主窗口视图
/// @param memberModel 成员信息
/// @param userId 成员标识
- (void)mainView:(FWRoomMainView *)mainView didSelectItemMemberModel:(FWRoomMemberModel *)memberModel didUserId:(NSString *)userId {
    
    /// 订阅成员轨道弹窗
    /// [self subscribeMemberAlert:memberModel];
}


#pragma mark - 修改成员信息弹窗
/// 修改成员信息弹窗
- (void)changeUserInfoAlert {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改成员信息" message:nil preferredStyle:isPhone ? UIAlertControllerStyleActionSheet : UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *nameAction = [UIAlertAction actionWithTitle:@"修改昵称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 修改昵称二次弹窗
        [self changeNameAlert];
    }];
    [alert addAction:cancelAction];
    [alert addAction:nameAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 修改昵称二次弹窗
/// 修改昵称二次弹窗
- (void)changeNameAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    /// 在对话框中添加输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.borderStyle = UITextBorderStyleNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"请输入新昵称";
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        /// 获取新昵称
        NSString *name = [[alert textFields] lastObject].text;
        /// 移除字符串两侧空格
        name = [FWToolBridge clearMarginsBlank:name];
        if (kStringIsEmpty(name)) {
            /// 提示操作信息
            [FWToastBridge showToastAction:@"用户昵称不能为空"];
            return;
        }
        
        if (![name isContentEffective]) {
            /// 提示操作信息
            [FWToastBridge showToastAction:@"用户昵称包含无效字符"];
            return;
        }
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 离开房间
/// 离开房间
- (void)leaveRoom {
    
//    @weakify(self);
//    /// 主持人解散房间
//    [[MeetingKit sharedInstance] adminDestroyRoom:^(id  _Nullable data) {
//        @strongify(self);
//        /// 清空房间信息缓存
//        [[FWStoreDataBridge sharedManager] exitRoom];
//        /// 离开房间页面
//        [self pop:1];
//    } onFailed:^(SEAError code, NSString * _Nonnull message) {
//        /// 构造日志信息
//        NSString *toastStr = [NSString stringWithFormat:@"请求结束会议失败 code = %ld, message = %@", code, message];
//        [FWToastBridge showToastAction:toastStr];;
//        SGLOG(@"%@", toastStr);
//    }];
    
    @weakify(self);
    /// 离开房间
    [[MeetingKit sharedInstance] exitRoom:^(id  _Nullable data) {
        @strongify(self);
        /// 清空成员列表
        [[FWRoomMemberManager sharedManager] cleanMembers];
        /// 清空聊天列表数据
        [[FWMessageManager sharedManager] cleanChatsCache];
        /// 清空房间信息缓存
        [[FWStoreDataBridge sharedManager] exitRoom];
        /// 离开房间页面
        [self pop:1];
    }];
}

#pragma mark - 加入房间失败
- (void)joinRoomFailAlert:(SEAError)errorCode {
    
    @weakify(self);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"加入房间失败(%ld)", errorCode] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 离开房间页面
        [self pop:1];
    }];
    [alert addAction:cancelAction];
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
