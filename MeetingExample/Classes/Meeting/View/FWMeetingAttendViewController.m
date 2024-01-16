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

/// 复制房间号码按钮
@property (weak, nonatomic) IBOutlet UIButton *pasteButton;
/// 麦克风按钮
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;
/// 摄像头按钮
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
/// 确定按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

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
    
    /// 设置背景色
    self.view.backgroundColor = RGBOF(0xF7F8FA);
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
        BOOL isCreate = YES;
        switch (value.integerValue) {
            case FWMeetingEntryTypeCreate:
                /// 创建房间
                title = NSLocalizedString(@"创建房间", nil);
                roomnoText = @"909 909 909";
                isCreate = YES;
                break;
            case FWMeetingEntryTypeJoin:
                /// 加入房间
                title = NSLocalizedString(@"加入房间", nil);
                roomnoText = nil;
                isCreate = NO;
                break;
        }
        /// 设置复制按钮隐藏状态
        self.pasteButton.hidden = !isCreate;
        /// 设置房间号码编辑状态
        self.roomnoTextField.userInteractionEnabled = !isCreate;
        /// 设置默认房间号码
        self.roomnoTextField.text = self.viewModel.roomnoText = roomnoText;
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
}

@end
