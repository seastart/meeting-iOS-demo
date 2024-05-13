//
//  FWMeetingEntryViewController.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingEntryViewController.h"
#import "FWMeetingEntryViewModel.h"

@interface FWMeetingEntryViewController ()

/// 创建房间
@property (weak, nonatomic) IBOutlet UIButton *createdButton;
/// 加入房间
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

/// ViewModel
@property (strong, nonatomic) FWMeetingEntryViewModel *viewModel;

@end

@implementation FWMeetingEntryViewController

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
    
    /// 设置标题
    self.navigationItem.title = NSLocalizedString(@"多人音视频房间", nil);
    /// 设置按钮边框颜色
    self.joinButton.layer.borderColor = RGBOF(0x0039B3).CGColor;
    self.joinButton.layer.borderWidth = 0.5f;
}

#pragma mark - 设置ViewModel
/// 设置ViewModel
- (void)setupViewModel {
    
    /// 初始化ViewModel
    self.viewModel = [[FWMeetingEntryViewModel alloc] init];
    /// ViewModel关联Class
    self.viewModel.viewClass = [self class];
}

#pragma mark - 绑定信号
/// 绑定信号
- (void)bindSignal {
    
    @weakify(self);
    
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
    
    /// 创建房间成功订阅
    [self.viewModel.succeedSubject subscribeNext:^(id _Nullable message) {
        @strongify(self);
        /// 获取房间号码
        NSString *roomNo = (NSString *)message;
        /// 跳转加入房间页面
        [self push:@"FWMeetingAttendViewController" info:roomNo tag:FWMeetingEntryTypeCreate block:nil];
    }];
    
    /// 绑定创建房间按钮事件
    [[self.createdButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 创建房间
        [self.viewModel createRoom:@"SailorGa 的测试会议"];
    }];
    
    /// 绑定加入房间按钮事件
    [[self.joinButton rac_signalForControlEvents :UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable control) {
        @strongify(self);
        /// 跳转加入房间页面
        [self push:@"FWMeetingAttendViewController" info:nil tag:FWMeetingEntryTypeJoin block:nil];
    }];
}

@end
