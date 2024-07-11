//
//  FWRoomStatusView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomStatusView.h"
#import "FWRoomMemberModel.h"

@interface FWRoomStatusView()

/// 视图容器
@property (strong, nonatomic) UIView *contentView;

/// 背景幕布
@property (weak, nonatomic) IBOutlet UIView *screenView;

/// 成员头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

/// 中间状态
@property (weak, nonatomic) IBOutlet UIView *centerStatusView;
/// 视频状态
@property (weak, nonatomic) IBOutlet UIImageView *centerVideoImageView;
/// 音频状态
@property (weak, nonatomic) IBOutlet UIImageView *centerAudioImageView;
/// 成员昵称
@property (weak, nonatomic) IBOutlet UILabel *centerNameLabel;

/// 底部状态
@property (weak, nonatomic) IBOutlet UIView *bottomStatusView;
/// 视频状态
@property (weak, nonatomic) IBOutlet UIImageView *bottomVideoImageView;
/// 音频状态
@property (weak, nonatomic) IBOutlet UIImageView *bottomAudioImageView;
/// 成员昵称
@property (weak, nonatomic) IBOutlet UILabel *bottomNameLabel;

/// 当前绑定成员
@property (strong, nonatomic) FWRoomMemberModel *userModel;

@end

@implementation FWRoomStatusView

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
    
    /// 配置属性
}

#pragma mark - 设置/更新成员信息
/// 设置/更新成员信息
/// - Parameter userModel: 成员信息
- (void)setupMemberInfoWithUserModel:(FWRoomMemberModel *)userModel {
    
    /// 缓存当前绑定成员
    self.userModel = userModel;
    /// 获取成员详细信息
//    RTCEngineUserModel *memberModel = [[FWEngineBridge sharedManager] findMemberWithUserId:userModel.uid];
//    
//    /// 设置头像
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[memberModel.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:kGetImage(@"icon_common_avatar")];
//    
//    /// 获取成员扩展信息
//    FWUserExtendModel *extendModel = [FWUserExtendModel yy_modelWithJSON:memberModel.props];
//    
//    /// 设置视频状态
//    NSString *audioImageName = @"icon_room_audio_state_un";
//    if (extendModel.audioState) {
//        /// 开启状态
//        audioImageName = @"icon_room_audio_state";
//    }
//    /// 设置音频状态
//    [self.centerAudioImageView setImage:kGetImage(audioImageName)];
//    [self.bottomAudioImageView setImage:kGetImage(audioImageName)];
//    
//    /// 设置音频状态
//    NSString *videoImageName = @"icon_room_video_state_un";
//    if (extendModel.videoState) {
//        /// 开启状态
//        videoImageName = @"icon_room_video_state";
//    }
//    /// 设置视频状态
//    [self.centerVideoImageView setImage:kGetImage(videoImageName)];
//    [self.bottomVideoImageView setImage:kGetImage(videoImageName)];
//    
//    /// 设置成员昵称
//    NSString *nickname = memberModel.name;
//    self.centerNameLabel.text = nickname;
//    self.bottomNameLabel.text = nickname;
    
    /// 根据对该成员的视频订阅情况显示或隐藏背影幕布
//    if (userModel.subscribe) {
//        /// 隐藏中部各个组件
//        self.screenView.hidden = YES;
//        self.avatarImageView.hidden = YES;
//    } else {
//        /// 显示中部各个组件
//        self.screenView.hidden = NO;
//        self.avatarImageView.hidden = NO;
//    }
}

#pragma mark - 用户摄像头状态变化
/// 用户摄像头状态变化
/// @param cameraState 视频状态
- (void)userCameraStateChanged:(SEADeviceState)cameraState {
    
    /// 设置音频状态
    NSString *videoImageName = @"icon_room_camera_state_un";
    if (cameraState == SEADeviceStateOpen) {
        /// 开启状态
        videoImageName = @"icon_room_camera_state";
    }
    /// 设置视频状态
    [self.centerVideoImageView setImage:kGetImage(videoImageName)];
    [self.bottomVideoImageView setImage:kGetImage(videoImageName)];
    
    /// 如果当前摄像头状态为开启
    if (cameraState == SEADeviceStateOpen) {
        /// 隐藏中部各个组件
        self.screenView.hidden = YES;
        self.avatarImageView.hidden = YES;
    } else {
        /// 显示中部各个组件
        self.screenView.hidden = NO;
        self.avatarImageView.hidden = NO;
    }
}

#pragma mark - 用户麦克风状态变化
/// 用户麦克风状态变化
/// @param micState 音频状态
- (void)userMicStateChanged:(SEADeviceState)micState {
    
    /// 设置视频状态
    NSString *audioImageName = @"icon_room_microphone_state_un";
    if (micState == SEADeviceStateOpen) {
        /// 开启状态
        audioImageName = @"icon_room_microphone_state";
    }
    /// 设置音频状态
    [self.centerAudioImageView setImage:kGetImage(audioImageName)];
    [self.bottomAudioImageView setImage:kGetImage(audioImageName)];
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
