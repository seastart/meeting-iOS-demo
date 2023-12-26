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
#import "FWUserExtendModel.h"

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
    
    /// 配置属性
}

#pragma mark - 设置/更新成员信息
/// 设置/更新成员信息
- (void)setupMemberInfo {
    
//    /// 获取成员详细信息
//    RTCEngineUserModel *memberModel = [[FWEngineBridge sharedManager] getMySelf];
//    
//    /// 替换本地成员数据
//    [[FWStoreDataBridge sharedManager] updateUserModel:memberModel];
//    
//    /// 设置头像
//    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[memberModel.avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] placeholderImage:kGetImage(@"icon_common_avatar")];
//    
//    /// 获取成员扩展信息
//    FWUserExtendModel *extendModel = [FWUserExtendModel yy_modelWithJSON:memberModel.props];
//    
//    /// 设置音频状态
//    NSString *audioImageName = @"icon_room_audio_state_un";
//    if (extendModel.audioState) {
//        /// 开启状态
//        audioImageName = @"icon_room_audio_state";
//    }
//    /// 设置视频状态
//    [self.videoImageView setImage:kGetImage(audioImageName)];
//    
//    /// 设置视频状态
//    NSString *videoImageName = @"icon_room_video_state_un";
//    if (extendModel.videoState) {
//        /// 开启状态
//        videoImageName = @"icon_room_video_state";
//    }
//    /// 设置音频状态
//    [self.audioImageView setImage:kGetImage(videoImageName)];
//    
//    /// 设置成员昵称
//    NSString *nickname = memberModel.name;
//    self.nameLabel.text = nickname;
//    
//    /// 视频为开启状态
//    if (extendModel.videoState) {
//        /// 隐藏中部各个组件
//        self.statusView.hidden = YES;
//    } else {
//        /// 显示中部各个组件
//        self.statusView.hidden = NO;
//    }
}

#pragma mark - 开启摄像头预览
/// 开启摄像头预览
- (void)startLocalPreview {
    
    /// 开启摄像头的预览画面
//    [[FWEngineBridge sharedManager] startLocalPreview:YES view:self.playerView];
}

#pragma mark - 停止摄像头预览
/// 停止摄像头预览
- (void)stopLocalPreview {
    
    /// 停止摄像头预览
//    [[FWEngineBridge sharedManager] stopLocalPreview];
}

#pragma mark - 切换摄像头
/// 切换摄像头
- (void)switchCamera {
    
    /// 切换摄像头
//    [[FWEngineBridge sharedManager] switchCamera];
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
