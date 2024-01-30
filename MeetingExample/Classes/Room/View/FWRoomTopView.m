//
//  FWRoomTopView.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/1.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomTopView.h"

@interface FWRoomTopView()

/// 视图容器
@property (strong, nonatomic) UIView *contentView;

/// 挂断按钮
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
/// 扬声器按钮
@property (weak, nonatomic) IBOutlet UIButton *speakerButton;
/// 摄像头按钮
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
/// 举报按钮
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
/// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/// 房间号码
@property (weak, nonatomic) IBOutlet UILabel *roomNoLabel;

@end

@implementation FWRoomTopView

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
    
    /// 绑定扬声器按钮事件
    [[self.speakerButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didSelectSpeakerButton:)]) {
            [self.delegate topView:self didSelectSpeakerButton:control];
        }
    }];
    
    /// 绑定摄像头按钮事件
    [[self.cameraButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didSelectCameraButton:)]) {
            [self.delegate topView:self didSelectCameraButton:control];
        }
    }];
    
    /// 绑定举报按钮事件
    [[self.reportButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didSelectReportButton:)]) {
            [self.delegate topView:self didSelectReportButton:control];
        }
    }];
    
    /// 绑定挂断按钮事件
    [[self.hangupButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 回调父组件处理
        if (self.delegate && [self.delegate respondsToSelector:@selector(topView:didSelectHangupButton:)]) {
            [self.delegate topView:self didSelectHangupButton:control];
        }
    }];
}

#pragma mark - 设置数据
/// 设置数据
/// - Parameters:
///   - duration: 参会时长
///   - roomNoText: 房间号码
- (void)setupDataWithDuration:(NSInteger)duration roomNoText:(NSString *)roomNoText {
    
    /// 分解时间段
    NSInteger hours = duration / 3600;
    NSInteger minutes = (duration % 3600) / 60;
    NSInteger seconds = duration % 60;
    /// 构建显示时间
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    /// 设置参会时长
    [self.timeLabel setText:timeStr];
    /// 设置房间号码
    [self.roomNoLabel setText:[FWToolBridge roomnoDiversionString:roomNoText]];
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
            self.transform = CGAffineTransformMakeTranslation(0, -self.sa_height);
        }];
    });
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
