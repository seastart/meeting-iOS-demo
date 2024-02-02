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
    
    /// 聊天消息本地化
    [[FWMessageManager sharedManager] sendChatWithContent:self.contentText];
    /// 通知发送消息订阅
    [self.sendSubject sendNext:nil];
}

@end
