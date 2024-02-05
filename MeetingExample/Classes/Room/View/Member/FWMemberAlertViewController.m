//
//  FWMemberAlertViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMemberAlertViewController.h"

@interface FWMemberAlertViewController ()

/// 标题标签
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
/// 单选按钮
@property (weak, nonatomic) IBOutlet UIButton *radioBoxButton;
/// 取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
/// 确定按钮
@property (weak, nonatomic) IBOutlet UIButton *ensureButton;

/// 标题文本
@property (strong, nonatomic) NSString *titleText;
/// 描述文本
@property (strong, nonatomic) NSString *messageText;
/// 取消按钮文本
@property (strong, nonatomic) NSString *cancelTitle;
/// 确定按钮文本
@property (strong, nonatomic) NSString *ensureTitle;

/// 取消按钮事件回调
@property (copy, nonatomic) FWMemberAlertCancelBlock cancelBlock;
/// 确定按钮事件回调
@property (copy, nonatomic) FWMemberAlertEnsureBlock ensureBlock;

@end

@implementation FWMemberAlertViewController

#pragma mark - 创建弹窗实例
/// 创建弹窗实例
/// @param title 标题
/// @param message 描述
/// @param cancelTitle 取消按钮文本
/// @param ensureTitle 确定按钮文本
/// @param cancelBlock 取消按钮事件回调
/// @param ensureBlock 确定按钮事件回调
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelTitle:(nullable NSString *)cancelTitle ensureTitle:(nullable NSString *)ensureTitle cancelBlock:(nullable FWMemberAlertCancelBlock)cancelBlock ensureBlock:(nullable FWMemberAlertEnsureBlock)ensureBlock {
    
    /// 初始化提示框
    FWMemberAlertViewController *alertVC = [[FWMemberAlertViewController alloc] init];
    /// 记录标题
    alertVC.titleText = title;
    /// 记录描述文本
    alertVC.messageText = [NSString stringWithFormat:@"  %@", message];
    /// 记录取消按钮文本
    alertVC.cancelTitle = cancelTitle;
    /// 记录确定按钮文本
    alertVC.ensureTitle = ensureTitle;
    /// 记录取消按钮事件回调
    alertVC.cancelBlock = cancelBlock;
    /// 记录确定按钮事件回调
    alertVC.ensureBlock = ensureBlock;
    /// 返回实例
    return alertVC;
}

#pragma mark - 初始化方法
/// 初始化方法
- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    return self;
}

#pragma mark - 开始加载
/// 开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 视图完成显示
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    /// 设置背景样式
    self.view.backgroundColor = RGBAOF(0x000000, 0.5);
}

#pragma mark - 初始化UI
- (void)buildView {
    
    /// 设置标题
    [self.titleLable setText:self.titleText];
    /// 设置描述按钮
    [self.radioBoxButton setTitle:self.messageText forState:UIControlStateNormal];
    [self.radioBoxButton setTitle:self.messageText forState:UIControlStateSelected];
    /// 设置取消按钮
    [self.cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
    /// 设置确定按钮
    [self.ensureButton setTitle:self.ensureTitle forState:UIControlStateNormal];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定单选按钮事件
    [[self.radioBoxButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        control.selected = !control.selected;
    }];
    
    /// 绑定取消按钮事件
    [[self.cancelButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 返回上一层
        [self dismissViewControllerAnimated:NO completion:nil];
        /// 取消按钮事件回调
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];
    
    /// 绑定确定按钮事件
    [[self.ensureButton rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 返回上一层
        [self dismissViewControllerAnimated:NO completion:nil];
        /// 确定按钮事件回调
        if (self.ensureBlock) {
            self.ensureBlock(self.radioBoxButton.selected);
        }
    }];
}

@end
