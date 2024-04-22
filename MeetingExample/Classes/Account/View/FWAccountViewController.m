//
//  FWAccountViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountViewController.h"
#import "FWAccountViewModel.h"

@interface FWAccountViewController ()

/// 标题标签
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/// 头像按钮
@property (weak, nonatomic) IBOutlet UIButton *avatarButton;
/// 昵称标签
@property (weak, nonatomic) IBOutlet UILabel *namenickLabel;
/// 用户标识
@property (weak, nonatomic) IBOutlet UILabel *accountidLabel;

/// 隐私按钮
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;
/// 免责按钮
@property (weak, nonatomic) IBOutlet UIButton *assertButton;
/// 关于按钮
@property (weak, nonatomic) IBOutlet UIButton *aboutusButton;
/// 退出按钮
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

/// ViewModel
@property (strong, nonatomic) FWAccountViewModel *viewModel;

@end

@implementation FWAccountViewController

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
}

#pragma mark - 页面出现前
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    /// 显示顶部导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 初始化UI
/// 初始化UI
- (void)buildView {
    
    /// 设置默认数据
    [self setupDefaultData];
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 设置标题
    self.titleLabel.text = NSLocalizedString(@"我的", nil);
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWAccountViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定头像按钮事件
    [[self.avatarButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 个人信息事件
        [self push:@"FWAccountInfoViewController"];
    }];
    
    /// 绑定隐私按钮事件
    [[self.privacyButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 隐私事件
        [self push:@"FWAccountPrivacyViewController"];
    }];
    
    /// 绑定免责按钮事件
    [[self.assertButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转网页加载页面
        [self push:@"FWAccountWebKitViewController" info:nil tag:FWAccountWebTypeAssert block:nil];
    }];
    
    /// 绑定关于按钮事件
    [[self.aboutusButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 关于我们事件
        [self push:@"FWAccountAboutusViewController"];
    }];
    
    /// 绑定退出按钮事件
    [[self.logoutButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 退出登录对话框
        [self logoutAlert];
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [FWToastBridge showToastAction];
        } else {
            [FWToastBridge hiddenToastAction];
        }
    }];
    
    /// 提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(id _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [FWToastBridge showToastAction:message];
        }
    }];
    
    /// 退出登录订阅
    [self.viewModel.logoutSubject subscribeNext:^(id _Nullable message) {
        /// 设置根视图为登录模块
        [[FWEntryBridge sharedManager] setWindowRootEntry];
    }];
}

#pragma mark - 退出登录对话框
/// 退出登录对话框
- (void)logoutAlert {
    
    @weakify(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您确定退出登录吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    UIAlertAction *ensureAction = [UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        @strongify(self);
        /// 组件登出
        [[MeetingKit sharedInstance] logout:nil onFailed:nil];
        /// 销毁用户信息
        [[FWStoreDataBridge sharedManager] logout];
        /// 退出登录事件
        [self.viewModel onLogoutEvent];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
