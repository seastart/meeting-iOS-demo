//
//  FWHomeViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/25.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWHomeViewController.h"
#import "FWHomeViewModel.h"

@interface FWHomeViewController ()

/// 房间号码
@property (weak, nonatomic) IBOutlet UITextField *roomNoTextField;
/// 加入房间按钮
@property (weak, nonatomic) IBOutlet UIButton *joinRoomButton;
/// 退出登录按钮
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

/// ViewModel
@property (strong, nonatomic) FWHomeViewModel *viewModel;

@end

@implementation FWHomeViewController

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    self.navigationItem.title = NSLocalizedString(@"海星音视频", nil);
    self.roomNoTextField.text = [[FWStoreDataBridge sharedManager] getRoomNo];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWHomeViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听房间号码
    [self.roomNoTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.roomNoText = [FWToolBridge clearMarginsBlank:text];
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
    
    /// 加入房间订阅
    [self.viewModel.joinRoomSubject subscribeNext:^(id _Nullable value) {
        @strongify(self);
        /// 加入房间
        [self joinRoomWithRoomNo:value];
    }];
    
    /// 退出登录订阅
    [self.viewModel.logoutSubject subscribeNext:^(id _Nullable value) {
        /// 设置根视图为登录模块
        [[FWEntryBridge sharedManager] setWindowRootEntry];
    }];
    
    /// 绑定加入房间按钮事件
    [[self.joinRoomButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 调整按钮激活状态
        self.joinRoomButton.enabled = NO;
        /// 加入房间事件
        [self.viewModel onJoinRoomEvent];
        /// 延迟重置按钮激活状态
        FWDispatchAfter((int64_t)(1.5 * NSEC_PER_SEC), ^{
            self.joinRoomButton.enabled = YES;
        });
    }];
    
    /// 绑定退出登录按钮事件
    [[self.logoutButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 退出登录对话框
        [self logoutAlert];
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
        /// 销毁用户信息
        [[FWStoreDataBridge sharedManager] logout];
        /// 退出登录事件
        [self.viewModel onLogoutEvent];
    }];
    [alert addAction:cancelAction];
    [alert addAction:ensureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 加入房间
/// 加入房间
/// @param roomNo 房间号码
- (void)joinRoomWithRoomNo:(NSString * _Nonnull)roomNo {
    
    /// 跳转房间页面
    [self push:@"FWRoomViewController" info:roomNo block:nil];
}

@end
