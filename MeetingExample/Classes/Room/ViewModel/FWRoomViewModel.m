//
//  FWRoomViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2023/3/2.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWRoomViewModel.h"

@interface FWRoomViewModel()

@end

@implementation FWRoomViewModel

#pragma mark - 初始化方法
/// 初始化方法
- (instancetype)initWithMeetingEnterModel:(FWMeetingEnterModel *)enterModel {
    
    if (self = [super init]) {
        _loading = NO;
        _enterModel = enterModel;
        _toastSubject = [RACSubject subject];
        _succeedSubject = [RACSubject subject];
    }
    return self;
}

#pragma mark - 请求举手
/// 请求举手
/// - Parameter handupType: 申请类型
- (void)requestHandup:(SEAHandupType)handupType {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 用户请求举手
    [[MeetingKit sharedInstance] requestHandup:handupType onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:@"举手成功，等待主持人操作。"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"用户请求举手失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark - 取消举手
/// 取消举手
/// - Parameter handupType: 申请类型
- (void)cancelHandup:(SEAHandupType)handupType {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 用户取消举手
    [[MeetingKit sharedInstance] cancelHandup:handupType onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:@"举手已取消"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"用户取消举手失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

#pragma mark 主持人处理举手请求
/// 主持人处理举手请求
/// - Parameters:
/// @param userId 用户标识
/// @param handupType 举手申请类型
/// @param approve 处理举手申请，YES-同意 NO-拒绝
- (void)adminConfirmHandup:(NSString *)userId handupType:(SEAHandupType)handupType approve:(BOOL)approve {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 主持人处理举手请求
    [[MeetingKit sharedInstance] adminConfirmHandup:userId handupType:handupType approve:approve onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功回调
        [self.succeedSubject sendNext:@"举手请求已完成处理"];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"主持人处理举手请求失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

@end
