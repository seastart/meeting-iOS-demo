//
//  FWRegisterViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/3.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRegisterViewController.h"
#import "FWRegisterViewModel.h"

@interface FWRegisterViewController ()

/// 验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *vcodeButton;
/// 密码明文按钮
@property (weak, nonatomic) IBOutlet UIButton *secureButton;
/// 密码确认明文按钮
@property (weak, nonatomic) IBOutlet UIButton *secureCheckButton;
/// 注册按钮
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
/// 协议选择按钮
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
/// 用户协议按钮
@property (weak, nonatomic) IBOutlet UIButton *agreementButton;
/// 隐私协议按钮
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;

/// 手机号码
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
/// 验证码
@property (weak, nonatomic) IBOutlet UITextField *vcodeTextField;
/// 用户密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
/// 用户确认密码
@property (weak, nonatomic) IBOutlet UITextField *passwordCheckTextField;

/// 验证码计时器
@property (strong, nonatomic) dispatch_source_t timer;

/// ViewModel
@property (strong, nonatomic) FWRegisterViewModel *viewModel;

@end

@implementation FWRegisterViewController

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

#pragma mark - 页面即将消失
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    /// 释放计时器
    /// [self invalidate];
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
    self.navigationItem.title = NSLocalizedString(@"注册", nil);
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWRegisterViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定用户协议按钮状态
    RAC(self.selectButton, selected) = RACObserve(self.viewModel, isAgreement);
    /// 绑定密码按钮明文状态
    RAC(self.secureButton, selected) = RACObserve(self.viewModel, isSecure);
    /// 绑定确认密码按钮明文状态
    RAC(self.secureCheckButton, selected) = RACObserve(self.viewModel, isSecureCheck);
    /// 绑定密码框明文状态
    RAC(self.passwordTextField, secureTextEntry) = RACObserve(self.viewModel, isSecure);
    /// 绑定确认密码框明文状态
    RAC(self.passwordCheckTextField, secureTextEntry) = RACObserve(self.viewModel, isSecureCheck);
    
    /// 监听手机号码变化
    [self.mobileTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.mobileText = text;
    }];
    
    /// 监听验证码变化
    [self.vcodeTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.vcodeText = text;
    }];
    
    /// 监听用户密码变化
    [self.passwordTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.passwordText = text;
    }];
    
    /// 监听确认用户密码变化
    [self.passwordCheckTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.passwordCheckText = text;
    }];
    
    /// 绑定验证码按钮事件
    [[self.vcodeButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 获取短信验证码
        [self.viewModel getMobileCode];
    }];
    
    /// 绑定密码明文按钮事件
    [[self.secureButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isSecure = !self.viewModel.isSecure;
    }];
    
    /// 绑定确认密码明文按钮事件
    [[self.secureCheckButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isSecureCheck = !self.viewModel.isSecureCheck;
    }];
    
    /// 绑定协议选择按钮事件
    [[self.selectButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isAgreement = !self.viewModel.isAgreement;
    }];
    
    /// 绑定用户协议按钮事件
    [[self.agreementButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转到用户协议
        [self presentUserAgreement];
    }];
    
    /// 绑定隐私协议按钮事件
    [[self.privacyButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转隐私协议
        [self presentPrivacyAgreement];
    }];
    
    /// 绑定注册按钮事件
    [[self.registerButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 注册事件
        [self.viewModel onRegisterEvent];
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
    
    /// 监听验证码获取成功订阅
    [self.viewModel.mobileCodeSubject subscribeNext:^(NSString * _Nullable value) {
        @strongify(self);
        if (!kStringIsEmpty(value)) {
            [SVProgressHUD showInfoWithStatus:value];
        }
        /// 获取验证码成功处理
        [self countdownAction];
    }];
    
    /// 监听注册成功订阅
    [self.viewModel.registerSubject subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        /// 注册按钮事件
        [self push:@"FWRegisterUserinfoViewController"];
    }];
}

#pragma mark - 验证码按钮读秒
/// 验证码按钮读秒
- (void)countdownAction {
    
    /// 倒计时时间
    __block NSInteger time = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    /// 每秒执行
    dispatch_source_set_timer(self.timer,DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        /// 倒计时结束，关闭
        if(time <= 0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                /// 设置常规效果的样式
                [self noneStyle];
            });
        } else {
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                /// 设置label读秒效果
                [self countdownStyle:seconds];
            });
            time--;
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark - -------- 验证码按钮效果 ---------
#pragma mark 常规效果
- (void)noneStyle {
    
    [self.vcodeButton setTitle:NSLocalizedString(@"发送验证码", nil) forState:UIControlStateNormal];
    [self.vcodeButton setTitleColor:RGBOF(0x0039B3) forState:UIControlStateNormal];
    self.vcodeButton.userInteractionEnabled = YES;
}

#pragma mark 读秒效果
- (void)countdownStyle:(int)seconds {
    
    [self.vcodeButton setTitle:[NSString stringWithFormat:@"%.2dS%@", seconds, NSLocalizedString(@"后重发", nil)] forState:UIControlStateNormal];
    [self.vcodeButton setTitleColor:RGBOF(0x999999) forState:UIControlStateNormal];
    self.vcodeButton.userInteractionEnabled = NO;
}

#pragma mark - 释放计时器
/// 释放计时器
- (void)invalidate {
    
    if (!self.timer) {
        /// 定时器为空不做释放
        return;
    }
    /// 重置按钮回常规效果
    [self noneStyle];
    /// 释放定时器
    dispatch_source_cancel(self.timer);
    /// 置空定时器
    self.timer = nil;
}

@end
