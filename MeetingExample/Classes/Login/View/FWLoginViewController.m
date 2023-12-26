//
//  FWLoginViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2021/10/27.
//  Copyright © 2021 SailorGa. All rights reserved.
//

#import "FWLoginViewController.h"
#import "FWLoginViewModel.h"

@interface FWLoginViewController ()

/// 服务地址
@property (weak, nonatomic) IBOutlet UITextField *serverTextField;
/// 用户签名
@property (weak, nonatomic) IBOutlet UITextField *userSigTextField;
/// 用户昵称
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
/// 登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
/// 当前SDK版本
@property (weak, nonatomic) IBOutlet UILabel *versionLable;
/// 编译构建时间
@property (weak, nonatomic) IBOutlet UILabel *buildLable;

/// ViewModel
@property (strong, nonatomic) FWLoginViewModel *viewModel;

@end

@implementation FWLoginViewController

#pragma mark - 页面开始加载
- (void)viewDidLoad {
    
    [super viewDidLoad];
    /// 初始化UI
    [self buildView];
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
    
    self.serverTextField.text = [[FWStoreDataBridge sharedManager] getServerUrl];
    self.userSigTextField.text = [[FWStoreDataBridge sharedManager] getUserSig];
    self.nicknameTextField.text = [[FWStoreDataBridge sharedManager] getNickname];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWLoginViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定编译构建时间
    RAC(self.buildLable, text) = RACObserve(self.viewModel, buildText);
    /// 绑定版本信息
    RAC(self.versionLable, text) = RACObserve(self.viewModel, versionText);
    
    /// 监听服务地址
    [self.serverTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.serverText = [FWToolBridge clearMarginsBlank:text];
    }];
    
    /// 监听用户签名
    [self.userSigTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.userSigText = [FWToolBridge clearMarginsBlank:text];
    }];
    
    /// 监听用户昵称
    [self.nicknameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.nicknameText = [FWToolBridge clearMarginsBlank:text];
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
    
    /// 登录成功订阅
    [self.viewModel.loginSubject subscribeNext:^(NSNumber * _Nullable value) {
        /// 设置根视图为首页模块
        [[FWEntryBridge sharedManager] setWindowRootHome];
    }];
    
    /// 绑定登录按钮事件
    [[self.loginButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 登录事件
        [self.viewModel onLoginEvent];
    }];
}

@end
