//
//  FWRoomMainView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomMainView.h"
#import "FWRoomTopView.h"
#import "FWRoomBottomView.h"
#import "FWRoomMemberView.h"
#import "FWRoomCaptureView.h"
#import "FWRoomWhiteboardView.h"

/// 房间持续时长统计周期
#define FW_ROOM_DURATION_TIMER_CYCLE 1.0
/// 房间持续时长统计队列
#define FW_ROOM_DURATION_QUEUE "cn.seastart.meetingkit.duration.queue"

@interface FWRoomMainView() <FWRoomMemberViewDelegate, FWRoomTopViewDelegate, FWRoomBottomViewDelegate, FWRoomWhiteboardViewDelegate>

/// 视图容器
@property (strong, nonatomic) UIView *contentView;

/// 采集渲染视图
@property (weak, nonatomic) IBOutlet FWRoomCaptureView *roomCaptureView;
/// 成员列表视图
@property (weak, nonatomic) IBOutlet FWRoomMemberView *roomMemberView;
/// 电子画板视图
@property (weak, nonatomic) IBOutlet FWRoomWhiteboardView *whiteboardView;

/// 顶部工具视图
@property (weak, nonatomic) IBOutlet UIView *roomTopView;
/// 顶部工具栏
@property (weak, nonatomic) IBOutlet FWRoomTopView *roomTopTool;
/// 性能信息标签
@property (weak, nonatomic) IBOutlet UILabel *performanceLabel;
/// 底部工具视图
@property (weak, nonatomic) IBOutlet UIView *roomBottomView;
/// 底部工具栏
@property (weak, nonatomic) IBOutlet FWRoomBottomView *roomBottomTool;

/// 共享类型
@property (assign, nonatomic) FWMeetingSharingType sharingType;

/// 房间计时器
@property (strong, nonatomic) FWTimerBridge *durationTimer;
/// 屏幕共享状态
@property (nonatomic, assign, readwrite) BOOL screenShareStatus;
/// 屏幕录制组件
@property (strong, nonatomic) RPSystemBroadcastPickerView *broadcastPickerView;
/// 是否进入宫格模式，YES-宫格 NO-非宫格
@property (assign, nonatomic) BOOL palaceMode;

@end

@implementation FWRoomMainView

#pragma mark - 初始化视图
/// 初始化视图
- (instancetype)init {

    self = [super init];
    if (self) {
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 初始化视图
/// 初始化视图
/// @param aDecoder 解码器
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        /// 配置属性
        [self setupConfig];
    }
    return self;
}

#pragma mark - 懒加载屏幕录制组件
- (RPSystemBroadcastPickerView *)broadcastPickerView API_AVAILABLE(ios(12.0)) {
    
    if (!_broadcastPickerView) {
        _broadcastPickerView = [[RPSystemBroadcastPickerView alloc] init];
        _broadcastPickerView.preferredExtension = @"cn.seastart.meetingkit.replayBroadcastUpload";
        _broadcastPickerView.showsMicrophoneButton = NO;
        _broadcastPickerView.hidden = YES;
    }
    return _broadcastPickerView;
}

#pragma mark - 配置属性
/// 配置属性
- (void)setupConfig {
    
    /// 设置默认共享类型
    self.sharingType = FWMeetingSharingTypeNormal;
    /// 启动计时器
    [self beginTimer];
}

#pragma mark - 启动计时器
/// 启动计时器
- (void)beginTimer {
    
    @weakify(self);
    
    /// 声明房间持续时长
    __block NSInteger duration = 0;
    /// 创建并启动计时器
    self.durationTimer = [FWTimerBridge scheduledTimerWithTimeInterval:(FW_ROOM_DURATION_TIMER_CYCLE * NSEC_PER_SEC) repeats:YES queue:dispatch_queue_create(FW_ROOM_DURATION_QUEUE, NULL) block:^{
        @strongify(self);
        /// 递增房间持续时长
        duration++;
        /// 返回主队列更新视图
        FWDispatchAscyncOnMainQueue(^{
            /// 处理房间计时器周期
            [self handleTimerWithDuration:duration];
        });
    }];
}

#pragma mark - 处理房间计时器周期
/// 处理房间计时器周期
/// - Parameter duration: 房间持续时长
- (void)handleTimerWithDuration:(NSInteger)duration {
    
    /// 更新进入房间时长与房间号码显示
    [self.roomTopTool setupDataWithDuration:duration roomNoText:[FWStoreDataBridge sharedManager].roomNo];
}

#pragma mark - 销毁计时器
/// 销毁计时器
- (void)invalidateTimer {
    
    /// 关闭房间计时器
    if (self.durationTimer) {
        /// 释放计时器
        [self.durationTimer invalidate];
        /// 置空计时器
        self.durationTimer = nil;
    }
}

#pragma mark - 唤醒屏幕录制组件视图
/// 唤醒屏幕录制组件视图
- (void)wakeupBroadcastPickerView {
    
    /// 将事件传递给屏幕录制组件的开启录制按钮
    for (UIView *view in self.broadcastPickerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - 唤起电子画板组件视图
/// 唤起电子画板组件视图
- (void)wakeupWhiteboardView {
    
    @weakify(self);
    /// 用户请求开启共享
    [[MeetingKit sharedInstance] requestShare:SEAShareTypeDrawing onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 显示画板视图
        [self.whiteboardView showView:@"https://dev.srtc.live:9000/www/wb" userId:[FWStoreDataBridge sharedManager].userModel.data.userId roomNo:[FWStoreDataBridge sharedManager].roomNo readwrite:YES];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求开启共享失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:toastStr];;
        SGLOG(@"%@", toastStr);
    }];
}

#pragma mark - 隐藏电子画板组件视图
/// 隐藏电子画板组件视图
- (void)hiddenWhiteboardView {
    
    @weakify(self);
    /// 用户关闭共享
    [[MeetingKit sharedInstance] stopShare:^(id  _Nullable data) {
        @strongify(self);
        /// 隐藏画板视图
        [self.whiteboardView hiddenView];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求关闭共享失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:toastStr];;
        SGLOG(@"%@", toastStr);
    }];
}

#pragma mark - 请求开启房间共享
/// 请求开启房间共享
/// - Parameter sharingType: 共享类型
- (void)requestStartSharing:(FWMeetingSharingType)sharingType {
    
    /// 保存共享类型
    self.sharingType = sharingType;
    /// 根据目标共享类型处理请求
    switch (sharingType) {
            /// 共享屏幕
        case FWMeetingSharingTypeScreen: {
            /// 唤醒屏幕录制组件视图
            [self wakeupBroadcastPickerView];
        }
            break;
            /// 共享白板
        case FWMeetingSharingTypeWhiteboard: {
            /// 唤起电子画板组件视图
            [self wakeupWhiteboardView];
        }
            break;
        default:
            break;
    }
    /// 设置共享按钮选中状态
    [self.roomBottomTool setupShareButtonSelected:YES];
}

#pragma mark - 请求关闭房间共享
/// 请求关闭房间共享
/// - Parameter sharingType: 共享类型
- (void)requestStopSharing:(FWMeetingSharingType)sharingType {
    
    /// 重置共享类型
    self.sharingType = FWMeetingSharingTypeNormal;
    /// 创建提示信息
    NSString *toastStr = @"已停止共享屏幕";
    /// 根据目标共享类型处理请求
    switch (sharingType) {
            /// 共享屏幕
        case FWMeetingSharingTypeScreen: {
            /// 重置提示信息
            toastStr = @"已停止共享屏幕";
        }
            break;
            /// 共享白板
        case FWMeetingSharingTypeWhiteboard: {
            /// 隐藏电子画板组件视图
            [self hiddenWhiteboardView];
            /// 重置提示信息
            toastStr = @"已停止共享白板";
        }
            break;
        default:
            break;
    }
    /// 交互提示
    [SVProgressHUD showInfoWithStatus:toastStr];
    /// 设置共享按钮选中状态
    [self.roomBottomTool setupShareButtonSelected:NO];
}

#pragma mark - 进入房间
/// 进入房间
/// - Parameter userId: 用户标识
/// - Parameter enterModel: 加入房间信息
- (void)enterRoom:(NSString *)userId enterModel:(FWMeetingEnterModel *)enterModel {
    
    /// 获取默认音频状态
    BOOL audioState = enterModel.audioState;
    /// 获取默认视频状态
    BOOL videoState = enterModel.videoState;
    /// 设置默认音视频状态
    [self setupDefaultAudioState:audioState videoState:videoState];
    /// 进入房间成功
    [self.roomMemberView enterRoom:userId];
}

#pragma mark - 设置默认音视频状态
/// 设置默认音视频状态
/// - Parameters:
///   - audioState: 音频状态
///   - videoState: 视频状态
- (void)setupDefaultAudioState:(BOOL)audioState videoState:(BOOL)videoState {
    
    /// 设置默认音频状态
    [self.roomBottomTool setupDefaultAudioState:audioState];
    /// 设置默认视频状态
    [self.roomBottomTool setupDefaultVideoState:videoState];
}

#pragma mark - 成员加入房间
/// 成员加入房间
/// - Parameter userId: 成员标识
- (void)memberUserEnter:(NSString *)userId {
    
    /// 获取成员数
    NSInteger membersCount = [FWRoomMemberManager sharedManager].getAllMembers.count;
    /// 当前成员数大于等于 2 时，显示宫格列表视图
    if (membersCount >= 2) {
        /// 隐藏采集渲染视图
        self.roomCaptureView.hidden = YES;
        /// 显示成员列表视图
        self.roomMemberView.hidden = NO;
        /// 该成员进入之前，房间内只有当前成员
        if (membersCount == 2) {
            /// 标记当前为宫格模式
            self.palaceMode = YES;
            /// 更新本地摄像头的预览画面
            [[MeetingKit sharedInstance] updateLocalView:[self.roomMemberView.mineWindowView getPlayerWindow]];
        }
    }
    /// 成员更新信息
    [self.roomMemberView memberUpdateWithUserId:userId];
}

#pragma mark - 成员离开房间
/// 成员离开房间
/// - Parameter userId: 成员标识
- (void)memberUserExit:(NSString *)userId {
    
    /// 获取成员数
    NSInteger membersCount = [FWRoomMemberManager sharedManager].getAllMembers.count;
    /// 当前成员数小于等于 1 时，显示采集渲染视图
    if (membersCount <= 1) {
        /// 标记当前为非宫格模式
        self.palaceMode = NO;
        /// 显示采集渲染视图
        self.roomCaptureView.hidden = NO;
        /// 隐藏成员列表视图
        self.roomMemberView.hidden = YES;
        /// 更新本地摄像头的预览画面
        [[MeetingKit sharedInstance] updateLocalView:[self.roomCaptureView getPreview]];
    }
    /// 成员离开房间
    [self.roomMemberView memberExitWithUserId:userId];
}

#pragma mark - 用户摄像头状态变化
/// 用户摄像头状态变化
/// @param userId 成员标识
/// @param cameraState 视频状态
- (void)userCameraStateChanged:(NSString *)userId cameraState:(SEADeviceState)cameraState {
    
    /// 用户摄像头状态变化
    [self.roomMemberView userCameraStateChanged:userId cameraState:cameraState];
}

#pragma mark - 用户麦克风状态变化
/// 用户麦克风状态变化
/// @param userId 成员标识
/// @param micState 音频状态
- (void)userMicStateChanged:(NSString *)userId micState:(SEADeviceState)micState {
    
    /// 用户麦克风状态变化
    [self.roomMemberView userMicStateChanged:userId micState:micState];
}

#pragma mark - 用户共享状态变化
/// 用户共享状态变化
/// @param userId 成员标识
/// @param enabled 变更状态，YES-开启 NO-关闭
/// @param shareType 共享类型
- (void)userShareStateChanged:(NSString *)userId enabled:(BOOL)enabled shareType:(SEAShareType)shareType {
    
    /// 用户共享状态变化
    [self.roomMemberView userShareStateChanged:userId enabled:enabled shareType:shareType];
}

#pragma mark - 请求开启视频
/// 请求开启视频
/// - Parameter source: 事件源对象
- (void)requestOpenVideo:(UIButton *)source {
    
    @weakify(self);
    /// 获取预览视图
    UIView *preview = self.palaceMode ? [self.roomMemberView.mineWindowView getPlayerWindow] : [self.roomCaptureView getPreview];
    /// 用户请求打开摄像头
    [[MeetingKit sharedInstance] requestOpenCamera:YES view:preview onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 开启摄像头预览
        [self.roomCaptureView startLocalPreview];
        /// 切换源按钮选中状态
        source.selected = !source.selected;
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求开启视频失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:toastStr];;
        SGLOG(@"%@", toastStr);
    }];
}

#pragma mark - 请求关闭视频
/// 请求关闭视频
/// - Parameter source: 事件源对象
- (void)requestCloseVideo:(UIButton *)source {
    
    @weakify(self);
    /// 用户关闭摄像头
    [[MeetingKit sharedInstance] closeCamera:^(id  _Nullable data) {
        @strongify(self);
        /// 停止摄像头预览
        [self.roomCaptureView stopLocalPreview];
        /// 切换源按钮选中状态
        source.selected = !source.selected;
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求关闭视频失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:toastStr];;
        SGLOG(@"%@", toastStr);
    }];
}

#pragma mark - 请求开启音频
/// 请求开启音频
/// - Parameter source: 事件源对象
- (void)requestOpenAudio:(UIButton *)source {
    
    @weakify(self);
    /// 用户请求打开麦克风
    [[MeetingKit sharedInstance] requestOpenMic:^(id  _Nullable data) {
        @strongify(self);
        /// 开启音频发送
        [self.roomCaptureView startSendAudio];
        /// 切换源按钮选中状态
        source.selected = !source.selected;
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求开启音频失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:toastStr];;
        SGLOG(@"%@", toastStr);
    }];
}

#pragma mark - 请求关闭音频
/// 请求关闭音频
/// - Parameter source: 事件源对象
- (void)requestCloseAudio:(UIButton *)source {
    
    @weakify(self);
    /// 用户关闭麦克风
    [[MeetingKit sharedInstance] closeMic:^(id  _Nullable data) {
        @strongify(self);
        /// 停止音频发送
        [self.roomCaptureView stopSendAudio];
        /// 切换源按钮选中状态
        source.selected = !source.selected;
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求关闭音频失败 code = %ld, message = %@", code, message];
        [SVProgressHUD showInfoWithStatus:toastStr];;
        SGLOG(@"%@", toastStr);
    }];
}


#pragma mark - ----- FWRoomTopViewDelegate的代理方法 -----
#pragma mark 扬声器事件回调
/// 扬声器事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectSpeakerButton:(UIButton *)source {
    
    /// 设置扬声器状态
    [[MeetingKit sharedInstance] switchSpeaker:source.selected];
    /// 切换源按钮选中状态
    source.selected = !source.selected;
}

#pragma mark 摄像头事件回调
/// 摄像头事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectCameraButton:(UIButton *)source {
    
    /// 开启摄像头预览
    [self.roomCaptureView switchCamera];
}

#pragma mark 举报事件回调
/// 举报事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectReportButton:(UIButton *)source {
    
    /// 回调控制器层处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(onReportEventMainView:)]) {
        [self.delegate onReportEventMainView:self];
    }
}

#pragma mark 挂断事件回调
/// 挂断事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectHangupButton:(UIButton *)source {
    
    /// 回调控制器层处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(onHangupEventMainView:)]) {
        [self.delegate onHangupEventMainView:self];
    }
}

#pragma mark - ----- FWRoomBottomViewDelegate的代理方法 -----
#pragma mark 音频控制事件回调
/// 音频控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectAudioButton:(UIButton *)source {
    
    @weakify(self);
    /// 检测麦克风权限
    [FWToolBridge requestAuthorization:FWPermissionsStateAudio superVC:[FWEntryBridge sharedManager].appDelegate.window.rootViewController result:^(BOOL status) {
        @strongify(self);
        if (status) {
            /// 分辨请求开启还是关闭音频
            if (source.selected) {
                /// 请求开启音频
                [self requestOpenAudio:source];
            } else {
                /// 请求关闭音频
                [self requestCloseAudio:source];
            }
        }
    }];
}

#pragma mark 视频控制事件回调
/// 视频控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectVideoButton:(UIButton *)source {
    
    @weakify(self);
    /// 检测摄像头权限
    [FWToolBridge requestAuthorization:FWPermissionsStateVideo superVC:[FWEntryBridge sharedManager].appDelegate.window.rootViewController result:^(BOOL status) {
        @strongify(self);
        if (status) {
            /// 分辨请求开启还是关闭视频
            if (source.selected) {
                /// 请求开启视频
                [self requestOpenVideo:source];
            } else {
                /// 请求关闭视频
                [self requestCloseVideo:source];
            }
        }
    }];
}

#pragma mark 共享控制事件回调
/// 共享控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectSharingButton:(UIButton *)source {
    
    /// 根据当前共享状态处理请求回调
    if (self.sharingType == FWMeetingSharingTypeNormal) {
        /// 如果当前共享类型为常规类型(回调请求开启共享)
        if (self.delegate && [self.delegate respondsToSelector:@selector(onStartScreenMainView:)]) {
            [self.delegate onStartScreenMainView:self];
        }
    } else {
        /// 如果当前共享类型非常规类型(回调请求关闭共享)
        if (self.delegate && [self.delegate respondsToSelector:@selector(onStopScreenMainView:sharingType:)]) {
            [self.delegate onStopScreenMainView:self sharingType:self.sharingType];
        }
    }
}

#pragma mark 成员管理事件回调
/// 成员管理事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectMemberButton:(UIButton *)source {
    
    /// 回调控制器层处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMemberEventMainView:)]) {
        [self.delegate onMemberEventMainView:self];
    }
}

#pragma mark 聊天控制事件回调
/// 聊天控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectChatButton:(UIButton *)source {
    
    /// 回调控制器层处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(onChatEventMainView:)]) {
        [self.delegate onChatEventMainView:self];
    }
}

#pragma mark - ----- FWRoomWhiteboardViewDelegate的代理方法 -----
#pragma mark 画板加载开始事件回调
/// 画板加载开始事件回调
/// - Parameter whiteboardView: 电子画板视图
- (void)whiteboardLoadingBegin:(FWRoomWhiteboardView *)whiteboardView {
    
    /// 标记加载状态
    [SVProgressHUD show];
}

#pragma mark 画板加载完成事件回调
/// 画板加载完成事件回调
/// - Parameter whiteboardView: 电子画板视图
- (void)whiteboardLoadingFinish:(FWRoomWhiteboardView *)whiteboardView {
    
    /// 恢复加载状态
    [SVProgressHUD dismiss];
}

#pragma mark 离开事件回调
/// 离开事件回调
/// - Parameters:
///   - whiteboardView: 电子画板视图
///   - source: 事件源对象
- (void)whiteboardView:(FWRoomWhiteboardView *)whiteboardView didSelectLeaveButton:(UIButton *)source {
    
    /// 回调控制器层处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLeaveWhiteboardMainView:)]) {
        [self.delegate onLeaveWhiteboardMainView:self];
    }
}

#pragma mark - ----- FWRoomMemberViewDelegate的代理方法 -----
#pragma mark 成员选择回调
/// 成员选择回调
/// @param memberView 成员列表对象
/// @param memberModel 成员信息
- (void)memberView:(FWRoomMemberView *)memberView didSelectItemAtMemberModel:(FWRoomMemberModel *)memberModel {
    
    /// 回调控制器层处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainView:didSelectItemAtMemberModel:)]) {
        [self.delegate mainView:self didSelectItemAtMemberModel:memberModel];
    }
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 销毁计时器
    [self invalidateTimer];
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
