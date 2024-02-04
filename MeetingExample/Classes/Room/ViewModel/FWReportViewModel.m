//
//  FWReportViewModel.m
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import "FWReportViewModel.h"

@implementation FWReportViewModel

#pragma mark - 初始化ViewModel
/// 初始化ViewModel
- (instancetype)init {
    
    if (self = [super init]) {
        _submitSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _selectedIndex = 0;
        _loading = NO;
    }
    return self;
}

#pragma mark - 提交举报事件
/// 提交举报事件
- (void)onSubmitEvent {
    
    /// 通知提交成功订阅
    [self.submitSubject sendNext:nil];
}

@end
