//
//  FWAccountInfoViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/17.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountInfoViewController.h"
#import "FWAccountInfoViewModel.h"

@interface FWAccountInfoViewController ()

/// 男性头像按钮
@property (weak, nonatomic) IBOutlet UIButton *manAvatarButton;
/// 女性头像按钮
@property (weak, nonatomic) IBOutlet UIButton *womanAvatarButton;
/// 男性头像选中按钮
@property (weak, nonatomic) IBOutlet UIButton *manSelectButton;
/// 女性头像选中按钮
@property (weak, nonatomic) IBOutlet UIButton *womanSelectButton;
/// 确认按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

/// 用户昵称
@property (weak, nonatomic) IBOutlet UITextField *namenickTextField;

/// ViewModel
@property (strong, nonatomic) FWAccountInfoViewModel *viewModel;

@end

@implementation FWAccountInfoViewController

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
    
    /// 设置ViewModel
    [self setupViewModel];
    /// 绑定动态响应信号
    [self bindSignal];
    /// 设置默认数据
    [self setupDefaultData];
}

#pragma mark - 设置默认数据
- (void)setupDefaultData {
    
    /// 设置标题
    self.navigationItem.title = NSLocalizedString(@"个人信息", nil);
    /// 获取用户昵称
    NSString *nickname = [[FWStoreDataBridge sharedManager] getNickname];
    /// 设置当前昵称
    self.namenickTextField.text = self.viewModel.namenickText = nickname;
    /// 获取用户头像
    NSString *imageName = [[FWStoreDataBridge sharedManager] getAvatar];
    /// 声明性别标识
    BOOL isSexState = YES;
    /// 根据当前头像设置性别标识
    if ([imageName isEqualToString:FWDEFAULTAVATAR]) {
        /// 标识女性
        isSexState = NO;
    } else {
        /// 标识男性
        isSexState = YES;
    }
    /// 设置性别标识
    self.viewModel.isSexState = isSexState;
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWAccountInfoViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 监听用户昵称变化
    [self.namenickTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.namenickText = text;
    }];
    
    /// 绑定男性头像按钮事件
    [[self.manAvatarButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isSexState = YES;
    }];
    
    /// 绑定女性头像按钮事件
    [[self.womanAvatarButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isSexState = NO;
    }];
    
    /// 绑定确定按钮事件
    [[self.confirmButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 请求确定
        [self.viewModel onConfirmEvent];
    }];
    
    /// 监听订阅性别标识
    [RACObserve(self.viewModel, isSexState) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        self.manSelectButton.hidden = !value.boolValue;
        self.womanSelectButton.hidden = value.boolValue;
    }];
    
    /// 监听订阅加载状态
    [RACObserve(self.viewModel, loading) subscribeNext:^(NSNumber * _Nullable value) {
        if(value.boolValue) {
            [SVProgressHUD show];
        } else {
            [SVProgressHUD dismiss];
        }
    }];
    
    /// 监听提示框订阅
    [self.viewModel.toastSubject subscribeNext:^(NSString * _Nullable message) {
        if (!kStringIsEmpty(message)) {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }];
    
    /// 监听确定成功订阅
    [self.viewModel.confirmSubject subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        /// 离开个人信息页面
        [self pop:1];
    }];
}

@end
