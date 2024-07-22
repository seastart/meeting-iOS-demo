//
//  FWRegisterUserinfoViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/8.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWRegisterUserinfoViewModel.h"

@interface FWRegisterUserinfoViewModel()

@end

@implementation FWRegisterUserinfoViewModel

#pragma mark - 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _toastSubject = [RACSubject subject];
        _confirmSubject = [RACSubject subject];
        _isSexState = YES;
        _loading = NO;
    }
    return self;
}

#pragma mark - 请求确定
/// 请求确定
- (void)onConfirmEvent {
    
    if (kStringIsEmpty(self.namenickText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请设置您的昵称", nil)];
        return;
    }
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 创建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 用户昵称
    [params setValue:self.namenickText forKey:@"nickname"];
    /// 声明用户头像
    NSString *imageName = FWREMOTEAVATAR1();
    /// 根据性别标识设置头像
    if (self.isSexState) {
        /// 标识男性
        imageName = FWREMOTEAVATAR1();
    } else {
        /// 标识女性
        imageName = FWREMOTEAVATAR2();
    }
    /// 用户头像
    [params setValue:imageName forKey:@"avatar"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWREQUESTMEMBERMEUPDATE params:params className:@"FWUserModel" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功处理
        if (result) {
            /// 获取请求结果对象
            FWUserModel *userModel = (FWUserModel *)data;
            /// 更新用户基本数据
            [[FWStoreDataBridge sharedManager] updateUserInfo:userModel.data.nickname avatar:userModel.data.avatar];
            /// 回调确定成功订阅
            [self.confirmSubject sendNext:nil];
        } else {
            /// 提示信息
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

@end
