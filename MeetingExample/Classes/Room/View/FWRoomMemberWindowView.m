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
    if (self.delegate && [self.delegate respondsToSelector:@selector(windowView:didSelectItemAtUserId:memberModel:)]) {
        [self.delegate windowView:self didSelectItemAtUserId:self.userId memberModel:self.memberModel];
    }
}

#pragma mark - 设置成员信息
/// 设置成员信息
/// @param memberModel 成员信息
- (void)setMemberModel:(nullable FWRoomMemberModel *)memberModel {
    
    /// 如果当前订阅了该成员
//    if (memberModel.subscribe) {
//        /// 获取成员详细信息
//        RTCEngineUserModel *userModel = [[FWEngineBridge sharedManager] findMemberWithUserId:memberModel.uid];
//        /// 声明目标流是否存在
//        BOOL isExist = NO;
//        /// 查找当前订阅的视频流
//        for (RTCEngineStreamModel *streamModel in userModel.streams) {
//            /// 查找对应码流
//            if (streamModel.id == memberModel.trackIdentifier) {
//                /// 设置标记该流存在
//                isExist = YES;
//                break;
//            }
//        }
//        /// 如果订阅了该轨道，但是该轨道已经不在推流
//        if (!isExist) {
//            /// 标记未订阅
//            memberModel.subscribe = NO;
//            /// 重新订阅轨道
//            [self reloadSubscribe];
//        }
//    }
    /// 缓存成员信息
    _memberModel = memberModel;
    /// 设置显示内容
    [self.statusView setupMemberInfoWithUserModel:memberModel];
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
