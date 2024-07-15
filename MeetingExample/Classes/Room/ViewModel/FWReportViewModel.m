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
        _itemArray = [[NSMutableArray alloc] initWithObjects:
                      @{@"type" : @(0), @"title" : NSLocalizedString(@"政治敏感", nil), @"selected" : @(YES)},
                      @{@"type" : @(1), @"title" : NSLocalizedString(@"低俗色情", nil), @"selected" : @(NO)},
                      @{@"type" : @(2), @"title" : NSLocalizedString(@"攻击辱骂", nil), @"selected" : @(NO)},
                      @{@"type" : @(3), @"title" : NSLocalizedString(@"血腥暴力", nil), @"selected" : @(NO)},
                      @{@"type" : @(4), @"title" : NSLocalizedString(@"不良广告", nil), @"selected" : @(NO)},
                      @{@"type" : @(5), @"title" : NSLocalizedString(@"涉嫌诈骗", nil), @"selected" : @(NO)},
                      @{@"type" : @(6), @"title" : NSLocalizedString(@"违法信息", nil), @"selected" : @(NO)},
                      @{@"type" : @(7), @"title" : NSLocalizedString(@"其他违规", nil), @"selected" : @(NO)},
                      nil];
        _selectedArray = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:0], nil];
        _submitSubject = [RACSubject subject];
        _toastSubject = [RACSubject subject];
        _loading = NO;
    }
    return self;
}

#pragma mark - 提交举报事件
/// 提交举报事件
- (void)onSubmitEvent {
    
    if (kArrayIsEmpty(self.selectedArray)) {
        [self.toastSubject sendNext:NSLocalizedString(@"您至少选择一个举报标签", nil)];
        return;
    }
    
    @weakify(self);
    /// 标记加载状态
    self.loading = YES;
    /// 创建请求类型列表
    NSMutableArray <NSString *> *categoryArray = [NSMutableArray arrayWithCapacity:self.selectedArray.count];
    /// 遍历选择列表组织请求数据
    for (NSNumber *number in self.selectedArray) {
        /// 获取项目数据
        NSDictionary *itemDic = [self.itemArray objectAtIndex:number.integerValue];
        /// 标题添加到列表
        [categoryArray addObject:[itemDic objectForKey:@"title"]];
    }
    /// 创建请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    /// 举报类型
    [params setValue:categoryArray forKey:@"category"];
    /// 举报内容
    [params setValue:self.describeText forKey:@"description"];
    /// 发起请求
    [[FWNetworkBridge sharedManager] POST:FWREQUESTMEMBERVIOLATION params:params className:@"FWBaseModel" resultBlock:^(BOOL result, id  _Nullable data, NSString * _Nullable errorMsg) {
        @strongify(self);
        /// 恢复加载状态
        self.loading = NO;
        /// 请求成功处理
        if (result) {
            /// 通知提交成功订阅
            [self.submitSubject sendNext:nil];
        } else {
            /// 提示信息
            [self.toastSubject sendNext:errorMsg];
        }
    }];
}

@end
