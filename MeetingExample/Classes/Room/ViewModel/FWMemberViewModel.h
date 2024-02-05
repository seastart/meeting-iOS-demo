//
//  FWMemberViewModel.h
//  MeetingExample
//
//  Created by SailorGa on 2024/2/5.
//  Copyright © 2024 SailorGa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWMemberViewModel : NSObject

/// 关联Class
@property (nonatomic, assign) Class viewClass;
/// 是否在加载状态
@property (nonatomic, assign) BOOL loading;

/// 全员静音状态，YES-全体静音 NO-取消全体静音
@property (nonatomic, assign) BOOL frequencyAllEnabled;
/// 全员禁画状态，YES-全体禁画 NO-取消全体禁画
@property (nonatomic, assign) BOOL framesAllEnabled;

/// 提示框订阅
@property (nonatomic, strong, readonly) RACSubject *toastSubject;

@end

NS_ASSUME_NONNULL_END
