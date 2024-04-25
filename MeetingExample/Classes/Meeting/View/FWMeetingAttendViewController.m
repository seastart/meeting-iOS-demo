//
//  FWMeetingAttendViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingAttendViewController.h"
#import "FWMeetingAttendViewModel.h"

@interface FWMeetingAttendViewController ()

/// 房间号码
@property (weak, nonatomic) IBOutlet UITextField *roomnoTextField;
/// 用户昵称
@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
/// 房间号码输入框右边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *roomnoRightMargin;

/// 复制房间号码按钮
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
/// 麦克风按钮
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;
/// 摄像头按钮
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
/// 确定按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

/// 房间号码输入文本长度
@property (assign, nonatomic) NSInteger index;

/// ViewModel
@property (strong, nonatomic) FWMeetingAttendViewModel *viewModel;

@end

@implementation FWMeetingAttendViewController

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
    
    /// 重置房间号码输入文本长度
    self.index = 0;
    /// 设置背景色
    self.view.backgroundColor = RGBOF(0xF7F8FA);
    /// 注册监听文本进行编辑更改时回调
    [self.roomnoTextField addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWMeetingAttendViewModel alloc] initWithType:self.tag];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
    /// 绑定麦克风按钮状态
    RAC(self.microphoneButton, selected) = RACObserve(self.viewModel, isMicrophone);
    /// 绑定摄像头按钮状态
    RAC(self.cameraButton, selected) = RACObserve(self.viewModel, isCamera);
    
    /// 监听房间号码变化
    [self.roomnoTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.roomnoText = text;
    }];
    
    /// 监听用户昵称变化
    [self.nicknameTextField.rac_textSignal subscribeNext:^(NSString * _Nullable text) {
        @strongify(self);
        self.viewModel.nicknameText = text;
    }];
    
    /// 监听订阅参会入口类型
    [RACObserve(self.viewModel, type) subscribeNext:^(NSNumber * _Nullable value) {
        @strongify(self);
        NSString *title = nil;
        NSString *roomnoText = nil;
        CGFloat margin = 50.0;
        BOOL isCreate = YES;
        switch (value.integerValue) {
            case FWMeetingEntryTypeCreate:
                /// 创建房间
                title = NSLocalizedString(@"创建房间", nil);
                roomnoText = @"909909909";
                margin = 50.0;
                isCreate = YES;
                break;
            case FWMeetingEntryTypeJoin:
                /// 加入房间
                title = NSLocalizedString(@"加入房间", nil);
                roomnoText = nil;
                margin = 16.0;
                isCreate = NO;
                break;
        }
        /// 设置复制按钮隐藏状态
        self.pasteButton.hidden = !isCreate;
        /// 设置房间号码编辑状态
        self.roomnoTextField.userInteractionEnabled = !isCreate;
        /// 设置默认房间号码
        self.roomnoTextField.text = self.viewModel.roomnoText = [FWToolBridge roomnoDiversionString:roomnoText];
        /// 设置默认参会昵称
        self.nicknameTextField.text = self.viewModel.nicknameText = [FWStoreDataBridge sharedManager].userInfo.userId;
        /// 设置房间号码输入框右边距
        self.roomnoRightMargin.constant = margin;
        /// 设置标题
        self.navigationItem.title = title;
        /// 设置确定按钮标题
        [self.confirmButton setTitle:title forState:UIControlStateNormal];
    }];
    
    /// 绑定复制房间号码按钮事件
    [[self.pasteButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 复制房间号码
        [self.viewModel onCopyRoomNo];
    }];
    
    /// 绑定麦克风按钮事件
    [[self.microphoneButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isMicrophone = !self.viewModel.isMicrophone;
    }];
    
    /// 绑定摄像头按钮事件
    [[self.cameraButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        self.viewModel.isCamera = !self.viewModel.isCamera;
    }];
    
    /// 绑定确定按钮事件
    [[self.confirmButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 请求确定
        [self.viewModel onConfirmEvent];
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
    
    /// 监听入会成功订阅
    [self.viewModel.succeedSubject subscribeNext:^(id _Nullable value) {
        @strongify(self);
        /// 跳转房间页面
        [self push:@"FWRoomViewController" info:value block:nil];
    }];
}

#pragma mark - 文本进行编辑更改时回调
/// 文本进行编辑更改时回调
/// - Parameter textField: 文本框对象
- (void)textFieldDidEditing:(UITextField *)textField {
    
    if (textField == self.roomnoTextField) {
        if (textField.text.length > self.index) {
            if (textField.text.length == 4 || textField.text.length == 8) {
                /// 文本输入
                NSMutableString *str = [[NSMutableString alloc ] initWithString:textField.text];
                [str insertString:@" " atIndex:(textField.text.length - 1)];
                textField.text = str;
            } if (textField.text.length >= 11) {
                /// 文本输入完成
                textField.text = [textField.text substringToIndex:11];
                /// [textField resignFirstResponder];
            }
            self.index = textField.text.length;
        } else if (textField.text.length < self.index) {
            /// 文本删除
            if (textField.text.length == 4 || textField.text.length == 8) {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length - 1)];
            }
            self.index = textField.text.length;
        }
    }
}

@end
