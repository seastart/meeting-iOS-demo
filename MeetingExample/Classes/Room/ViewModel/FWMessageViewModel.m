//
//  FWMessageViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/2.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMessageViewModel.h"

@implementation FWMessageViewModel

#pragma mark - 初始化ViewModel
/// 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _sendSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

#pragma mark - 发送消息事件
/// 发送消息事件
- (void)onSendEvent {
    
    if (kStringIsEmpty(self.contentText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入消息内容", nil)];
        return;
    }
    
    if (![self.contentText isContentEffective]) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入有效的消息内容", nil)];
        return;
    }
    
    @weakify(self);
    /// 用户发送聊天消息
    [[MeetingKit sharedInstance] sendRoomChatMessage:self.contentText messageType:SEAMessageTypeText targetId:nil onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 获取消息内容
        NSString *message = (NSString *)data;
        /// 通知发送消息订阅
        [self.sendSubject sendNext:message];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求发送聊天消息失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:toastStr];
        SGLOG(@"%@", toastStr);
    }];
}

#pragma mark - 发送自定义消息事件
/// 发送自定义消息事件
- (void)onSendCustomEvent {
    
    @weakify(self);
    /// 用户发送自定义消息
    [[MeetingKit sharedInstance] sendRoomCustomMessage:@"{\"meeting_id\":\"snzm8w\",\"msg_id\":\"svz69z\",\"msg_type\":1,\"msg\":\"\u4e00\u6837\u4e00\u6837\",\"user_id\":\"15606946786\"}" targetId:nil onSuccess:^(id  _Nullable data) {
        @strongify(self);
        /// 获取消息内容
        NSString *message = (NSString *)data;
        /// 通知发送消息订阅
        [self.sendSubject sendNext:message];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 构造日志信息
        NSString *toastStr = [NSString stringWithFormat:@"请求发送自定义消息失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:toastStr];
        SGLOG(@"%@", toastStr);
    }];
}

@end
