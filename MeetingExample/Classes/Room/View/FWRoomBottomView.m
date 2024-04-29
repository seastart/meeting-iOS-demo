//
//  FWRoomBottomView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomBottomView.h"

@interface FWRoomBottomView()

/// 视图容器
@property (strong, nonatomic) UIView *contentView;

/// 音频控制按钮
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
/// 音频控制按钮图标
@property (weak, nonatomic) IBOutlet UIButton *audioButtonImage;
/// 音频控制按钮标题
@property (weak, nonatomic) IBOutlet UILabel *audioButtonLable;

/// 视频控制按钮
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
/// 视频控制按钮图标
@property (weak, nonatomic) IBOutlet UIButton *videoButtonImage;
/// 视频控制按钮标题
@property (weak, nonatomic) IBOutlet UILabel *videoButtonLable;

/// 共享按钮
@property (weak, nonatomic) IBOutlet UIButton *sharingButton;
/// 共享按钮图标
@property (weak, nonatomic) IBOutlet UIButton *sharingButtonImage;
/// 共享按钮标题
@property (weak, nonatomic) IBOutlet UILabel *sharingButtonLable;

/// 成员按钮
@property (weak, nonatomic) IBOutlet UIButton *memberButton;
/// 成员按钮图标
@property (weak, nonatomic) IBOutlet UIButton *memberButtonImage;
/// 成员按钮标题
@property (weak, nonatomic) IBOutlet UILabel *memberButtonLable;

/// 聊天按钮
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
/// 聊天按钮图标
@property (weak, nonatomic) IBOutlet UIButton *chatButtonImage;
/// 聊天按钮标题
@property (weak, nonatomic) IBOutlet UILabel *chatButtonLable;

@end

@implementation FWRoomBottomView

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
    
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听订阅音频控制按钮选择状态
    [RACObserve(self.audioButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 音频按钮选中
            [self.audioButtonImage setImage:kGetImage(@"icon_room_microphone_un") forState:UIControlStateNormal];
            [self.audioButtonLable setText:@"解除静音"];
        } else {
            /// 音频按钮未选中
            [self.audioButtonImage setImage:kGetImage(@"icon_room_microphone") forState:UIControlStateNormal];
            [self.audioButtonLable setText:@"静音"];
        }
    }];
    
    /// 监听订阅视频控制按钮选择状态
    [RACObserve(self.videoButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 视频按钮选中
            [self.videoButtonImage setImage:kGetImage(@"icon_room_camera_un") forState:UIControlStateNormal];
            [self.videoButtonLable setText:NSLocalizedString(@"开启视频", nil)];
        } else {
            /// 视频按钮未选中
            [self.videoButtonImage setImage:kGetImage(@"icon_room_camera") forState:UIControlStateNormal];
            [self.videoButtonLable setText:NSLocalizedString(@"关闭视频", nil)];
        }
    }];
    
    /// 监听订阅共享按钮选择状态
    [RACObserve(self.sharingButton, selected) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        if (value.boolValue) {
            /// 共享按钮选中
            [self.sharingButtonImage setImage:kGetImage(@"icon_room_share_un") forState:UIControlStateNormal];
            [self.sharingButtonLable setText:NSLocalizedString(@"停止共享", nil)];
        } else {
            /// 共享按钮未选中
            [self.sharingButtonImage setImage:kGetImage(@"icon_room_share") forState:UIControlStateNormal];
            [self.sharingButtonLable setText:NSLocalizedString(@"共享屏幕", nil)];
        }
    }];
    
    /// 绑定音频控制按钮事件
    [[self.audioButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectAudioButton:)]) {
            [self.delegate bottomView:self didSelectAudioButton:control];
        }
    }];
    
    /// 绑定视频控制按钮事件
    [[self.videoButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectVideoButton:)]) {
            [self.delegate bottomView:self didSelectVideoButton:control];
        }
    }];
    
    /// 绑定共享按钮事件
    [[self.sharingButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectSharingButton:)]) {
            [self.delegate bottomView:self didSelectSharingButton:control];
        }
    }];
    
    /// 绑定成员按钮事件
    [[self.memberButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 调整按钮激活状态
        self.memberButton.enabled = NO;
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectMemberButton:)]) {
            [self.delegate bottomView:self didSelectMemberButton:control];
        }
        /// 延迟重置按钮激活状态
        FWDispatchAfter((int64_t)(1.5 * NSEC_PER_SEC), ^{
            self.memberButton.enabled = YES;
        });
    }];
    
    /// 绑定聊天按钮事件
    [[self.chatButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 调整按钮激活状态
        self.chatButton.enabled = NO;
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectChatButton:)]) {
            [self.delegate bottomView:self didSelectChatButton:control];
        }
        /// 延迟重置按钮激活状态
        FWDispatchAfter((int64_t)(1.5 * NSEC_PER_SEC), ^{
            self.chatButton.enabled = YES;
        });
    }];
}

#pragma mark - 设置默认音频状态
/// 设置默认音频状态
/// - Parameter audioState: 音频状态
- (void)setupDefaultAudioState:(BOOL)astate {
    
    if (!astate) {
        /// 原本默认即为关闭，如果设置的默认也是关闭，则丢弃此次操作
        return;
    }
    /// 回调父组件处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectAudioButton:)]) {
        [self.delegate bottomView:self didSelectAudioButton:self.audioButton];
    }
}

#pragma mark - 设置默认视频状态
/// 设置默认视频状态
/// - Parameter videoState: 视频状态
- (void)setupDefaultVideoState:(BOOL)vstate {
    
    if (!vstate) {
        /// 原本默认即为关闭，如果设置的默认也是关闭，则丢弃此次操作
        return;
    }
    /// 回调父组件处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didSelectVideoButton:)]) {
        [self.delegate bottomView:self didSelectVideoButton:self.videoButton];
    }
}

#pragma mark - 设置音频按钮选中状态
/// 设置音频按钮选中状态
/// @param selected 选中状态
- (void)setupAudioButtonSelected:(BOOL)selected {
    
    FWDispatchAscyncOnMainQueue(^{
        self.audioButton.selected = selected;
    });
}

#pragma mark - 设置视频按钮选中状态
/// 设置视频按钮选中状态
/// @param selected 选中状态
- (void)setupVideoButtonSelected:(BOOL)selected {
    
    FWDispatchAscyncOnMainQueue(^{
        self.videoButton.selected = selected;
    });
}

#pragma mark - 设置共享按钮选中状态
/// 设置共享按钮选中状态
/// @param selected 选中状态
- (void)setupShareButtonSelected:(BOOL)selected {
    
    FWDispatchAscyncOnMainQueue(^{
        self.sharingButton.selected = selected;
    });
}

#pragma mark - 显示视图
/// 显示视图
- (void)showView {
    
    FWDispatchAscyncOnMainQueue(^{
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    });
}

#pragma mark - 隐藏视图
/// 隐藏视图
- (void)hiddenView {
    
    FWDispatchAscyncOnMainQueue(^{
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, self.sa_height);
        }];
    });
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
