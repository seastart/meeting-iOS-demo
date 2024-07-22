//
//  FWRoomCaptureView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/6.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomCaptureView.h"
#import "FWRoomStatusView.h"
#import "FWRoomMemberModel.h"

@interface FWRoomCaptureView()

/// 视图容器
@property (strong, nonatomic) UIView *contentView;
/// 播放器窗口
@property (weak, nonatomic) IBOutlet UIView *playerView;
/// 状态视图
@property (weak, nonatomic) IBOutlet UIView *statusView;
/// 成员头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
/// 视频状态
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
/// 音频状态
@property (weak, nonatomic) IBOutlet UIImageView *audioImageView;
/// 成员昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation FWRoomCaptureView

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

#pragma mark - 配置属性
- (void)setupConfig {
    
    /// 设置默认显示数据
    [self setupMemberInfo];
}

#pragma mark - 获取预览视图
/// 获取预览视图
- (UIView *)getPreview {
    
    /// 返回播放器窗口
    return self.playerView;
}

#pragma mark - 设置/更新成员信息
/// 设置/更新成员信息
- (void)setupMemberInfo {
    
    /// 获取用户数据
    SEAUserModel *userModel = [[MeetingKit sharedInstance] getMySelf];
    
    /// 设置用户头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[userModel.extend.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:kGetImage(FWDEFAULTAVATAR)];
    /// 设置用户昵称
    self.nameLabel.text = userModel.name;
    
    /// 设置音频状态
    NSString *audioImageName = @"icon_room_microphone_state_un";
    if (userModel.extend.micState == SEADeviceStateOpen) {
        /// 开启状态
        audioImageName = @"icon_room_microphone_state";
    }
    /// 设置音频状态
    [self.audioImageView setImage:kGetImage(audioImageName)];
    
    /// 设置视频状态
    NSString *videoImageName = @"icon_room_camera_state_un";
    if (userModel.extend.cameraState == SEADeviceStateOpen) {
        /// 开启状态
        videoImageName = @"icon_room_camera_state";
    }
    /// 设置视频状态
    [self.videoImageView setImage:kGetImage(videoImageName)];
}

#pragma mark - 开启摄像头预览
/// 开启摄像头预览
- (void)startLocalPreview {
    
    /// 隐藏状态视图
    self.statusView.hidden = YES;
    /// 设置视频状态图标
    [self setupVideoImageView:YES];
}

#pragma mark - 停止摄像头预览
/// 停止摄像头预览
- (void)stopLocalPreview {
    
    /// 隐藏状态视图
    self.statusView.hidden = NO;
    /// 设置视频状态图标
    [self setupVideoImageView:NO];
}

#pragma mark - 切换摄像头
/// 切换摄像头
- (void)switchCamera {
    
    /// 切换摄像头
    [[MeetingKit sharedInstance] switchCamera];
}

#pragma mark - 开启音频发送
/// 开启音频发送
- (void)startSendAudio {
    
    /// 设置音频状态图标
    [self setupAudioImageView:YES];
}

#pragma mark - 停止音频发送
/// 停止音频发送
- (void)stopSendAudio {
    
    /// 设置音频状态图标
    [self setupAudioImageView:NO];
}

#pragma mark - 设置音频状态图标
/// 设置音频状态图标
/// - Parameter audioState: 音频状态
- (void)setupAudioImageView:(BOOL)audioState {
    
    /// 设置音频状态
    NSString *audioImageName = @"icon_room_microphone_state_un";
    if (audioState) {
        /// 开启状态
        audioImageName = @"icon_room_microphone_state";
    }
    /// 设置音频状态
    [self.audioImageView setImage:kGetImage(audioImageName)];
}

#pragma mark - 设置视频状态图标
/// 设置视频状态图标
/// - Parameter videoState: 视频状态
- (void)setupVideoImageView:(BOOL)videoState {
    
    /// 设置视频状态
    NSString *videoImageName = @"icon_room_camera_state_un";
    if (videoState) {
        /// 开启状态
        videoImageName = @"icon_room_camera_state";
    }
    /// 设置视频状态
    [self.videoImageView setImage:kGetImage(videoImageName)];
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
