//
//  FWMessageViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2023/2/28.
//  Copyright © 2023 SailorGa. All rights reserved.
//

#import "FWMessageViewModel.h"

@implementation FWMessageViewModel

#pragma mark - 初始化方法
/// 初始化方法
- (instancetype)initWithRoom:(BOOL)isRoom {
    
    if (self = [super init]) {
        _sendSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _accountNoText = @"0F86FE9E-1F5A-4967-A255-450DB83CD87F";
        _contentText = @"这是一条消息内容";
        _isRoom = isRoom;
        _loading = NO;
    }
    return self;
}

#pragma mark - 发送消息事件
/// 发送消息事件
- (void)onSendEvent {
    
    if (kStringIsEmpty(self.accountNoText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入用户编号", nil)];
        return;
    }
    
    if (kStringIsEmpty(self.contentText)) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入消息内容", nil)];
        return;
    }
    
    if (![self.contentText isContentEffective]) {
        [self.toastSubject sendNext:NSLocalizedString(@"请输入有效的消息内容", nil)];
        return;
    }
    
//    /// 声明错误码
//    RTCEngineError errorCode = RTCEngineErrorOK;
//    
//    if (self.isRoom) {
//        /// 发送房间内消息
//        errorCode = [[FWEngineBridge sharedManager] sendRoomMessageWithContent:self.contentText action:@"default"];
//    } else {
//        /// 发送房间外消息
//        errorCode = [[FWEngineBridge sharedManager] sendMessageWithUserIds:@[self.accountNoText] content:self.contentText action:@"default"];
//    }
//    
//    if (errorCode != RTCEngineErrorOK) {
//        NSString *toastStr = [NSString stringWithFormat:@"%@ errorCode = %ld", self.isRoom ? @"发送房间内消息失败": @"发送房间外消息失败", errorCode];
//        [self.toastSubject sendNext:toastStr];
//        SGLOG(@"%@", toastStr);
//        return;
//    }
    
    /// 聊天消息本地化
    [[FWMessageChatManager sharedManager] sendChatWithContent:self.contentText];
    /// 通知发送消息订阅
    [self.sendSubject sendNext:nil];
}

@end
