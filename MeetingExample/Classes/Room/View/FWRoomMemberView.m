//
//  FWRoomMemberView.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/19.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRoomMemberView.h"

/// 成员窗口视图宽度
#define FW_WINDOW_ITEM_WIDTH (self.scrollView.sa_width - 5) / 2
/// 成员窗口视图高度
#define FW_WINDOW_ITEM_HEIGHT (self.scrollView.sa_height - 5) / 2

@interface FWRoomMemberView() <FWRoomMemberWindowViewDelegate>

/// 自己的预览视图
@property (strong, nonatomic, readwrite) FWRoomMemberWindowView *mineWindowView;
/// 视图容器
@property (strong, nonatomic) UIView *contentView;
/// 垂直流式布局
@property (strong, nonatomic) MyFlowLayout *flowLayout;
/// 内容滚动视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

/// 房间内成员视图单元格列表，用于渲染收到的视频流
@property (strong, nonatomic) NSMutableDictionary<NSString *, FWRoomMemberWindowView *> *displayItems;

@end

@implementation FWRoomMemberView

#pragma mark - 创建成员视图列表
/// 创建成员视图列表
- (NSMutableDictionary<NSString *, FWRoomMemberWindowView *> *)displayItems {
    
    if (!_displayItems) {
        _displayItems = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _displayItems;
}

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
/// 初始化方法
/// - Parameter frame: 框架
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
    
    /// 创建线性布局
    [self createLinearLayout];
}

#pragma mark - 创建线性布局
/// 创建线性布局
- (void)createLinearLayout {
    
    /// 创建线性布局
    MyLinearLayout *rootLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    /// 宽度和滚动视图保持一致。
    rootLayout.myHorzMargin = 0;
    /// 里面的所有子视图和布局视图宽度一致。
    rootLayout.gravity = MyGravity_Horz_Fill;
    /// 将布局添加到滚动视图
    [self.scrollView addSubview:rootLayout];
    /// 创建一个垂直分页从左向右滚动的流式布局，高度自适应
    [self createVertPagingFlowLayout:rootLayout];
}

#pragma mark - 创建一个垂直分页从左向右滚动的流式布局，高度自适应
/// 创建一个垂直分页从左向右滚动的流式布局，高度自适应
/// - Parameter rootLayout: 线性布局
- (void)createVertPagingFlowLayout:(UIView *)rootLayout {
    
    /// 要开启分页功能，必须要将流式布局加入到一个滚动视图里面作为子视图
    UIScrollView *scrollView = [UIScrollView new];
    /// 关闭弹性效果
    scrollView.bounces = NO;
    /// 开启分页滚动模式
    scrollView.pagingEnabled = YES;
    /// 隐藏滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    /// 高度自适应
    scrollView.myHeight = MyLayoutSize.wrap;
    /// 将滚动视图添加到布局
    [rootLayout addSubview:scrollView];
    
    /// 建立一个垂直数量约束流式布局：每列展示2个子视图，每页展示4个子视图，整体从左往右滚动
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:2];
    /// 宽度和滚动视图保持一致
    self.flowLayout.myHorzMargin = 0;
    /// pagedCount设置为非0时表示开始分页展示的功能，这里表示每页展示4个子视图，这个数量必须是arrangedCount的倍数
    self.flowLayout.pagedCount = 4;
    /// 设置流式布局的高度和宽度都是自适应
    self.flowLayout.mySize = CGSizeMake(MyLayoutSize.wrap, MyLayoutSize.wrap);
    /// 设置子视图的水平间距
    self.flowLayout.subviewHSpace = 5;
    /// 设置子视图的垂直间距
    self.flowLayout.subviewVSpace = 5;
    /// 将流式布局添加到滚动视图
    [scrollView addSubview:self.flowLayout];
}

#pragma mark - 进入房间成功
/// 进入房间成功
/// - Parameter userId: 用户标识
- (void)enterRoom:(NSString *)userId {
    
    /// 获取成员视图
    FWRoomMemberWindowView *memberWindowView = [self.displayItems objectForKey:userId];
    /// 不存在该成员
    if (!memberWindowView) {
        /// 创建成员窗口视图
        self.mineWindowView = [[FWRoomMemberWindowView alloc] initWithFrame:CGRectMake(0, 0, FW_WINDOW_ITEM_WIDTH, FW_WINDOW_ITEM_HEIGHT)];
        /// 关联用户标识
        self.mineWindowView.userId = userId;
        /// 设置代理回调
        self.mineWindowView.delegate = self;
        /// 关联用户数据
        self.mineWindowView.memberModel = [[FWRoomMemberManager sharedManager] findMemberWithUserId:userId];
        /// 设置条目视图的尺寸
        /// windowView.mySize = CGSizeMake(FW_WINDOW_ITEM_WIDTH, FW_WINDOW_ITEM_HEIGHT);
        /// 将窗口视图添加到流式布局
        [self.flowLayout addSubview:self.mineWindowView];
        /// 添加到本地成员列表
        [self.displayItems setValue:self.mineWindowView forKey:userId];
    }
}

#pragma mark - 成员更新信息
/// 成员更新信息
/// @param userId 成员标识
- (void)memberUpdateWithUserId:(NSString *)userId {
    
    /// 获取成员视图
    FWRoomMemberWindowView *memberWindowView = [self.displayItems objectForKey:userId];
    /// 不存在该成员
    if (!memberWindowView) {
        /// 获取用户数据
        SEAUserModel *userModel = [[MeetingKit sharedInstance] findMemberWithUserId:userId];
        
        /// 创建成员窗口视图
        FWRoomMemberWindowView *windowView = [[FWRoomMemberWindowView alloc] initWithFrame:CGRectMake(0, 0, FW_WINDOW_ITEM_WIDTH, FW_WINDOW_ITEM_HEIGHT)];
        /// 关联用户标识
        windowView.userId = userId;
        /// 设置代理回调
        windowView.delegate = self;
        /// 关联用户数据
        windowView.memberModel = [[FWRoomMemberManager sharedManager] findMemberWithUserId:userId];
        /// 设置条目视图的尺寸
        /// windowView.mySize = CGSizeMake(FW_WINDOW_ITEM_WIDTH, FW_WINDOW_ITEM_HEIGHT);
        /// 将窗口视图添加到流式布局
        [self.flowLayout addSubview:windowView];
        /// 添加到本地成员列表
        [self.displayItems setValue:windowView forKey:userId];
        
        /// 设置用户摄像头状态
        [self userCameraStateChanged:userId cameraState:userModel.extend.cameraState];
        /// 设置用户麦克风状态
        [self userMicStateChanged:userId micState:userModel.extend.micState];
    } else {
        /// 更新成员信息
    }
}

#pragma mark - 成员离开房间
/// 成员离开房间
/// @param userId 成员标识
- (void)memberExitWithUserId:(NSString *)userId {
    
    /// 获取成员视图
    FWRoomMemberWindowView *memberWindowView = [self.displayItems objectForKey:userId];
    /// 存在该成员
    if (memberWindowView) {
        /// 移除本地成员列表
        [self.displayItems removeObjectForKey:userId];
        /// 释放成员窗口视图
        [memberWindowView removeFromSuperview];
    }
}

#pragma mark - 刷新成员基本信息
/// 刷新成员基本信息
/// @param userId 成员标识
- (void)refreshMemberData:(NSString *)userId {
    
    /// 获取成员视图
    FWRoomMemberWindowView *memberWindowView = [self.displayItems objectForKey:userId];
    /// 存在该成员
    if (memberWindowView) {
        /// 关联用户数据
        memberWindowView.memberModel = [[FWRoomMemberManager sharedManager] findMemberWithUserId:userId];
    }
}

#pragma mark - 用户摄像头状态变化
/// 用户摄像头状态变化
/// @param userId 成员标识
/// @param cameraState 视频状态
- (void)userCameraStateChanged:(NSString *)userId cameraState:(SEADeviceState)cameraState {
    
    /// 获取成员视图
    FWRoomMemberWindowView *windowView = [self.displayItems objectForKey:userId];
    /// 存在该成员
    if (windowView) {
        /// 用户摄像头状态变化
        [windowView userCameraStateChanged:cameraState];
    }
}

#pragma mark - 用户麦克风状态变化
/// 用户麦克风状态变化
/// @param userId 成员标识
/// @param micState 音频状态
- (void)userMicStateChanged:(NSString *)userId micState:(SEADeviceState)micState {
    
    /// 获取成员视图
    FWRoomMemberWindowView *windowView = [self.displayItems objectForKey:userId];
    /// 存在该成员
    if (windowView) {
        /// 用户麦克风状态变化
        [windowView userMicStateChanged:micState];
    }
}

#pragma mark - 用户共享屏幕状态变化
/// 用户共享屏幕状态变化
/// @param userId 成员标识
/// @param enabled 变更状态，YES-开启 NO-关闭
- (void)userShareScreenChanged:(NSString *)userId enabled:(BOOL)enabled {
    
    /// 获取成员视图
    FWRoomMemberWindowView *windowView = [self.displayItems objectForKey:userId];
    /// 存在该成员
    if (windowView) {
        /// 用户共享状态变化
        [windowView userShareScreenChanged:enabled];
    }
}


#pragma mark - ----- FWRoomMemberWindowViewDelegate的代理方法 -----
#pragma mark 成员选择回调
/// 成员选择回调
/// @param windowView 成员视图对象
/// @param memberModel 成员数据
- (void)windowView:(FWRoomMemberWindowView *)windowView didSelectItemAtMemberModel:(FWRoomMemberModel *)memberModel {
    
    /// 回调上层成员选择
    if (self.delegate && [self.delegate respondsToSelector:@selector(memberView:didSelectItemAtMemberModel:)]) {
        [self.delegate memberView:self didSelectItemAtMemberModel:memberModel];
    }
}

#pragma mark - 释放资源
- (void)dealloc {
    
    /// 追加打印日志
    SGLOG(@"释放资源：%@", kStringFromClass(self));
}

@end
