//
//  FWRoomMemberWindowView.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/19.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRoomMemberWindowView.h"
#import "FWRoomMemberModel.h"
#import "FWRoomStatusView.h"

@interface FWRoomMemberWindowView() <UIGestureRecognizerDelegate>

/// 视图容器
@property (strong, nonatomic) UIView *contentView;
/// 播放器窗口
@property (weak, nonatomic) IBOutlet UIView *playerView;
/// 成员状态组件
@property (weak, nonatomic) IBOutlet FWRoomStatusView *statusView;

@end

@implementation FWRoomMemberWindowView

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

#pragma mark - 配置属性
- (void)setupConfig {
    
    /// 添加视图手势
    [self appendRecognizer];
}

#pragma mark - 添加视图手势
/// 添加视图手势
- (void)appendRecognizer {
    
    /// 添加视图手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
}

#pragma mark - 视图手势事件处理
/// 视图手势事件处理
- (void)handleGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    /// 回调上层成员选择
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowView:didSelectItemAtMemberModel:)]) {
        [self.delegate windowView:self didSelectItemAtMemberModel:self.memberModel];
    }
}

#pragma mark - 设置成员信息
/// 设置成员信息
/// @param memberModel 成员信息
- (void)setMemberModel:(nullable FWRoomMemberModel *)memberModel {
    
    /// 保存成员信息
    _memberModel = memberModel;
    /// 设置显示内容
    [self.statusView setupMemberInfoWithMemberModel:memberModel];
}

#pragma mark - 获取播放窗口视图
/// 获取播放窗口视图
- (UIView *)getPlayerWindow {
    
    /// 返回播放器窗口
    return self.playerView;
}

#pragma mark - 用户摄像头状态变化
/// 用户摄像头状态变化
/// @param cameraState 视频状态
- (void)userCameraStateChanged:(SEADeviceState)cameraState {
    
    /// 用户摄像头状态变化
    [self.statusView userCameraStateChanged:cameraState];
    /// 订阅成员视频流
    [self subscribeWithtTackId:RTCTrackIdentifierFlags1 subscribe:(cameraState == SEADeviceStateOpen)];
}

#pragma mark - 用户麦克风状态变化
/// 用户麦克风状态变化
/// @param micState 音频状态
- (void)userMicStateChanged:(SEADeviceState)micState {
    
    /// 用户麦克风状态变化
    [self.statusView userMicStateChanged:micState];
}

#pragma mark - 用户共享状态变化
/// 用户共享状态变化
/// @param enabled YES-开启 NO-关闭
/// @param shareType 共享类型
- (void)userShareStateChanged:(BOOL)enabled shareType:(SEAShareType)shareType {
    
    /// 成员共享类型非屏幕
    if (shareType != SEAShareTypeScreen) {
        /// 丢弃此次调用
        return;
    }
    
    /// 订阅成员视频流
    [self subscribeWithtTackId:RTCTrackIdentifierFlags1 subscribe:enabled];
}

#pragma mark - 订阅成员视频流
/// 订阅成员视频流
/// @param trackId 轨道标识
/// @param subscribe 订阅状态，YES-订阅 NO-取消订阅
- (void)subscribeWithtTackId:(RTCTrackIdentifierFlags)trackId subscribe:(BOOL)subscribe {
    
    /// 如果关联成员数据为当前参会账号
    if (self.memberModel.isMine) {
        /// 丢弃此次调用
        return;
    }
    
    if (subscribe) {
        /// 订阅远端用户的视频流
        [[MeetingKit sharedInstance] startRemoteView:self.userId trackId:trackId view:self.playerView];
    } else {
        /// 停止订阅远端用户的视频流
        [[MeetingKit sharedInstance] stopRemoteView:self.userId trackId:trackId];
    }
}

#pragma mark ------- UIGestureRecognizerDelegate代理实现 -------
#pragma mark 保证允许同时识别手势
/// 保证允许同时识别手势
/// - Parameters:
///   - gestureRecognizer: 手势识别器
///   - otherGestureRecognizer: 其它手势识别器
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

#pragma mark - 资源释放
- (void)dealloc {
    
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
