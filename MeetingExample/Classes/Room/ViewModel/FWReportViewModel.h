//
//  FWReportViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/4.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWReportViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 选中索引列表
@property (nonatomic, strong) NSMutableArray *selectedArray;
/// 描述内容
@property (nonatomic, copy, nullable) NSString *describeText;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;
/// 提交成功订阅
@property (nonatomic, strong, readonly) RACSubject *submitSubject;

/// 提交举报事件
- (void)onSubmitEvent;

@end

NS_ASSUME_NONNULL_END
