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
#import "FWRoomExtendModel.h"

/// 房间持续时长统计周期
#define FW_ROOM_DURATION_TIMER_CYCLE 1.0
/// 房间持续时长统计队列
#define FW_ROOM_DURATION_QUEUE "cn.seastart.meetingkit.duration.queue"

@interface FWRoomMainView() <FWRoomMemberViewDelegate, FWRoomTopViewDelegate, FWRoomBottomViewDelegate>

/// 视图容器
@property (strong, nonatomic) UIView *contentView;

/// 内容滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
/// 采集渲染视图
@property (weak, nonatomic) IBOutlet FWRoomCaptureView *roomCaptureView;
/// 成员列表视图
@property (weak, nonatomic) IBOutlet FWRoomMemberView *roomMemberView;

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

/// 滚动内容偏移量
@property (assign, nonatomic) NSInteger contentOffset;

/// 房间计时器
@property (strong, nonatomic) FWTimerBridge *durationTimer;
/// 屏幕共享状态
@property (nonatomic, assign, readwrite) BOOL screenShareStatus;
/// 屏幕录制组件
@property (strong, nonatomic) RPSystemBroadcastPickerView *broadcastPickerView;

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

#pragma mark - 页面重新绘制
/// 页面重新绘制
- (void)layoutSubviews {
    
    [super layoutSubviews];
    /// 重置成员列表布局
    [self.roomMemberView reloadData];
    /// 设置滚动内容偏移
    FWDispatchAfter((int64_t)(5.0 * NSEC_PER_MSEC), ^{
        /// 设置滚动内容偏移
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.sa_width * self.contentOffset, 0) animated:YES];
    });
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
    [self.roomTopTool setupDataWithDuration:duration roomNoText:[[FWStoreDataBridge sharedManager] getRoomNo]];
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

#pragma mark - 订阅成员视频流
/// 订阅成员视频流
/// @param memberModel 成员信息
/// @param trackId 轨道标识
/// @param subscribe 订阅状态
//- (void)subscribeWithMemberModel:(FWRoomMemberModel *)memberModel trackId:(RTCTrackIdentifierFlags)trackId subscribe:(BOOL)subscribe {
//    
//    /// 订阅成员视频流
//    [self.roomMemberView subscribeWithMemberModel:memberModel trackId:trackId subscribe:subscribe];
//}

#pragma mark - ----- FWRoomTopViewDelegate的代理方法 -----
#pragma mark 扬声器事件回调
/// 扬声器事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectSpeakerButton:(UIButton *)source {
    
    /// 切换源按钮选中状态
    source.selected = !source.selected;
    /// 设置音频播放状态
//    [[FWEngineBridge sharedManager] enabledAudioSpeaker:!source.selected];
}

#pragma mark 变更信息事件回调
/// 变更信息事件回调
/// - Parameters:
///   - topView: 工具栏视图
///   - source: 事件源对象
- (void)topView:(FWRoomTopView *)topView didSelectChangeButton:(UIButton *)source {
    
    /// 回调控制器层处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(onChangeEventMainView:)]) {
        [self.delegate onChangeEventMainView:self];
    }
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

#pragma mark - ----- FWRoomTopViewDelegate的代理方法 -----
#pragma mark 音频控制事件回调
/// 音频控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectAudioButton:(UIButton *)source {
    
    /// 检测麦克风权限
    [FWToolBridge requestAuthorization:FWPermissionsStateAudio superVC:[FWEntryBridge sharedManager].appDelegate.window.rootViewController result:^(BOOL status) {
//        if (status) {
//            /// 获取成员信息
//            RTCEngineUserModel *memberModel = [[FWEngineBridge sharedManager] getMySelf];
//            /// 获取成员扩展信息
//            FWUserExtendModel *extendModel = [FWUserExtendModel yy_modelWithJSON:memberModel.props];
//            /// 变更自己的音频状态
//            extendModel.audioState = source.selected;
//            /// 设置账户扩展信息
//            memberModel.props = extendModel;
//            
//            /// 变更用户信息
//            RTCEngineError errorCode = [[FWEngineBridge sharedManager] changeWithUserModel:memberModel];
//            if (errorCode != RTCEngineErrorOK) {
//                NSString *toastStr = [NSString stringWithFormat:@"变更用户信息失败 errorCode = %ld", errorCode];
//                [FWToastBridge showToastAction:toastStr];
//                SGLOG(@"%@", toastStr);
//                return;
//            }
//            
//            /// 切换源按钮选中状态
//            source.selected = !source.selected;
//            /// 音频发送状态
//            [[FWEngineBridge sharedManager] enabledSendAudio:!source.selected];
//        }
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
//        if (status) {
//            /// 获取成员信息
//            RTCEngineUserModel *memberModel = [[FWEngineBridge sharedManager] getMySelf];
//            /// 获取成员扩展信息
//            FWUserExtendModel *extendModel = [FWUserExtendModel yy_modelWithJSON:memberModel.props];
//            /// 变更自己的视频状态
//            extendModel.videoState = source.selected;
//            /// 设置账户扩展信息
//            memberModel.props = extendModel;
//            
//            /// 变更用户信息
//            RTCEngineError errorCode = [[FWEngineBridge sharedManager] changeWithUserModel:memberModel];
//            if (errorCode != RTCEngineErrorOK) {
//                NSString *toastStr = [NSString stringWithFormat:@"变更用户信息失败 errorCode = %ld", errorCode];
//                [FWToastBridge showToastAction:toastStr];
//                SGLOG(@"%@", toastStr);
//                return;
//            }
//            
//            /// 切换源按钮选中状态
//            source.selected = !source.selected;
//            /// 设置采集状态
//            if (source.selected) {
//                /// 停止摄像头预览
//                [self.roomCaptureView stopLocalPreview];
//            } else {
//                /// 开启摄像头预览
//                [self.roomCaptureView startLocalPreview];
//            }
//        }
    }];
}

#pragma mark 共享控制事件回调
/// 共享控制事件回调
/// - Parameters:
///   - bottomView: 工具栏视图
///   - source: 事件源对象
- (void)bottomView:(FWRoomBottomView *)bottomView didSelectSharingButton:(UIButton *)source {
    
    if (source.selected) {
        /// 回调控制器层处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(onStopScreenMainView:)]) {
            [self.delegate onStopScreenMainView:self];
        }
    } else {
        /// 将事件传递给屏幕录制组件的开启录制按钮
        for (UIView *view in self.broadcastPickerView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [(UIButton *)view sendActionsForControlEvents:UIControlEventTouchDown | UIControlEventTouchUpInside];
            }
        }
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

#pragma mark - ----- FWRoomMemberViewDelegate的代理方法 -----
#pragma mark 成员选择回调
/// 成员选择回调
/// @param memberView 成员列表对象
/// @param indexPath 选中索引
/// @param memberModel 成员信息
- (void)memberView:(FWRoomMemberView *)memberView didSelectItemAtIndexPath:(NSIndexPath *)indexPath memberModel:(FWRoomMemberModel *)memberModel {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainView:didSelectItemMemberModel:didIndexPath:)]) {
        [self.delegate mainView:self didSelectItemMemberModel:memberModel didIndexPath:indexPath];
    }
}

#pragma mark - ----- UIScrollViewDelegate的代理方法 -----
#pragma mark 视图滑动监听事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    /// 记录滚动内容偏移量
    self.contentOffset = scrollView.contentOffset.x / self.scrollView.sa_width;
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 销毁计时器
    [self invalidateTimer];
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
