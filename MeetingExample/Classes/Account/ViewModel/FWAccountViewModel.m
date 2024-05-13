//
//  FWAccountViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/15.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWAccountViewModel.h"

@implementation FWAccountViewModel

/// 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _logoutSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

/// 退出登录事件
- (void)onLogoutEvent {
    
    /// 标记加载状态
    self.loading = YES;
    /// 创建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 设备类型
    [params setValue:@(SEATerminalTypeiOS) forKey:@"device_type"];
    /// 用户标识
    [params setValue:[FWStoreDataBridge sharedManager].userInfo.userId forKey:@"user_id"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWUSERLOGOUT params:params className:@"FWBaseModel" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        /// 恢复加载状态
        self.loading = NO;
        /// 组件登出
        [[MeetingKit sharedInstance] logout:nil onFailed:nil];
        /// 销毁用户信息
        [[FWStoreDataBridge sharedManager] logout];
        /// 通知退出登录订阅
        [self.logoutSubject sendNext:nil];
    }];
}

@end
