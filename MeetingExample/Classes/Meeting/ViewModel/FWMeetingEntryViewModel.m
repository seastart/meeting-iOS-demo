//
//  FWMeetingEntryViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/1/16.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWMeetingEntryViewModel.h"

@implementation FWMeetingEntryViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        _succeedSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

/// 创建房间
/// - Parameter title: 房间标题
- (void)createRoom:(NSString *)title {
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 构建会议参数
    SEAMeetingParam *meetingParam = [[SEAMeetingParam alloc] init];
    meetingParam.title = title;
    /// 创建房间
    [[MeetingKit sharedInstance] createRoom:meetingParam onSuccess:^(id _Nullable data) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 获取房间号码
        NSString *roomNo = (NSString *)data;
        /// 回调请求成功
        [self.succeedSubject sendNext:roomNo];
    } onFailed:^(SEAError code, NSString * _Nonnull message) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 构造日志信息
        NSString *logStr = [NSString stringWithFormat:@"创建房间失败 code = %ld, message = %@", code, message];
        [self.toastSubject sendNext:logStr];
        SGLOG(@"%@", logStr);
    }];
}

@end
